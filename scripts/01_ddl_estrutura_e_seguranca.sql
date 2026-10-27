CREATE DATABASE IF NOT EXISTS omnichannel_db;
USE omnichannel_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS auditoria_preco;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS lojas;
DROP TABLE IF EXISTS clientes;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 1. TABELAS BASE
-- =====================================================

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(100) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    estoque_atual INT NOT NULL DEFAULT 0,
    preco DECIMAL(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_cadastro DATE
) ENGINE=InnoDB;

CREATE TABLE lojas (
    id_loja INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL
) ENGINE=InnoDB;

-- =====================================================
-- 2. TABELAS DEPENDENTES
-- =====================================================

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_loja INT,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    status_pedido VARCHAR(100),

    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_pedidos_lojas
        FOREIGN KEY (id_loja)
        REFERENCES lojas(id_loja)
) ENGINE=InnoDB;

CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_itens_pedidos
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido),

    CONSTRAINT fk_itens_produtos
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

CREATE TABLE auditoria_preco (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    preco_antigo DECIMAL(10,2) NOT NULL,
    preco_novo DECIMAL(10,2) NOT NULL,
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(255) NOT NULL,

    CONSTRAINT fk_auditoria_produtos
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

-- =====================================================
-- 3. USUÁRIO E PERMISSÕES
-- =====================================================

CREATE USER IF NOT EXISTS
    'atendente_omni'@'localhost'
    IDENTIFIED BY 'Senha123!';

GRANT SELECT ON omnichannel_db.produtos
TO 'atendente_omni'@'localhost';

FLUSH PRIVILEGES;