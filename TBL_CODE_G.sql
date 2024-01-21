-- ----------------------------------------------------- 
-- Table Produtos
-- ----------------------------------------------------- 
CREATE TABLE produtos (
    produto_id NUMBER PRIMARY KEY,
    nome       VARCHAR2(50),
    preco      NUMBER
);
-- ----------------------------------------------------- 
-- Table Clientes 
-- ----------------------------------------------------- 
CREATE TABLE clientes (
    cliente_id NUMBER PRIMARY KEY,
    nome       VARCHAR2(50),
    email      VARCHAR2(50)
);
-- ----------------------------------------------------- 
-- Table Pedidos 
-- ----------------------------------------------------- 
CREATE TABLE pedidos (
    pedido_id    NUMBER PRIMARY KEY,
    cliente_id   NUMBER,
    data_pedido  DATE,
    total_pedido NUMBER,
    FOREIGN KEY ( cliente_id )
        REFERENCES clientes ( cliente_id )
);
-- ----------------------------------------------------- 
-- Table Itens Pedido
-- ----------------------------------------------------- 
CREATE TABLE itens_pedido (
    item_id    NUMBER PRIMARY KEY,
    pedido_id  NUMBER,
    produto_id NUMBER,
    quantidade NUMBER,
    FOREIGN KEY ( pedido_id )
        REFERENCES pedidos ( pedido_id ),
    FOREIGN KEY ( produto_id )
        REFERENCES produtos ( produto_id )
);
