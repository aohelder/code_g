Atenção na utilização das TRIGGER:
  - TRG_ITENS_PEDIDO_ATUALIZA_PEDIDO;
  - TRG_ITENS_PEDIDO_SOMA_PEDIDO.

Elas se referenciam a mesma tabela (ITENS_PEDIDO) e, portanto, não devem ser ativadas ao mesmo tempo, pois irá
interferir na apuração do valor total do pedido na tabela PEDIDOS.

A Trigger TRG_ITENS_PEDIDO_ATUALIZA_PEDIDO consideras as instruções INSERT, DELETE e UPDATE para realizar a
atualização da coluna TOTAL_PEDIDO da tabela PEDIDOS.

Já a Trigger TRG_ITENS_PEDIDO_SOMA_PEDIDO só considera a instrução INSERT para realizar a atualização da
coluna TOTAL_PEDIDO da tabela PEDIDOS.

Atenção na utilização do Function F_CALC_PEDIDO.

Ela tem um parâmetro OPCIONAL (P_POR_ITEM_PEDIDO, segundo parâmetro), o valor DEFAULT definido é 0 (zero),
quando informado o valor 1 (um) para esse parâmetro, a function fará o cálculo com base nas tabelas:
  - PRODUTOS;
  - ITENS_PEDIDO.

Para outro valor numérico o valor do total do pedido será obtido através da coluna TOTAL_PEDIDO tabela PEDIDOS.

Atenciosamente,

Helder Oliveira
