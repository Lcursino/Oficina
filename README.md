
# Oficina Mecânica Database

![MySQL](https://img.shields.io/badge/MySQL-000000?style=for-the-badge&logo=mysql&logoColor=white)

Sistema de banco de dados para gestão de uma oficina mecânica, desenvolvido em MySQL. O projeto inclui tabelas para clientes, veículos, mecânicos, ordens de serviço, peças, pagamentos e relacionamentos complexos.

---

## Funcionalidades

✅ **Gestão de Clientes**  
✅ **Cadastro de Veículos**  
✅ **Controle de Mecânicos**  
✅ **Ordens de Serviço** com status e autorização  
✅ **Peças e Mão de Obra** com cálculo de custos  
✅ **Pagamentos** vinculados a ordens de serviço  
✅ **Relatórios** com consultas pré-definidas  

---

## Estrutura do Repositório

1. **`schema.sql`**: Criação do banco de dados normalizado com chaves estrangeiras e constraints
2. **`data.sql`**: Inserção de 5 registros fictícios em cada tabela
3. **`queries.sql`**: Consultas complexas para relatórios e análises

---

## Como Utilizar

### Pré-requisitos
- MySQL Server 8.0+
- Cliente MySQL (Workbench, Terminal, etc)

### Instalação
```bash
# 1. Crie o banco de dados
mysql -u root -p -e "CREATE DATABASE oficina;"

# 2. Execute o schema
mysql -u root -p oficina < schema.sql

# 3. Insira os dados fictícios
mysql -u root -p oficina < data.sql

# 4. Execute consultas de exemplo
mysql -u root -p oficina < queries.sql
```

---

## Modelo de Dados

![OficinaMecanica](https://github.com/user-attachments/assets/af86b1a6-3cea-4105-a712-5d6ff6f60606)



Principais tabelas:
- **Cliente** → **Veiculo** (1:N)
- **OrdemServico** → **Veiculo** (N:1)
- **Mecanico** → **Equipe** (N:N via tabela associativa)
- **Peca** → **PecaUsada** (1:N)
- **OrdemServico** → **Pagamento** (1:1)

---

## Consultas de Exemplo

### 1. Valor total gasto por cliente
```sql
SELECT 
    c.Nome,
    SUM(os.ValorTotal) AS TotalGasto
FROM Cliente c
JOIN Veiculo v ON c.idCliente = v.Cliente_idCliente
JOIN OrdemServico os ON v.idVeiculo = os.Veiculo_idVeiculo
GROUP BY c.idCliente
HAVING TotalGasto > 500;
```

### 2. Peças mais utilizadas
```sql
SELECT 
    p.Nome AS Peça,
    SUM(pu.Quantidade) AS TotalUsado
FROM PecaUsada pu
JOIN Peca p ON pu.Peca_idPeca = p.idPeca
GROUP BY p.idPeca
ORDER BY TotalUsado DESC
LIMIT 5;
```

---

## Contribuição

1. Fork este repositório
2. Crie sua branch (`git checkout -b feature/NovoRelatorio`)
3. Commit suas mudanças (`git commit -m 'Adiciona consulta de estoque'`)
4. Push para a branch (`git push origin feature/NovoRelatorio`)
5. Abra um Pull Request

---

## Licença

Este projeto está sob licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

