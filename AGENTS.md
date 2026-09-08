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

Evolua a estrutura existente de forma incremental. Não renomeie telas `Screen`
para `View` nem mova arquivos apenas para reproduzir a organização de um exemplo.
Crie pastas e abstrações quando houver uso concreto.

Não introduza interfaces e implementações duplicadas, `BaseRepository`, CRUD
genérico, barramento de eventos, framework de comandos, contêiner de DI ou
geração de código sem necessidade concreta. Banco local, sincronização offline,
filas e cache persistente dependem de requisitos de produto.

### Camada de UI

- **View**: apenas widgets, layout e captura de eventos do usuário. Não contém
  regra de negócio, chamada de rede, acesso a banco nem formatação de dados de
  domínio.
- **ViewModel**: estende `ChangeNotifier`, expõe o estado da tela e trata as
  ações do usuário. Recebe os Repositories pelo construtor; nunca os instancia.
- A View observa o ViewModel com `ListenableBuilder`.
- Cada tela tem um ViewModel próprio. Não compartilhe um ViewModel entre telas
  sem necessidade real.
- Mantenha estado privado e exponha getters e ações. Dados compartilhados entre
  telas pertencem ao Repository; estado visual e rascunhos locais pertencem ao
  ViewModel. Um rascunho compartilhado pode justificar um Repository próprio.
- Quando a tela precisar acompanhar mudanças nos dados compartilhados, o
  ViewModel observa o Repository e remove o listener no descarte. Evite manter
  apenas uma cópia inicial de dados que devem permanecer atualizados.
- Efeitos pontuais, como SnackBars, devem partir de listeners ou do resultado de
  uma ação; mantenha o `build` dedicado à apresentação.
- Exceção restrita: o ViewModel pode chamar diretamente um serviço de plataforma
  que apenas executa uma ação sem fornecer dados de negócio, como o
  `SupportService` ao abrir um link. Não crie um Repository só para repassar essa
  chamada. Catálogo, pedidos e sessão continuam passando por Repositories.

### Modelos de domínio

- **Domain Model**: imutável, sem dependência de framework, sem anotações de
  serialização e sem conhecimento da origem dos dados.
- Mantenha os modelos em `domain/models/` e as falhas de domínio em
  `domain/errors/`. Essas pastas não exigem uma camada intermediária de Use Cases.
- Preserve a separação entre modelos da API e modelos de domínio; os
  Repositories fazem a conversão.
- JSON e serialização ficam em `data/models/`. Prefira modelos Dart imutáveis e
  conversões explícitas; conversões curtas não exigem classes de mapeamento.
- Use falhas de domínio que a UI consiga interpretar e traduza-as em mensagens
  pela localização. Não duplique enums de falha apenas para representar os mesmos
  casos na tela nem exiba o texto bruto de erro da API como mensagem padrão.

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

- **Service**: sem estado de negócio. Envolve uma fronteira externa (API do
  projeto, armazenamento local ou SDK de plataforma) e devolve o modelo cru dessa
  fronteira. Manter configuração e clientes como campos não viola essa regra.
- **Repository**: converte os modelos crus em Domain Models e é a única fonte de
  verdade consumida pela UI. Concentra cache, repetição de chamadas e tratamento
  de erro.
- Estruturas de payload do fornecedor não ultrapassam o Repository.
- Organize cada Repository por um conjunto coeso de dados, que pode atender
  várias telas; não crie um Repository por endpoint. Coordene combinações de
  dados de Repositories no ViewModel ou, quando justificado, em um Use Case.
- Compartilhe o cliente HTTP. Services específicos agrupam operações relacionadas
  sem duplicar transporte e tratamento de respostas.
- Preserve a classificação pelo status HTTP mesmo quando o corpo não for JSON
  válido. Diferencie falhas de transporte, servidor e domínio.
- Implemente cache e repetição de chamadas somente quando necessários. Não repita
  automaticamente a criação de pedidos: reenvio seguro exige suporte de
  idempotência no servidor.

### Composição e ciclo de vida

- Monte as dependências explicitamente na inicialização e passe-as pelo
  construtor. Essa composição já é injeção de dependências; não exige um
  contêiner de DI.
- Use o `ViewModelHost` existente para criar e descartar ViewModels das telas.
  Quem possui um recurso é responsável por encerrá-lo; defina também o descarte
  do roteador, cliente HTTP e Repositories compartilhados na composição.
- Após operações assíncronas, não publique estado nem chame `notifyListeners()`
  em ViewModels descartados, inclusive em `finally`. Ignore resultados que
  perderam validade, como respostas de uma busca cujo filtro já mudou. Verificar
  `mounted` na View não protege o ViewModel.
- Comece com proteções locais simples; extraia infraestrutura comum apenas
  quando a repetição justificar. Não dependa de `dispose()` ser executado quando
  o sistema operacional encerrar o processo.

### Sessão e navegação autenticada

- O Repository de autenticação é a fonte de verdade da sessão e pode usar
  `ChangeNotifier` para informar o roteador sobre mudanças.
- Na restauração, diferencie sessão em inicialização, autenticada e não
  autenticada. Leia o token salvo uma vez e valide a sessão com a API antes de
  liberar telas autenticadas. O roteador apresenta carregamento durante essa
  etapa; falha de rede permite nova tentativa e não equivale a credencial inválida.
- Confirme no contrato OpenAPI o endpoint necessário para recuperar o usuário
  autenticado. Não presuma a existência de `/auth/me`; se faltar, a alteração
  começa na API e no contrato.
- Conecte ao cliente HTTP, na composição, um provedor de credencial por callback
  que consulte a sessão vigente. Não copie tokens para ViewModels nem faça outros
  Repositories dependerem do Repository de autenticação.
- Centralize a invalidação de sessão por respostas 401 de chamadas autenticadas;
  uma resposta 403 não deve encerrar a sessão automaticamente.
- Separe revogação remota e limpeza local no logout. Defina o comportamento para
  falhas de rede e armazenamento seguro, mantendo o estado e o resultado exibido
  coerentes. Encerrar a sessão local não garante revogação remota.

### Ordem de implementação

Ao criar uma funcionalidade, siga esta sequência:

1. Domain Model
2. Service
3. Repository
4. Use Case, quando houver justificativa
5. ViewModel
6. View
7. Composição das dependências e integração ao roteamento
8. Verificação; criação ou alteração de testes somente com solicitação explícita

## Gerenciamento de estado

- O padrão do projeto é `ChangeNotifier` com `ListenableBuilder`, conforme o guia
  oficial.
- Não introduza Riverpod, BLoC, Provider, GetX ou outra solução de estado sem
  aprovação explícita. Misturar soluções de estado é o principal risco de erosão
  da arquitetura.
- Campos privados simples são suficientes inicialmente. Adote um estado imutável
  único quando isso evitar combinações inválidas, sem impor uma estrutura genérica
  a todas as telas.

## Boas práticas de Flutter

- Prefira `const` em construtores de widgets sempre que possível.
- Extraia widgets em classes próprias em vez de métodos que retornam `Widget`.
- Mantenha widgets específicos em `ui/features/<feature>/widgets/`. À medida que o desenvolvimento avançar e houver necessidade real de reutilização entre features, crie ou promova componentes compartilhados em `ui/core/`; não antecipe componentes globais sem uso concreto.
- Trate os três estados de toda tela que carrega dados: carregando, erro e
  sucesso; listas também distinguem o estado vazio. Falhas de paginação preservam
  os itens já carregados. Nenhuma tela deve falhar silenciosamente.
- Descarte controllers, timers, streams e listeners em `dispose`.
- Não use `BuildContext` após um `await` sem verificar `mounted`.
- Use `go_router` para navegação declarativa.
- Todo texto exibido ao usuário passa pela camada de localização; não escreva
  literais de texto na View.
- Formate datas, horas e valores monetários no locale e no fuso horário
  brasileiros.
- Valores monetários usam decimais de precisão fixa ou inteiros na menor unidade
  monetária, nunca ponto flutuante binário.

## Notificações

- Quando houver integração push, isole o SDK em um Service. O Repository de
  notificações coordena os dados e o registro do dispositivo com a API.
- Trate permissão negada, renovação do token do dispositivo e desvinculação ao
  sair. O roteador resolve o destino do toque após inicialização e autenticação.
- Crie uma tela de notificações somente se houver histórico previsto no produto
  e suportado pela API. Não antecipe infraestrutura genérica para essa integração.

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
