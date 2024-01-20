CREATE OR REPLACE TRIGGER trg_itens_pedido_atualiza_pedido AFTER
    INSERT OR DELETE OR UPDATE ON itens_pedido
    FOR EACH ROW
DECLARE
    -- declara constantes
    cn_positivo             CONSTANT NUMBER(2) := 1;
    cn_negativo             CONSTANT NUMBER(2) := -1;

    -- declara veriáveis
    vn_sinal                NUMBER(2);
    vn_preco                produtos.preco%TYPE;
    vn_valor_item_total_old pedidos.total_pedido%TYPE := 0;
    vn_pedido_id            itens_pedido.pedido_id%TYPE;
    vn_produto_id           itens_pedido.produto_id%TYPE;
    vn_quantidade           itens_pedido.quantidade%TYPE;
BEGIN
    /*
    ||===========================================================================================||
    || SISTEMA    : Desafio CODE-G                                                               ||
    || Objetivo   : Trigger para atualizar o total do pedido na inclusão e na exclusão de um     ||
    ||              item do pedido                                                               ||
    ||                                                                                           ||
    || HISTÓRICO DE ALTERAÇÕES                                                                   ||
    || VERSÃO      DATA     AUTOR             DESCRIÇÃO DA ALTERAÇÃO                             ||
    ||-------------------------------------------------------------------------------------------||
    || v-01.00  19/01/2024  Helder Oliveira   Versão inicial                                     ||
    ||===========================================================================================||
    */
    BEGIN
        -- verifica se operação realizada é de exclusão
        IF deleting THEN
            -- atualiza dados para subitração do total do pedido
            vn_sinal := cn_negativo;
            vn_pedido_id := :old.pedido_id;
            vn_produto_id := :old.produto_id;
            vn_quantidade := :old.quantidade;
        ELSE
            -- atualiza dados para adição do total do pedido
            vn_sinal := cn_positivo;
            vn_pedido_id := :new.pedido_id;
            vn_produto_id := :new.produto_id;
            vn_quantidade := :new.quantidade;
        END IF;

        -- obtém preço do produto
        SELECT preco INTO vn_preco
          FROM produtos
         WHERE produto_id = vn_produto_id;

        -- verifica se operação realizada é de alteração
        IF updating THEN
            -- atualiza dados para subitração do total do pedido
            vn_valor_item_total_old := :old.quantidade * vn_preco;
        ELSE
            -- atualiza dados para subitração do total do pedido
            vn_valor_item_total_old := 0;
        END IF;

        -- atualiza valor do pedido
        UPDATE pedidos
           SET total_pedido = total_pedido + ( vn_quantidade * vn_preco * vn_sinal ) - vn_valor_item_total_old
         WHERE pedido_id = vn_pedido_id;

    EXCEPTION
        WHEN OTHERS THEN
            -- desvia para próximo controle de erro
            RAISE;
    END;
END trg_itens_pedido_atualiza_pedido;