# Contributing to NoCorre

Obrigado por querer contribuir para o NoCorre! Este documento fornece diretrizes e instruções para começar.

## Código de Conduta

Todos os contribuidores devem seguir o nosso código de conduta baseado em respeito, inclusão e profissionalismo.

## Como Contribuir

### 1. Reportando Bugs

Se encontrou um bug, crie uma issue com:
- **Título descritivo**
- **Descrição clara do problema**
- **Passos para reproduzir**
- **Comportamento esperado vs. atual**
- **Logs/stacktraces**
- **Device/Android version**

### 2. Sugerindo Features

Crie uma issue com label `enhancement`:
- **Descrição clara do que você quer**
- **Por quê seria útil**
- **Exemplos de uso**
- **Possíveis implementações**

### 3. Pull Requests

**Antes de começar:**
1. Faça fork do repositório
2. Crie uma branch: `git checkout -b feature/sua-feature`
3. Desenvolva seguindo os padrões abaixo
4. Teste seu código
5. Push para sua branch
6. Abra PR descrevendo mudanças

**Padrões de código:**

```kotlin
// Kotlin Code Style
// 1. Use names descritivos
val userOnlineTime = calculateOnlineTime()

// 2. Prefira expressions a statements
val result = if (speed > 2f) "moving" else "stopped"

// 3. Use extension functions
fun Location.distanceToKm(other: Location): Double {
    return distanceTo(other) / 1000.0
}

// 4. Repository pattern para dados
class TripRepositoryImpl(
    private val tripDao: TripDao,
    private val api: GigFlowApi
) : TripRepository {
    // implementação
}

// 5. Use cases = uma responsabilidade
class DetectTripUseCase(
    private val repository: TripRepository
) {
    suspend operator fun invoke(locations: List<Location>): Trip? {
        // lógica pura
    }
}
```

**Estrutura de commit:**
```
type: subject

body (opcional)

footer (opcional)
```

Tipos: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Exemplos:
```
feat: add NotificationListener for Uber earnings

Implementa serviço para ler notificações da Uber
e extrair valores automaticamente via regex parsing.

Closes #123
```

**Tests obrigatórios:**
- ✅ Unit tests para nova lógica
- ✅ Integration tests se usar Room/API
- ✅ Manual testing no dispositivo

## Estrutura do Projeto

```
app/src/main/java/com/gigflow/nocorre/
├── data/          # DAO, API, Repository
├── domain/        # UseCase, Models
├── presentation/  # ViewModel, UI
├── service/       # LocationTracking, Overlay
├── worker/        # WorkManager jobs
├── sensor/        # GPS, Accelerometer
├── di/            # Hilt modules
└── util/          # Helpers
```

Siga a arquitetura ao adicionar features novas.

## Checklist PR

- [ ] Código segue style guide
- [ ] Tests adicionados/atualizados
- [ ] Documentação atualizada
- [ ] Sem quebra de funcionalidades existentes
- [ ] Commits estão bem organizados
- [ ] Sem merge conflicts
- [ ] Build passa localmente

## Development Setup

```bash
# Clone
git clone https://github.com/eucarolinapimenta-crypto/NoCorre.git
cd NoCorre

# Abra no Android Studio

# Crie sua branch
git checkout -b feature/my-feature

# Desenvolva, teste, commite

# Push
git push origin feature/my-feature

# Abra PR no GitHub
```

## Dúvidas?

- 📧 contato@gigflow.dev
- 💬 Discussões no GitHub
- 🐛 Issues para bugs

---

**Obrigado por contribuir! 🎉**
