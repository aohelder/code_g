CREATE OR REPLACE TRIGGER trg_itens_pedido_soma_pedido AFTER
    INSERT ON itens_pedido
    FOR EACH ROW
DECLARE
    -- declara veriáveis
    vn_preco      produtos.preco%TYPE;
    vn_pedido_id  itens_pedido.pedido_id%TYPE;
    vn_produto_id itens_pedido.produto_id%TYPE;
    vn_quantidade itens_pedido.quantidade%TYPE;
BEGIN
    /*
    ||===========================================================================================||
    || SISTEMA    : Desafio CODE-G                                                               ||
    || Objetivo   : Trigger para atualizar o total do pedido na inclusão de um item do pedido    ||
    ||                                                                                           ||
    || HISTÓRICO DE ALTERAÇÕES                                                                   ||
    || VERSÃO      DATA     AUTOR             DESCRIÇÃO DA ALTERAÇÃO                             ||
    ||-------------------------------------------------------------------------------------------||
    || v-01.00  19/01/2024  Helder Oliveira   Versão inicial                                     ||
    ||===========================================================================================||
    */
    BEGIN
        -- atualiza dados para adição do total do pedido
        vn_pedido_id := :new.pedido_id;
        vn_produto_id := :new.produto_id;
        vn_quantidade := :new.quantidade;

        -- obtém preço do produto
        SELECT preco INTO vn_preco
          FROM produtos
         WHERE produto_id = vn_produto_id;

        -- atualiza valor do pedido
        UPDATE pedidos
           SET total_pedido = total_pedido + ( vn_quantidade * vn_preco )
         WHERE pedido_id = vn_pedido_id;

    EXCEPTION
        WHEN OTHERS THEN
            -- desvia para próximo controle de erro
            RAISE;
    END;
END trg_itens_pedido_soma_pedido;