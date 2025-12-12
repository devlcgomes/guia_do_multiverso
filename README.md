# Guia do Multiverso

Aplicativo Flutter para explorar personagens do universo Rick and Morty, desenvolvido com Clean Architecture e BLoC Pattern.

## 📱 Sobre o Projeto

Aplicação mobile para explorar personagens do universo Rick and Morty através da [Rick and Morty API](https://rickandmortyapi.com/).

## 🏗️ Arquitetura

A aplicação utiliza **Clean Architecture** com **BLoC Pattern** para gerenciamento de estado.

## 📂 Estrutura do Projeto

```
lib/
├── core/                          # Código compartilhado e utilitários
│   ├── error/                     # Tratamento de erros
│   │   └── failures.dart          # Classes de falhas customizadas
│   └── usecases/                  # Base para casos de uso
│       └── usecase.dart           # Interface base para use cases
│
├── data/                          # Camada de dados
│   ├── datasources/               # Fontes de dados (APIs, banco de dados)
│   │   └── character_remote_datasource.dart
│   ├── models/                    # Modelos de dados (JSON)
│   │   ├── character_model.dart
│   │   └── characters_response_model.dart
│   └── repositories/              # Implementação dos repositórios
│       └── character_repository_impl.dart
│
├── domain/                        # Camada de domínio (regras de negócio)
│   ├── entities/                  # Entidades de negócio
│   │   ├── character_entity.dart
│   │   └── characters_response_entity.dart
│   ├── repositories/              # Contratos (interfaces)
│   │   └── character_repository.dart
│   └── usecases/                  # Casos de uso
│       └── get_characters.dart
│
├── presentation/                  # Camada de apresentação
│   ├── bloc/                      # BLoCs (gerenciamento de estado)
│   │   └── character/
│   │       ├── character_bloc.dart
│   │       ├── character_event.dart
│   │       └── character_state.dart
│   └── pages/                     # Telas da aplicação
│       └── home_page.dart
│
├── injection_container.dart       # Injeção de dependências
└── main.dart                      # Ponto de entrada da aplicação
```

### Fluxo de Dados

```
UI (Pages) 
    ↓
BLoC (Events)
    ↓
Use Cases
    ↓
Repository (Interface)
    ↓
Repository Implementation
    ↓
Data Source
    ↓
API Externa
```

## 🛠️ Tecnologias e Dependências

### Dependências Principais

- **flutter_bloc** (^8.1.6): Gerenciamento de estado
- **http** (^1.2.0): Cliente HTTP
- **equatable** (^2.0.5): Comparação de objetos

### Dependências de Desenvolvimento

- **flutter_test**: Framework de testes
- **flutter_lints** (^6.0.0): Regras de lint
- **bloc_test** (^9.1.5): Testes para BLoC
- **mockito** (^5.4.4): Mocks para testes
- **build_runner** (^2.4.9): Geração de código

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.10.3 ou superior)
- Dart SDK
- Android Studio / Xcode (para emuladores)
- Um dispositivo físico ou emulador

### Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd guia_do_multiverso
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute a aplicação:
```bash
flutter run
```

## ✨ Funcionalidades

- Carregamento inicial de personagens
- Paginação infinita
- Pull to refresh
- Busca de personagens
- Filtros por status (Vivo, Morto, Desconhecido)
- Detalhes do personagem
- Cache de imagens
- Animações Hero

## 🎯 Decisões Técnicas

- Separação entre Entities e Models para manter o domínio independente
- Use Cases para encapsular lógica de negócio
- Repository Pattern para abstrair fonte de dados
- BLoC para gerenciamento de estado reativo
- Injeção de dependências manual
- Tratamento de erros customizado (`ServerFailure`, `NetworkFailure`)

## 🧪 Testes

- Testes unitários do CharacterBloc e CharacterRepositoryImpl

### Executar Testes

```bash
# Gerar mocks
flutter pub run build_runner build --delete-conflicting-outputs

# Executar todos os testes
flutter test
```

## 📱 API

- [Rick and Morty API](https://rickandmortyapi.com/)
- Endpoint: `https://rickandmortyapi.com/api/character`

## 📄 Licença

Projeto desenvolvido como teste técnico.
