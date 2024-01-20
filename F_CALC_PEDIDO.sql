CREATE OR REPLACE FUNCTION f_calc_pedido (
    p_pedido_id       IN NUMBER,
    p_por_item_pedido IN NUMBER DEFAULT 0
) RETURN NUMBER AS
    -- declara veriáveis
    vn_total_pedido pedidos.total_pedido%TYPE;
BEGIN
    /*
    ||===========================================================================================||
    || SISTEMA    : Desafio CODE-G                                                               ||
    || Objetivo   : Function para retornar o valor total do pedido informando na chamanda        ||
    || Parâmetros : P_PEDIDO_ID -> Número do pedido, o valor obrigatório                         ||
    ||              P_POR_ITEM_PEDIDO -> Para obter o valor do pedido através dos itens do       ||
    ||              pedido, valor opcional: 1 para itens do pedido, deferente de 1 pelo pedido   ||
    ||                                                                                           ||
    || HISTÓRICO DE ALTERAÇÕES                                                                   ||
    || VERSÃO      DATA     AUTOR             DESCRIÇÃO DA ALTERAÇÃO                             ||
    ||-------------------------------------------------------------------------------------------||
    || v-01.00  20/01/2024  Helder Oliveira   Versão inicial                                     ||
    ||===========================================================================================||
    */
    BEGIN
        -- verifica se acha através do itens do pedido
        IF nvl(p_por_item_pedido, 0) = 1 THEN
            -- obtém valor total do pedido através do itens do pedido
            SELECT SUM(t.quantidade * a.preco) INTO vn_total_pedido
              FROM itens_pedido t
             INNER JOIN produtos a ON t.produto_id = a.produto_id
             WHERE t.pedido_id = p_pedido_id;
        ELSE
            -- obtém valor total do pedido
            SELECT total_pedido INTO vn_total_pedido
              FROM pedidos
             WHERE pedido_id = p_pedido_id;
        END IF;

        -- retorna valor total do pedido
        RETURN vn_total_pedido;
    EXCEPTION
        WHEN OTHERS THEN
            -- desvia para próximo controle de erro
            RAISE program_error;
    END;
END f_calc_pedido;