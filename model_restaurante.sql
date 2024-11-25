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
