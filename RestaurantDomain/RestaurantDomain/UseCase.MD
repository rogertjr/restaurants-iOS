### Caso de Uso de RemoteRestaurantLoader
    
#### Dados (Entrada):
- URL

#### Caminho feliz:
1. Execute o comando "Carregar listagem de restaurantes" com os dados acima.
2. O sistema baixa dados da URL.
3. O sistema valida os dados baixados.
4. O sistema cria itens de restaurantes a partir de dados válidos.
5. O sistema entrega uma lista de restaurantes.

#### Dados inválidos - caminho triste:
1. O sistema entrega um erro.

#### Sem conectividade - caminho triste:
1. O sistema entrega um erro.
