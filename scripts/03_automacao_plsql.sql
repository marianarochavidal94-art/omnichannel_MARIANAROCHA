USE omnichannel_db;

DROP TRIGGER IF EXISTS trg_auditoria_preco;
DROP PROCEDURE IF EXISTS sp_processar_venda;

-- =====================================================
-- 1. STORED PROCEDURE: PROCESSAMENTO DE VENDA
-- =====================================================

DELIMITER //

CREATE PROCEDURE sp_processar_venda(
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_estoque INT;
    DECLARE v_id_pedido INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_quantidade IS NULL OR p_quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantidade deve ser maior que zero';
    END IF;

    SELECT preco, estoque_atual
    INTO v_preco, v_estoque
    FROM produtos
    WHERE id_produto = p_id_produto
    FOR UPDATE;

    IF v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    INSERT INTO pedidos (valor_total, status_pedido)
    VALUES (v_preco * p_quantidade, 'Concluído');

    SET v_id_pedido = LAST_INSERT_ID();

    INSERT INTO itens_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
    VALUES (
        v_id_pedido,
        p_id_produto,
        p_quantidade,
        v_preco
    );

    UPDATE produtos
    SET estoque_atual = estoque_atual - p_quantidade
    WHERE id_produto = p_id_produto;

    COMMIT;

    SELECT
        v_id_pedido AS id_pedido,
        p_id_produto AS id_produto,
        p_quantidade AS quantidade_vendida,
        v_preco * p_quantidade AS valor_total,
        'Venda processada com sucesso' AS mensagem;
END //

-- =====================================================
-- 2. TRIGGER: AUDITORIA DE ALTERAÇÃO DE PREÇO
-- =====================================================

CREATE TRIGGER trg_auditoria_preco
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    IF NOT (OLD.preco <=> NEW.preco) THEN
        INSERT INTO auditoria_preco (
            id_produto,
            preco_antigo,
            preco_novo,
            data_alteracao,
            usuario
        )
        VALUES (
            OLD.id_produto,
            OLD.preco,
            NEW.preco,
            NOW(),
            USER()
        );
    END IF;
END //

DELIMITER ;

-- =====================================================
-- 3. TESTE DA TRIGGER (ALTERAÇÕES DE PREÇO)
-- =====================================================

UPDATE produtos
SET preco = 4400.00
WHERE id_produto = 1;

UPDATE produtos
SET preco = 3600.00
WHERE id_produto = 2;

UPDATE produtos
SET preco = 275.00
WHERE id_produto = 3;

-- =====================================================
-- 4. CONSULTAS PARA CONFERÊNCIA
-- =====================================================

-- Consultar produtos
SELECT * FROM produtos;

-- Consultar clientes
SELECT * FROM clientes;

-- Consultar lojas
SELECT * FROM lojas;

-- Consultar pedidos com cliente e loja
SELECT
    p.id_pedido,
    c.nome AS cliente,
    l.nome AS loja,
    p.data_pedido,
    p.valor_total,
    p.status_pedido
FROM pedidos p
LEFT JOIN clientes c
    ON p.id_cliente = c.id_cliente
LEFT JOIN lojas l
    ON p.id_loja = l.id_loja;

-- Consultar itens dos pedidos
SELECT
    p.id_pedido,
    pr.nome AS produto,
    i.quantidade,
    i.preco_unitario,
    i.quantidade * i.preco_unitario AS subtotal
FROM itens_pedido i
INNER JOIN pedidos p
    ON i.id_pedido = p.id_pedido
INNER JOIN produtos pr
    ON i.id_produto = pr.id_produto;

-- Consultar auditoria de preços
SELECT
    a.id_auditoria,
    pr.nome AS produto,
    a.preco_antigo,
    a.preco_novo,
    a.data_alteracao,
    a.usuario
FROM auditoria_preco a
INNER JOIN produtos pr
    ON a.id_produto = pr.id_produto;