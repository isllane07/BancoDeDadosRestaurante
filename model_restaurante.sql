CREATE DATABASE meu_restaurante;
USE meu_restaurante;


CREATE TABLE cliente (
    cpf_cliente VARCHAR(11) PRIMARY KEY,
    nome_completo_cliente VARCHAR(100) NOT NULL,
    email_cliente VARCHAR(100),
    telefone_cliente VARCHAR(15)
);



CREATE TABLE reserva (
    id_reserva SERIAL PRIMARY KEY,
    data_hora_reserva DATETIME NOT NULL,
    descricao_status_reserva VARCHAR(50),
    numero_pessoas_reserva INT NOT NULL
);


CREATE TABLE cardapio (
    id_comida SERIAL PRIMARY KEY,
    nome_comida VARCHAR(100) NOT NULL,
    descricao_comida TEXT,
    categoria_comida VARCHAR(50),
    preco DECIMAL(10, 2) NOT NULL,
    itens_disponiveis INT
);


CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    data_hora_pedido DATETIME NOT NULL,
    itens_solicitados VARCHAR(100) NOT NULL,
    quantidade_itens INT NOT NULL,
    descricao_comida VARCHAR(100)
);


-- Criando um índice na coluna cpf_cliente da tabela cliente
CREATE INDEX idx_cliente_cpf ON cliente(cpf_cliente);

-- Criando um índice na coluna data_hora_reserva da tabela reserva
CREATE INDEX idx_reserva_data_hora ON reserva(data_hora_reserva);

-- Criando um índice na coluna preco da tabela cardapio
CREATE INDEX idx_cardapio_preco ON cardapio(preco);

-- Criando um índice na coluna data_hora_pedido da tabela pedido
CREATE INDEX idx_pedido_data_hora ON pedido(data_hora_pedido);


-- Trigger para verificar a quantidade de itens disponíveis no cardápio ao criar um pedido

DELIMITER $$

CREATE TRIGGER verificar_quantidade_cardapio
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    DECLARE quantidade_atual INT;

    -- Obtendo a quantidade de itens disponíveis no cardápio
    SELECT itens_disponiveis INTO quantidade_atual
    FROM cardapio
    WHERE nome_comida = NEW.descricao_comida;

    -- Se não houver itens suficientes, a trigger retorna um erro
    IF quantidade_atual < NEW.quantidade_itens THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade insuficiente de itens no cardápio!';
    END IF;
END$$

DELIMITER ;

--Procedure para adicionar um novo cliente:

DELIMITER $$

CREATE PROCEDURE adicionar_cliente(
    IN p_cpf_cliente VARCHAR(11),
    IN p_nome_completo_cliente VARCHAR(100),
    IN p_email_cliente VARCHAR(100),
    IN p_telefone_cliente VARCHAR(15)
)
BEGIN
    INSERT INTO cliente (cpf_cliente, nome_completo_cliente, email_cliente, telefone_cliente)
    VALUES (p_cpf_cliente, p_nome_completo_cliente, p_email_cliente, p_telefone_cliente);
END$$

DELIMITER ;

-- Procedure para registrar uma nova reserva:

DELIMITER $$

CREATE PROCEDURE registrar_reserva(
    IN p_data_hora_reserva DATETIME,
    IN p_descricao_status_reserva VARCHAR(50),
    IN p_numero_pessoas_reserva INT
)
BEGIN
    INSERT INTO reserva (data_hora_reserva, descricao_status_reserva, numero_pessoas_reserva)
    VALUES (p_data_hora_reserva, p_descricao_status_reserva, p_numero_pessoas_reserva);
END$$

DELIMITER ;

-- Procedure para atualizar o número de itens disponíveis no cardápio após um pedido:

DELIMITER $$

CREATE PROCEDURE atualizar_cardapio_after_pedido(
    IN p_nome_comida VARCHAR(100),
    IN p_quantidade_pedida INT
)
BEGIN
    UPDATE cardapio
    SET itens_disponiveis = itens_disponiveis - p_quantidade_pedida
    WHERE nome_comida = p_nome_comida;
END$$

DELIMITER ;
