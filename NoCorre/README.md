# NoCorre — GigFlow Companion App

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Android](https://img.shields.io/badge/android-13%2B-green)
![Kotlin](https://img.shields.io/badge/kotlin-1.9%2B-purple)

Serviço nativo Android que roda em paralelo à Uber/iFood, **estimando ganho real** de motoristas de gig economy sem tocar em dados privados das plataformas.

## 🎯 Visão Geral

### O Problema
Motoristas de apps (Uber, 99, iFood, Rappi, Loggi) **não sabem seu ganho real**:
- Não veem custos de combustível em tempo real
- Não calculam degradação do veículo
- Não rastreiam tempo realmente produtivo vs. parado
- Não validam valores de ganho vs. o que foi prometido

### A Solução: NoCorre Companion
Um **serviço de background** que roda em paralelo ao app da Uber/iFood, estimando ganho real através de:

- **GPS + Acelerômetro** → detecta corridas, km rodado, tempo online
- **NotificationListenerService** → lê valores confirmados da Uber (com consentimento do usuário)
- **Preços ANP** → precifica combustível por estado em tempo real
- **Overlay (Bubble flutuante)** → mostra saldo do dia sobre o app da Uber

## ✨ Funcionalidades

### MVP (Fase 1)
- [x] ForegroundService com rastreamento GPS contínuo
- [x] Detecção automática de corridas via GPS + acelerômetro
- [x] Overlay flutuante mostrando ganhos do dia
- [x] Cálculo de quilometragem em tempo real
- [x] Armazenamento local em Room (SQLite)

### Smart Capture (Fase 2)
- [ ] NotificationListenerService para ler notificações da Uber
- [ ] Parsers regex para diferentes plataformas
- [ ] Deduplicação automática de notificações
- [ ] Confirmação manual de corridas não capturadas

### Real-time Costs (Fase 3)
- [ ] Integração com API ANP de preços de combustível
- [ ] Cálculo de custo por km em tempo real
- [ ] Estimativa de degradação do veículo
- [ ] Custo de manutenção por corrida

### Sync Bidirecional (Fase 4)
- [ ] Sincronização com GigFlow Web via API REST
- [ ] Offline-first com persistência local
- [ ] WorkManager para sync periódico
- [ ] Dashboard web com histórico sincronizado

## 🛠️ Stack Técnico

```
Linguagem:       Kotlin 1.9+
Min SDK:         Android 13 (API 33)
Target SDK:      Android 14+ (API 34+)
IDE:             Android Studio Hedgehog+
Build System:    Gradle 8.0+

Core:
├── Jetpack (Room, LiveData, ViewModel, WorkManager)
├── Google Play Services (Fused Location Provider)
├── Coroutines + Flow
├── Hilt (Dependency Injection)
├── Retrofit2 + OkHttp
├── Timber (Logging)

Testing:
├── JUnit 4
├── Espresso
├── Room Testing
└── Robolectric
```

## 📁 Estrutura do Projeto

```
NoCorre/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/gigflow/nocorre/
│   │   │   │   ├── data/
│   │   │   │   │   ├── local/
│   │   │   │   │   │   ├── db/
│   │   │   │   │   │   │   ├── AppDatabase.kt
│   │   │   │   │   │   │   ├── dao/
│   │   │   │   │   │   │   └── entity/
│   │   │   │   │   │   ├── prefs/
│   │   │   │   │   │   └── cache/
│   │   │   │   │   ├── remote/
│   │   │   │   │   │   ├── api/
│   │   │   │   │   │   ├── dto/
│   │   │   │   │   │   └── interceptor/
│   │   │   │   │   └── repository/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── model/
│   │   │   │   │   ├── usecase/
│   │   │   │   │   └── parser/
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── ui/
│   │   │   │   │   └── viewmodel/
│   │   │   │   ├── service/
│   │   │   │   ├── worker/
│   │   │   │   ├── sensor/
│   │   │   │   ├── di/
│   │   │   │   └── util/
│   │   │   ├── res/
│   │   │   └── AndroidManifest.xml
│   │   ├── test/
│   │   └── androidTest/
│   ├── build.gradle.kts
│   └── proguard-rules.pro
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── LICENSE
└── docs/
    ├── ARCHITECTURE.md
    ├── SETUP.md
    └── API.md
```

## 🚀 Quick Start

### Pré-requisitos
- Android Studio Hedgehog (2023.1.1) ou superior
- JDK 17+
- Android SDK 34+
- Git

### Setup Local

```bash
# Clone o repositório
git clone https://github.com/eucarolinapimenta-crypto/NoCorre.git
cd NoCorre

# Abra no Android Studio
# File → Open → selecione a pasta NoCorre

# Aguarde o Gradle sincronizar

# Conecte um dispositivo Android 13+ (ou emulador)

# Execute a aplicação
# Run → Run 'app'
```

### Permissões Necessárias

O app solicita ao usuário:
```xml
<!-- Localização -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<!-- Serviço em background -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<!-- Overlay (bubble) -->
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />

<!-- Notificações -->
<uses-permission android:name="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE" />

<!-- Sensores -->
<uses-permission android:name="android.permission.BODY_SENSORS" />

<!-- Internet -->
<uses-permission android:name="android.permission.INTERNET" />
```

## 📚 Documentação

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** — Visão geral da arquitetura MVVM + Clean
- **[SETUP.md](docs/SETUP.md)** — Guia de configuração inicial
- **[API.md](docs/API.md)** — Documentação da API de integração com GigFlow Web

## 🧪 Testes

```bash
# Testes unitários
./gradlew test

# Testes instrumented (Android)
./gradlew connectedAndroidTest

# Coverage
./gradlew testDebugUnitTestCoverage
```

## 🔐 Segurança & Privacidade

### O que NÃO fazemos (viola ToS)
- ❌ Hackear/reverse-engineer dados privados da Uber
- ❌ Interceptar comunicação criptografada
- ❌ Modificar APK ou emular eventos internos
- ❌ Acessar arquivos privados do app

### O que FAZEMOS (totalmente legal)
- ✅ Usar sensores do SO (GPS, acelerômetro)
- ✅ Ler notificações que o usuário JÁ recebe (com permissão)
- ✅ Processar input manual do usuário
- ✅ Usar dados públicos (ANP, mapas)
- ✅ Calcular e estimar localmente
- ✅ Sincronizar dados via API REST pública

## 📞 Suporte

- 📧 **Email:** contato@gigflow.dev
- 💬 **Discord:** [convite do servidor]
- 🐛 **Issues:** GitHub Issues

## 📄 Licença

Este projeto está sob a licença **MIT**. Veja [LICENSE](LICENSE) para detalhes.

## 🤝 Contribuindo

Contribuições são bem-vindas! Veja [CONTRIBUTING.md](CONTRIBUTING.md) para guias de desenvolvimento.

## 🎯 Roadmap

- **v1.0 (Atual)** — MVP com GPS + Overlay
- **v1.1** — NotificationListener + Parsers
- **v1.2** — ANP Integration + Cost Calculator
- **v2.0** — Sync com GigFlow Web + Dashboard web

---

**NoCorre** — Motoristas merecem saber seu ganho real. 🚗💰

*Desenvolvido com ❤️ para a comunidade de gig economy do Brasil*
