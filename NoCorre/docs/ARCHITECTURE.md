# Arquitetura — NoCorre Companion App

## Visão Geral (MVVM + Clean Architecture)

```
┌─────────────────────────────────────────────────────┐
│ Presentation Layer (UI + ViewModel)                 │
│ ├── Activities, Fragments, Composables              │
│ ├── ViewModels (LiveData/StateFlow)                 │
│ └── Adapters, Listeners                             │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ Domain Layer (Business Logic)                       │
│ ├── Use Cases                                       │
│ ├── Domain Models                                   │
│ └── Repository Interfaces                          │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ Data Layer (Repository Implementation)              │
│ ├── Local (Room + SharedPreferences)                │
│ ├── Remote (Retrofit + OkHttp)                      │
│ └── Repositories (abstraem as sources)              │
└─────────────────────────────────────────────────────┘
```

## Fluxo de Dados: Trip Detection

```
[LocationManager/FusedLocationProvider]
         ↓
[LocationCallback]
         ↓
[TripDetectionAlgorithm]
  ├─ Speed > 2.0 m/s? → Iniciando corrida
  ├─ Speed < 2.0 m/s por > 3 min? → Encerrando corrida
  └─ Acelerômetro confirma movimento? → Alta confiança
         ↓
[TripRepository.insertTrip()]
         ↓
[Room Database]
         ↓
[OverlayViewModel observa mudanças]
         ↓
[UI atualiza em tempo real]
```

## Camadas Principais

### 1. Service Layer

#### LocationTrackingService (ForegroundService)
- Roda continuamente em background
- Coleta GPS a cada 30 segundos
- Detecta início/fim de corridas
- Notificação persistente obrigatória

#### NotificationListenerService
- Escuta notificações da Uber/iFood
- Extrai valores com regex
- Armazena com confidence score
- Deduplica automaticamente

#### OverlayService
- Gerencia bubble flutuante
- Atualiza valores em tempo real
- Permite drag & drop
- Sobrepõe apps da Uber

### 2. ViewModel Layer

#### OverlayViewModel
```kotlin
LiveData<DailyStats> {
  earnings: Double,
  distanceKm: Double,
  onlineMinutes: Int,
  estimatedCost: Double
}
```

#### TripsViewModel
```kotlin
LiveData<List<Trip>> (todos os trips do dia)
LiveData<Trip> (trip selecionada para edição)
```

#### SettingsViewModel
```kotlin
LiveData<UserSettings> {
  vehicleType: String,
  fuelConsumption: Double,
  syncEnabled: Boolean
}
```

### 3. Repository Pattern

Cada repositório abstrai as fontes de dados:

```kotlin
interface TripRepository {
  suspend fun getTodaysTrips(): List<Trip>
  suspend fun insertTrip(trip: Trip)
  suspend fun getUnsyncedTrips(): List<Trip>
  suspend fun markAsSynced(tripId: String)
}

// Implementação combina local + remote
class TripRepositoryImpl(
  private val tripDao: TripDao,
  private val gigFlowApi: GigFlowApi
) : TripRepository {
  // lógica de sincronização
}
```

### 4. Use Cases

Cada use case faz **uma coisa**:

```kotlin
class DetectTripUseCase(
  private val tripRepository: TripRepository,
  private val locationUtils: LocationUtils
) {
  suspend operator fun invoke(locations: List<Location>): Trip? {
    // calcula distância, duração, velocidade média
    // retorna Trip ou null
  }
}

class CalculateExpensesUseCase(
  private val fuelRepository: FuelRepository,
  private val settingsRepository: SettingsRepository
) {
  suspend operator fun invoke(trip: Trip): Expense {
    // calcula combustível + depreciation + manutenção
  }
}
```

### 5. Parsers (Notification)

```kotlin
interface NotificationParser {
  fun parse(text: String): NotificationCapture?
}

class UberNotificationParser : NotificationParser {
  override fun parse(text: String): NotificationCapture? {
    val regex = Regex("""ganhou\s+R\$\s+([\d.,]+)""")
    val amount = regex.find(text)?.groupValues?.get(1)
      ?.replace(",", ".")
      ?.toDoubleOrNull() ?: return null
    
    return NotificationCapture(
      amount = amount,
      confidence = 0.95f,
      timestamp = System.currentTimeMillis()
    )
  }
}

class NotificationParserFactory {
  fun getParser(packageName: String): NotificationParser? = when (packageName) {
    "com.ubercab" -> UberNotificationParser()
    "br.com.brainweb.ifood" -> iFoodNotificationParser()
    "com.rappi" -> RappiNotificationParser()
    else -> null
  }
}
```

## Dependency Injection (Hilt)

Estrutura de módulos:

```kotlin
@Module
@InstallIn(SingletonComponent::class)
object AppModule {
  @Provides
  @Singleton
  fun provideContext(): Context = /* ... */
  
  @Provides
  @Singleton
  fun provideGigFlowApi(): GigFlowApi {
    return Retrofit.Builder()
      .baseUrl("https://api.gigflow.dev/")
      .addConverterFactory(GsonConverterFactory.create())
      .build()
      .create(GigFlowApi::class.java)
  }
}

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {
  @Provides
  @Singleton
  fun provideDatabase(context: Context): AppDatabase {
    return Room.databaseBuilder(
      context,
      AppDatabase::class.java,
      "gigflow_companion.db"
    ).build()
  }
  
  @Provides
  @Singleton
  fun provideTripDao(db: AppDatabase): TripDao = db.tripDao()
}

@Module
@InstallIn(SingletonComponent::class)
object RepositoryModule {
  @Provides
  @Singleton
  fun provideTripRepository(
    dao: TripDao,
    api: GigFlowApi
  ): TripRepository = TripRepositoryImpl(dao, api)
}
```

## Fluxo de Sincronização

```
[WorkManager dispara SyncWithWebWorker]
         ↓
[SyncRepository.syncWithWeb()]
         ↓
[Busca transações não sincronizadas]
  ├─ tripRepository.getUnsyncedTrips()
  └─ expenseRepository.getUnsyncedExpenses()
         ↓
[POST /api/v1/transactions/sync]
         ↓
[GigFlow Backend valida e salva]
         ↓
[Marca como synced no Room]
         ↓
[Dashboard web atualiza em tempo real]
```

## Testing Strategy

### Unitários
- TripDetectionAlgorithm (cálculos)
- NotificationParser (regex)
- ExpenseCalculator (fórmulas)

### Integração
- Room DAO tests
- API integration
- Repository tests

### UI
- Espresso (Android tests)
- Screenshots/Visual regression
- Manual QA

## Performance Targets

```
GPS tracking:    < 5% bateria/hora
Memory:          < 100MB
Database:        < 50MB após 1 mês
Overlay updates: < 200ms latência
Sync:            < 5 segundos por lote
```

---

**Documento de Arquitetura — NoCorre v1.0**
