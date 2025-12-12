# Testes Unitários

Este projeto possui testes unitários implementados para o **CharacterBloc** e **CharacterRepositoryImpl**.

## 📁 Estrutura de Testes

```
test/
├── helpers/
│   ├── test_helpers.dart          # Helpers para criar entidades de teste
│   └── mocks.dart                 # Arquivo para gerar mocks (build_runner)
├── presentation/
│   └── bloc/
│       └── character/
│           └── character_bloc_test.dart
└── data/
    └── repositories/
        └── character_repository_impl_test.dart
```

## 🚀 Como Executar os Testes

### 1. Gerar os Mocks (Primeira vez ou após mudanças)

Os mocks são gerados automaticamente usando `build_runner`:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Executar todos os testes

```bash
flutter test
```

### 3. Executar testes específicos

```bash
# Testes do Bloc
flutter test test/presentation/bloc/character/character_bloc_test.dart

# Testes do Repository
flutter test test/data/repositories/character_repository_impl_test.dart
```

## 📋 Cobertura de Testes

### CharacterBloc Tests

✅ **LoadCharacters**
- Sucesso ao carregar personagens
- Filtro por status
- Paginação (nextUrl)
- Tratamento de erros (Failure e exceções genéricas)

✅ **LoadMoreCharacters**
- Carregar mais personagens com sucesso
- Preservar dados anteriores em caso de erro
- Prevenir múltiplas chamadas simultâneas
- Validar estado antes de carregar mais

✅ **RefreshCharacters**
- Atualizar lista com sucesso
- Usar status atual quando não fornecido
- Tratamento de erros

✅ **FilterByStatus**
- Filtrar por status específico
- Filtrar "todos" (status null)
- Tratamento de erros

### CharacterRepositoryImpl Tests

✅ **getCharacters**
- Retornar CharactersResponseEntity com sucesso
- Passar parâmetros corretos para o datasource
- Rethrow de Failure (ServerFailure e NetworkFailure)
- Converter exceções genéricas em ServerFailure

## 🛠️ Tecnologias Utilizadas

- **bloc_test**: Testes para Bloc/State Management
- **mockito**: Criação de mocks para dependências
- **build_runner**: Geração automática de código para mocks

## 📝 Notas

- Os mocks são gerados automaticamente em `test/helpers/mocks.mocks.dart`
- Os helpers de teste estão em `test/helpers/test_helpers.dart`
- Todos os testes seguem o padrão AAA (Arrange, Act, Assert)

