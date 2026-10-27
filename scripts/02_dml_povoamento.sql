USE omnichannel_db;

-- =====================================================
-- 1. POPULAÇÃO DA TABELA PRODUTOS
-- =====================================================

INSERT INTO produtos
(categoria, nome, estoque_atual, preco)
VALUES
('Smartphones', 'Smartphone Galaxy S23', 15, 4500.00),
('Informática', 'Notebook Dell Inspiron', 8, 3800.00),
('Áudio', 'Fone de Ouvido Bluetooth', 30, 250.00),
('Smartphones', 'iPhone 14', 10, 4200.00),
('Informática', 'Mouse Logitech G203', 25, 150.00),
('Áudio', 'Headset Gamer HyperX', 12, 350.00);

-- =====================================================
-- 2. POPULAÇÃO DA TABELA CLIENTES
-- =====================================================

INSERT INTO clientes
(nome, telefone, cpf, email, data_cadastro)
VALUES
('João Silva', '81999990001', '12345678901', 'joao@email.com', '2026-01-10'),
('Maria Santos', '81999990002', '23456789012', 'maria@email.com', '2026-01-15'),
('Pedro Oliveira', '81999990003', '34567890123', 'pedro@email.com', '2026-02-01'),
('Ana Costa', '81999990004', '45678901234', 'ana@email.com', '2026-02-12'),
('Lucas Ferreira', '81999990005', '56789012345', 'lucas@email.com', '2026-03-05'),
('Juliana Alves', '81999990006', '67890123456', 'juliana@email.com', '2026-03-20');

-- =====================================================
-- 3. POPULAÇÃO DA TABELA LOJAS
-- =====================================================

INSERT INTO lojas
(nome, cidade, tipo, uf)
VALUES
('Loja Centro', 'Recife', 'Física', 'PE'),
('Loja Shopping', 'Caruaru', 'Física', 'PE'),
('Loja Online', 'Recife', 'Virtual', 'PE'),
('Loja Norte', 'Olinda', 'Física', 'PE');

-- =====================================================
-- 4. POPULAÇÃO DA TABELA PEDIDOS
-- =====================================================

INSERT INTO pedidos
(id_cliente, id_loja, data_pedido, valor_total, status_pedido)
VALUES
(1, 1, '2026-10-20 10:30:00', 4750.00, 'Concluído'),
(2, 2, '2026-10-21 14:15:00', 3800.00, 'Pago'),
(3, 3, '2026-10-22 09:45:00', 500.00, 'Enviado'),
(4, 1, '2026-10-23 16:20:00', 700.00, 'Concluído'),
(5, 4, '2026-10-24 11:00:00', 4200.00, 'Em processamento'),
(6, 3, '2026-10-25 13:30:00', 650.00, 'Pago');

-- =====================================================
-- 5. POPULAÇÃO DA TABELA ITENS_PEDIDO
-- =====================================================

INSERT INTO itens_pedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(1, 1, 1, 4500.00),
(1, 3, 1, 250.00),
(2, 2, 1, 3800.00),
(3, 3, 2, 250.00),
(4, 5, 1, 150.00),
(4, 6, 1, 350.00),
(4, 3, 1, 200.00),
(5, 4, 1, 4200.00),
(6, 6, 1, 350.00),
(6, 3, 1, 300.00);