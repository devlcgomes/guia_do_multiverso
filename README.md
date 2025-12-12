# Guia do Multiverso

Aplicativo Flutter para explorar personagens do universo Rick and Morty, desenvolvido com Clean Architecture e BLoC Pattern.

## 📱 Sobre o Projeto

O Guia do Multiverso é uma aplicação mobile que permite aos usuários navegar e explorar os personagens da série Rick and Morty através da [Rick and Morty API](https://rickandmortyapi.com/). A aplicação implementa paginação infinita, permitindo carregar personagens de forma eficiente conforme o usuário navega pela lista.

## 🏗️ Arquitetura

### Clean Architecture + BLoC Pattern

A aplicação foi desenvolvida utilizando **Clean Architecture** combinada com o padrão **BLoC** para gerenciamento de estado. Esta escolha arquitetural foi feita com base nos seguintes critérios:

#### Por que Clean Architecture?

1. **Separação de Responsabilidades**: Cada camada tem uma responsabilidade bem definida, facilitando a manutenção e evolução do código.

2. **Testabilidade**: Cada camada pode ser testada isoladamente, permitindo testes unitários, de integração e de UI de forma independente.

3. **Escalabilidade**: A estrutura modular facilita a adição de novas funcionalidades sem impactar código existente.

4. **Manutenibilidade**: Código organizado e bem estruturado reduz a complexidade e facilita a compreensão por novos desenvolvedores.

5. **Independência de Frameworks**: A lógica de negócio está desacoplada do Flutter, permitindo migrações futuras se necessário.

#### Por que BLoC Pattern?

1. **Padrão Oficial**: BLoC é o padrão recomendado pela equipe do Flutter para gerenciamento de estado.

2. **Performance**: O BLoC otimiza os rebuilds da UI, atualizando apenas os widgets que realmente precisam ser reconstruídos.

3. **Reatividade**: Sistema de eventos e estados reativo, facilitando o gerenciamento de fluxos assíncronos.

4. **Testabilidade**: Lógica de negócio separada da UI, permitindo testes unitários dos BLoCs.

5. **Padrão Empresarial**: Amplamente utilizado em projetos de grande escala, demonstrando profissionalismo e conhecimento de boas práticas.

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

- **flutter_bloc** (^8.1.6): Gerenciamento de estado reativo usando o padrão BLoC
- **http** (^1.2.0): Cliente HTTP para consumo de APIs REST
- **equatable** (^2.0.5): Comparação de objetos para facilitar testes e otimizações

### Dependências de Desenvolvimento

- **flutter_test**: Framework de testes do Flutter
- **flutter_lints** (^6.0.0): Conjunto de regras de lint recomendadas

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

## ✨ Funcionalidades Implementadas

### Tela Home

- ✅ **Carregamento Inicial**: Ao abrir o app, carrega automaticamente os primeiros 20 personagens
- ✅ **Paginação Infinita**: Carrega mais personagens automaticamente ao rolar a lista (quando atinge 80% do scroll)
- ✅ **Pull to Refresh**: Permite atualizar a lista puxando para baixo
- ✅ **Indicadores de Carregamento**: Feedback visual durante o carregamento de dados
- ✅ **Tratamento de Erros**: Exibe mensagens de erro amigáveis e opção de tentar novamente

### Consumo de API

- ✅ **Endpoint**: `GET https://rickandmortyapi.com/api/character`
- ✅ **Paginação**: Utiliza o campo `next` do objeto `info` da resposta da API
- ✅ **Tratamento de Respostas**: Parsing seguro de JSON com tratamento de erros

## 🎯 Decisões Técnicas

### 1. Separação de Entities e Models

- **Entities** (`domain/entities`): Representam as entidades de negócio puras, sem dependências externas
- **Models** (`data/models`): Estendem as entities e adicionam métodos de serialização (fromJson/toJson)

**Benefício**: Mantém a camada de domínio independente de frameworks e facilita testes.

### 2. Use Cases

Cada ação da aplicação é representada por um Use Case, seguindo o princípio de responsabilidade única.

**Benefício**: Lógica de negócio reutilizável e testável.

### 3. Repository Pattern

Interface no domínio e implementação na camada de dados, permitindo trocar a fonte de dados sem impactar o domínio.

**Benefício**: Flexibilidade para adicionar cache local, diferentes APIs, etc.

### 4. BLoC para Gerenciamento de Estado

Estados bem definidos (Initial, Loading, Loaded, LoadingMore, Error) facilitam o controle da UI.

**Benefício**: UI reativa e previsível, fácil de debugar.

### 5. Injeção de Dependências Manual

Implementação simples de DI sem bibliotecas externas, mantendo o projeto leve.

**Benefício**: Controle total sobre a criação de dependências, sem overhead de bibliotecas.

## 📋 Práticas Adotadas

### Código Limpo

- Nomenclatura clara e descritiva
- Funções pequenas e com responsabilidade única
- Comentários apenas quando necessário (código autoexplicativo)

### SOLID Principles

- **S**ingle Responsibility: Cada classe tem uma única responsabilidade
- **O**pen/Closed: Aberto para extensão, fechado para modificação
- **L**iskov Substitution: Entities podem ser substituídas por Models
- **I**nterface Segregation: Interfaces específicas e focadas
- **D**ependency Inversion: Dependências apontam para abstrações

### Tratamento de Erros

- Classes de erro customizadas (`ServerFailure`, `NetworkFailure`)
- Tratamento em todas as camadas
- Mensagens de erro amigáveis para o usuário

### Performance

- Paginação infinita para carregar dados sob demanda
- Rebuilds otimizados pelo BLoC
- Lazy loading de imagens (NetworkImage do Flutter)

## 🧪 Testes

A arquitetura foi pensada para facilitar testes:

- **Testes Unitários**: Use cases, BLoCs, repositories
- **Testes de Integração**: Fluxo completo de dados
- **Testes de Widget**: Componentes de UI

Para executar os testes:
```bash
flutter test
```

## 📱 API Utilizada

- **Documentação**: [Rick and Morty API](https://rickandmortyapi.com/)
- **Endpoint Base**: `https://rickandmortyapi.com/api/character`
- **Paginação**: Utiliza o campo `next` do objeto `info` na resposta

### Exemplo de Resposta

```json
{
  "info": {
    "count": 826,
    "pages": 42,
    "next": "https://rickandmortyapi.com/api/character?page=2",
    "prev": null
  },
  "results": [...]
}
```

## 🔄 Próximas Melhorias

- [ ] Cache local para personagens já carregados
- [ ] Tela de detalhes do personagem
- [ ] Busca e filtros
- [ ] Favoritos
- [ ] Testes unitários e de integração
- [ ] Internacionalização (i18n)
- [ ] Temas claro/escuro

## 📄 Licença

Este projeto foi desenvolvido como teste técnico.

## 👨‍💻 Desenvolvido com

- Flutter
- Dart
- Clean Architecture
- BLoC Pattern
- Rick and Morty API
