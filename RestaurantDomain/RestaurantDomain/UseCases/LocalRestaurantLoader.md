## Narrativa #2
    Como um cliente offline
    Quero que o aplicativo mostre a versão salva mais recente de restaurantes
    Para que eu possa sempre ver as melhores opções de restaurantes para realizar meus pedidos
### Cenários (Critérios de aceite)
    Dado que o cliente não tem conectividade
    E há uma versão em cache de restaurantes
    E nosso cache tem menos de 1 dia (já que nosso aplicativo a grande base irá usar aos final de semana)
    Quando o cliente pede para ver a lista de restaurantes
    Em seguida, o aplicativo deve exibir os restaurantes mais recente salvo
    Dado que o cliente não tem conectividade
    E há uma versão em cache de restaurantes
    E nosso cache tem mais de 1 dia
    Quando o cliente pede para ver a lista de restaurantes
    Então o aplicativo deve exibir uma mensagem de erro
    Dado que o cliente não tem conectividade
    E o cache está vazio
    Quando o cliente pede para ver a lista de restaurantes
    Então o aplicativo deve exibir uma mensagem de erro

## Caso de Uso do LocalRestaurantLoader (Cache)
### Carregamento de lista de restaurantes (Cache)
#### Dados (Entrada):
    - Idade máxima. (1 dia)
#### Caminho feliz:
    1. Execute o comando "carregar lista de restaurantes" com os dados acima.
    2. O sistema busca dados de restaurantes do cache.
    3. O sistema valida se o cache tem menos que a idade máxima (1 dia).
    5. O sistema cria itens de restaurantes a partir de dados em cache.
    5. O sistema entrega uma lista de restaurantes.
#### Caso de erro - caminho triste:
    1. O sistema retorna mensagem de erro
#### Recurso de cache - caminho triste:
    1. O sistema deleta o cache, quando ocorrer um erro em buscar dados do cache.
    2. O sistema deleta o cache, quando o mesmo passar do limite máximo de 1 dia.
    3. O sistema não entrega uma lista de restaurantes.

### Salvar lista de restaurantes
#### Dados (Entrada):
    - Listagem de restaurantes;

#### Curso primário (caminho feliz):
    1. Execute o comando "Salvar listagem de restaurantes" com os dados acima.
    2. O sistema deleta o cache antigo.
    3. O sistema codifica a lista de restaurantes.
    4. O sistema marca a hora do novo cache.
    5. O sistema salva o cache com novos dados.
    6. O sistema envia uma mensagem de sucesso.
#### Caso de erro (caminho triste):
    1. O sistema envia uma mensagem de erro.

#### Caso de erro ao salvar (caminho triste):
    1. O sistema envia uma mensagem de erro.
