# Diretrizes do aplicativo mobile

## Limites da aplicação

- Este aplicativo Flutter é a experiência Android do cliente para catálogo, carrinho, criação e acompanhamento de pedidos, notícias, contato por WhatsApp e links internos de notificações push.
- Consuma apenas a API Laravel. Nunca acesse o Pedido OK diretamente nem replique no dispositivo regras oficiais de preço, estoque, estado dos pedidos, permissões ou finanças.
- Mantenha os modelos da API na fronteira de dados e converta-os em conceitos claros de domínio quando essa separação reduzir o acoplamento.

## Flutter e Dart

- Escreva Dart com null safety e tipagem forte. Use inglês em arquivos, bibliotecas, classes, membros, nomes de rotas, testes e modelos serializados pertencentes ao projeto.
- Apresente todas as mensagens visíveis ao usuário em português brasileiro e mantenha os textos preparados para localização centralizada conforme a aplicação crescer.
- Mantenha os widgets focados em renderização e interação. Retire decisões de negócio e acesso remoto ou a dados dos widgets.
- Organize o código por funcionalidade quando uma funcionalidade precisar de múltiplos arquivos. Dentro dela, separe apresentação, domínio e dados somente conforme necessário; não crie camadas ou interfaces vazias.
- Prefira estados imutáveis e widgets pequenos e combináveis. Mantenha estados temporários da interface localmente e introduza gerenciamento de estado compartilhado somente quando o requisito justificar e de acordo com o padrão adotado pelo projeto.
- Não adicione pacotes ou um framework de gerenciamento de estado sem verificar se o SDK e as dependências existentes já resolvem a necessidade.

## Comportamento e segurança no mobile

- Trate explicitamente estados de carregamento, vazio, offline, validação, sessão expirada e erro do servidor, com mensagens claras em português e ações de nova tentativa quando forem seguras.
- Não informe que uma operação de pedido ou pagamento foi concluída antes da confirmação da API. Torne envios repetidos seguros em conjunto com a API.
- Armazene credenciais de autenticação apenas por um mecanismo de armazenamento seguro da plataforma. Nunca deixe segredos fixos no código nem registre tokens, senhas, dados pessoais ou payloads sensíveis completos.
- Trate dados de notificações push e links internos como entradas não confiáveis. Valide os destinos e a autorização depois que o aplicativo for aberto.
- Mantenha as telas responsivas nos tamanhos Android e escalas de texto suportados. Use rótulos semânticos e áreas de toque adequadas.
- Armazene catálogo ou notícias em cache somente quando o comportamento de atualização estiver definido. Nunca apresente estoque, preço ou estado de pedido em cache como atual sem deixar clara a possível desatualização.

## Verificação

- Execute `dart format` nos arquivos Dart alterados.
- Execute `flutter analyze` após alterações em Dart ou configurações.
- Execute `flutter test` para mudanças de comportamento, adicionando testes unitários ou de widget específicos para novas regras e regressões.
