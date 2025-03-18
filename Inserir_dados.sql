-- Inserindo dados na tabela Cliente
INSERT INTO Cliente (Nome, Endereco, Celular) VALUES
('João Silva', 'Rua das Flores, 123', '(11) 98765-4321'),
('Maria Souza', 'Avenida Paulista, 456', '(21) 99876-5432'),
('Carlos Pereira', 'Praça da Sé, 789', '(31) 98765-1234'),
('Ana Oliveira', 'Rua Augusta, 1011', '(41) 99876-1234'),
('Pedro Costa', 'Alameda Santos, 1213', '(51) 98765-5678');

-- Inserindo dados na tabela Veiculo
INSERT INTO Veiculo (Fabricante, Modelo, Ano, Placa, Cliente_idCliente) VALUES
('Ford', 'Ka', 2020, 'ABC-1234', 1),
('Volkswagen', 'Gol', 2019, 'DEF-5678', 2),
('Chevrolet', 'Onix', 2021, 'GHI-9012', 3),
('Fiat', 'Palio', 2018, 'JKL-3456', 4),
('Toyota', 'Corolla', 2022, 'MNO-7890', 5);

-- Inserindo dados na tabela Mecanico
INSERT INTO Mecanico (Matricula, Nome, Endereco, Especialidade) VALUES
('M001', 'José Silva', 'Rua das Flores, 123', 'Motor'),
('M002', 'Antonio Souza', 'Avenida Paulista, 456', 'Suspensão'),
('M003', 'Carlos Oliveira', 'Praça da Sé, 789', 'Elétrica'),
('M004', 'Paulo Costa', 'Rua Augusta, 1011', 'Freios'),
('M005', 'Lucas Pereira', 'Alameda Santos, 1213', 'Transmissão');

-- Inserindo dados na tabela OrdemServico
INSERT INTO OrdemServico (Numero, DataEmissao, DataEntregaPrevista, ValorTotal, Status, Autorizado, Veiculo_idVeiculo) VALUES
('OS001', '2024-01-10 08:00:00', '2024-01-15', 350.00, 'Aberta', 1, 1),
('OS002', '2024-01-11 09:00:00', '2024-01-16', 450.00, 'Em Andamento', 1, 2),
('OS003', '2024-01-12 10:00:00', '2024-01-17', 550.00, 'Concluída', 1, 3),
('OS004', '2024-01-13 11:00:00', '2024-01-18', 250.00, 'Aberta', 0, 4),
('OS005', '2024-01-14 12:00:00', '2024-01-19', 650.00, 'Em Andamento', 1, 5);

-- Inserindo dados na tabela Equipe
INSERT INTO Equipe (OrdemServico_idOrdemServico, Mecanico_idMecanico) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Inserindo dados na tabela MaoDeObra
INSERT INTO MaoDeObra (Descricao, Preco) VALUES
('Troca de óleo', 150.00),
('Revisão de freios', 200.00),
('Troca de bateria', 120.00),
('Alinhamento', 180.00),
('Balanceamento', 100.00);

-- Inserindo dados na tabela Servico
INSERT INTO Servico (MaoDeObra_idMaoDeObra, OrdemServico_idOrdemServico, Status) VALUES
(1, 1, 'Concluído'),
(2, 2, 'Em Andamento'),
(3, 3, 'Concluído'),
(4, 4, 'Pendente'),
(5, 5, 'Em Andamento');

-- Inserindo dados na tabela Peca
INSERT INTO Peca (Nome, Descricao, Preco, QuantidadeEstoque) VALUES
('Óleo Lubrificante', 'Óleo sintético 10W-40', 50.00, 100),
('Pastilha de Freio', 'Pastilha cerâmica', 80.00, 50),
('Bateria Automotiva', 'Bateria 12V 60Ah', 200.00, 30),
('Pneu', 'Pneu aro 15', 300.00, 20),
('Filtro de Ar', 'Filtro de ar esportivo', 40.00, 40);

-- Inserindo dados na tabela PecaUsada
INSERT INTO PecaUsada (Peca_idPeca, OrdemServico_idOrdemServico, Quantidade) VALUES
(1, 1, 2),
(2, 2, 4),
(3, 3, 1),
(4, 4, 2),
(5, 5, 3);

-- Inserindo dados na tabela Pagamento
INSERT INTO Pagamento (OrdemServico_idOrdemServico, Data, ValorTotal, MetodoPagamento) VALUES
(1, '2024-01-15 10:00:00', 350.00, 'Cartão de Crédito'),
(2, '2024-01-16 11:00:00', 450.00, 'Boleto'),
(3, '2024-01-17 12:00:00', 550.00, 'Pix'),
(4, '2024-01-18 13:00:00', 250.00, 'Dinheiro'),
(5, '2024-01-19 14:00:00', 650.00, 'Cartão de Débito');
