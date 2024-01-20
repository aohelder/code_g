CREATE OR REPLACE PROCEDURE proc_compra (
    p_cliente_id IN clientes.cliente_id%TYPE,
    p_produto_id IN produtos.produto_id%TYPE,
    p_quantidade IN itens_pedido.quantidade%TYPE
) IS
    -- declara veriáveis
    vn_pedido_id pedidos.pedido_id%TYPE := -1;
    vn_item_id   itens_pedido.item_id%TYPE := -1;
BEGIN
    /*
    ||===========================================================================================||
    || SISTEMA    : Desafio CODE-G                                                               ||
    || Objetivo   : Procedure para realizar compras, é necessário que o cliente e o produto      ||
    ||              existam                                                                      ||
    ||                                                                                           ||
    || HISTÓRICO DE ALTERAÇÕES                                                                   ||
    || VERSÃO      DATA     AUTOR             DESCRIÇÃO DA ALTERAÇÃO                             ||
    ||-------------------------------------------------------------------------------------------||
    || v-01.00  20/01/2024  Helder Oliveira   Versão inicial                                     ||
    ||===========================================================================================||
    */
    BEGIN
        -- trata pedido
        BEGIN
            -- obtém pedido do cliente
            SELECT pedido_id INTO vn_pedido_id
              FROM pedidos
             WHERE cliente_id = p_cliente_id;

        EXCEPTION
            WHEN no_data_found THEN
                -- obtém próximo número do pedido
                SELECT nvl(MAX(pedido_id), 0) + 1 INTO vn_pedido_id
                  FROM pedidos;
                
                -- inclui novo pedido
                INSERT INTO pedidos VALUES (vn_pedido_id, p_cliente_id, sysdate, 0);

            WHEN OTHERS THEN
                -- desvia para próximo controle de erro
                RAISE program_error;
        END;

        -- trata item do pedido
        BEGIN
            -- obtém item do pedido
            SELECT item_id INTO vn_item_id
              FROM itens_pedido
             WHERE pedido_id = vn_pedido_id
               AND produto_id = p_produto_id;

            -- atualiza item do pedido
            UPDATE itens_pedido
               SET quantidade = p_quantidade
             WHERE item_id = vn_item_id
               AND pedido_id = vn_pedido_id
               AND produto_id = p_produto_id;

            -- atualiza banco
            COMMIT;

        EXCEPTION    
            WHEN no_data_found THEN
                -- obtém próximo número do item do pedido
                SELECT nvl(MAX(item_id), 0) + 1 INTO vn_item_id
                  FROM itens_pedido;
                
                -- inclui novo item do pedido
                INSERT INTO itens_pedido VALUES (vn_item_id, vn_pedido_id, p_produto_id, p_quantidade);

                -- atualiza banco
                COMMIT;

            WHEN OTHERS THEN
                -- faz rollback e desvia para próximo controle de erro
                ROLLBACK;
                RAISE program_error;
        END;

    EXCEPTION
        WHEN OTHERS THEN
            -- faz rollback e desvia para próximo controle de erro
            ROLLBACK;
            RAISE;
    END;
END proc_compra;