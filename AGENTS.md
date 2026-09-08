# Diretrizes do aplicativo mobile

Estas diretrizes complementam o `AGENTS.md` da raiz do repositório. Em caso de
conflito, o que está escrito aqui prevalece para o diretório `mobile/`.

## Arquitetura

Siga o MVVM descrito no guia oficial de arquitetura do Flutter:
https://docs.flutter.dev/app-architecture/guide

A aplicação tem duas camadas principais: UI e dados. O fluxo padrão é
View → ViewModel → Repository → Service. A camada de domínio com Use Cases é
opcional e só deve ser adicionada quando houver necessidade concreta. A camada
de dados não depende da UI.

### Camada de UI

- **View**: apenas widgets, layout e captura de eventos do usuário. Não contém
  regra de negócio, chamada de rede, acesso a banco nem formatação de dados de
  domínio.
- **ViewModel**: estende `ChangeNotifier`, expõe o estado da tela e trata as
  ações do usuário. Recebe os Repositories pelo construtor; nunca os instancia.
- A View observa o ViewModel com `ListenableBuilder`.
- Cada tela tem um ViewModel próprio. Não compartilhe um ViewModel entre telas
  sem necessidade real.

### Modelos de domínio

- **Domain Model**: imutável, sem dependência de framework, sem anotações de
  serialização e sem conhecimento da origem dos dados.
- Mantenha os modelos em `domain/models/` e as falhas de domínio em
  `domain/errors/`. Essas pastas não exigem uma camada intermediária de Use Cases.
- Preserve a separação entre modelos da API e modelos de domínio; os
  Repositories fazem a conversão.

### Camada de domínio opcional: Use Cases

- Por padrão, ViewModels acessam Repositories diretamente, por injeção no
  construtor.
- Crie um **Use Case** apenas quando a lógica for complexa ou precisar ser
  reaproveitada por mais de um ViewModel. Combinações simples de dados de
  Repositories podem permanecer no ViewModel.
- Use Cases dependem de Repositories. Um ViewModel pode consumir ambos;
  adicionar um Use Case não obriga as demais ações a passar por ele.
- Não crie Use Case que apenas repassa a chamada ao Repository nem crie
  `domain/use_cases/` antecipadamente.

### Camada de dados

- **Service**: sem estado. Envolve uma fronteira externa (Pedido OK, API própria,
  armazenamento local) e devolve o modelo cru dessa fronteira.
- **Repository**: converte os modelos crus em Domain Models e é a única fonte de
  verdade consumida pela UI. Concentra cache, repetição de chamadas e tratamento
  de erro.
- Estruturas de payload do fornecedor não ultrapassam o Repository.

### Ordem de implementação

Ao criar uma funcionalidade, siga esta sequência:

1. Domain Model
2. Service
3. Repository
4. Use Case, quando houver justificativa
5. ViewModel
6. View
7. Registro no contêiner de injeção de dependências
8. Testes

## Gerenciamento de estado

- O padrão do projeto é `ChangeNotifier` com `ListenableBuilder`, conforme o guia
  oficial.
- Não introduza Riverpod, BLoC, Provider, GetX ou outra solução de estado sem
  aprovação explícita. Misturar soluções de estado é o principal risco de erosão
  da arquitetura.

## Boas práticas de Flutter

- Prefira `const` em construtores de widgets sempre que possível.
- Extraia widgets em classes próprias em vez de métodos que retornam `Widget`.
- Trate os três estados de toda tela que carrega dados: carregando, erro e
  sucesso. Nenhuma tela deve falhar silenciosamente.
- Descarte controllers, timers, streams e listeners em `dispose`.
- Não use `BuildContext` após um `await` sem verificar `mounted`.
- Use `go_router` para navegação declarativa.
- Todo texto exibido ao usuário passa pela camada de localização; não escreva
  literais de texto na View.
- Formate datas, horas e valores monetários no locale e no fuso horário
  brasileiros.
- Valores monetários usam decimais de precisão fixa ou inteiros na menor unidade
  monetária, nunca ponto flutuante binário.

## Segurança

- O aplicativo acessa somente a API deste projeto; nunca o Pedido OK diretamente.
- Preços, estoque, permissões, totais de pedidos e estados de pagamento vêm do
  servidor. Nunca confie em valor calculado no cliente para essas informações.
- Não versione segredos, tokens ou credenciais. Não registre senhas, tokens de
  acesso ou dados pessoais nos logs.

## Verificação

Antes de concluir uma alteração, execute na pasta `mobile/`:

```bash
dart format .
flutter analyze
flutter test
```

O pipeline do Codemagic definido em `mobile/codemagic.yaml` não substitui a
verificação local.

## Testes

- Conforme o `AGENTS.md` da raiz, somente a API autoriza criação ou modificação
  de testes automatizados. Não crie nem altere testes em `mobile/` sem
  solicitação explícita.

## Skills de apoio

O repositório traz as skills oficiais de Dart e Flutter em `mobile/.agents/skills`,
também disponíveis pelo plugin `dart-flutter@dart-flutter` do Claude Code. Elas
detalham o "como" de tarefas específicas — arquitetura, testes de widget, layout
responsivo, roteamento, localização. Estas diretrizes prevalecem sobre elas.
