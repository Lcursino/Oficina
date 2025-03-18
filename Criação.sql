SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb`;

-- -----------------------------------------------------
-- Table `PF` (Added unique index for CPF)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PF` (
  `idPF` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NULL,
  `CPF` CHAR(11) NOT NULL,
  `Data de Nascimento` DATE NOT NULL,
  PRIMARY KEY (`idPF`),
  UNIQUE INDEX `idx_cpf_unique` (`CPF` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `PJ` (Added unique index for CNPJ)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PJ` (
  `idPJ` INT NOT NULL AUTO_INCREMENT,
  `CNPJ` CHAR(14) NOT NULL,
  `Razão Social` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPJ`),
  UNIQUE INDEX `idx_cnpj_unique` (`CNPJ` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NULL,
  PRIMARY KEY (`idCliente`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `Status` ENUM('enviado', 'entregue', 'retornado') NOT NULL,
  `Previsão de entrega` DATE NOT NULL,
  `Empresa` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEntrega`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Produto` (Fixed DECIMAL precision)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `Categoria` VARCHAR(45) NULL,
  `Descrição` LONGTEXT NULL,
  `Valor` DECIMAL(10,2) NULL,
  PRIMARY KEY (`idProduto`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Fornecedor` (Fixed CNPJ data type)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `Razão Social` VARCHAR(45) NULL,
  `CNPJ` CHAR(14) NULL,
  PRIMARY KEY (`idFornecedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ClientePF` (Fixed data type and foreign key)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClientePF` (
  `Cliente_idCliente` INT NOT NULL,
  `PF_CPF` CHAR(11) NOT NULL,
  PRIMARY KEY (`Cliente_idCliente`, `PF_CPF`),
  INDEX `fk_Cliente_has_PF_PF1_idx` (`PF_CPF` ASC) VISIBLE,
  INDEX `fk_Cliente_has_PF_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_has_PF_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cliente_has_PF_PF1`
    FOREIGN KEY (`PF_CPF`)
    REFERENCES `PF` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `ClientePJ` (Fixed data type and foreign key)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClientePJ` (
  `Cliente_idCliente` INT NOT NULL,
  `PJ_CNPJ` CHAR(14) NOT NULL,
  PRIMARY KEY (`Cliente_idCliente`, `PJ_CNPJ`),
  INDEX `fk_Cliente_has_PJ_PJ1_idx` (`PJ_CNPJ` ASC) VISIBLE,
  INDEX `fk_Cliente_has_PJ_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_has_PJ_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cliente_has_PJ_PJ1`
    FOREIGN KEY (`PJ_CNPJ`)
    REFERENCES `PJ` (`CNPJ`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `Descrição` LONGTEXT NULL,
  `Cliente_idCliente` INT NOT NULL,
  `Frete` DECIMAL(10,2) NULL,
  `Código de rastreio` VARCHAR(20) NOT NULL,
  `Entrega_idEntrega` INT NOT NULL,
  `Status` ENUM('pendente', 'aprovado', 'cancelado') NULL,
  PRIMARY KEY (`idPedido`),
  INDEX `fk_Pedido_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  INDEX `fk_Pedido_Entrega1_idx` (`Entrega_idEntrega` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Entrega1`
    FOREIGN KEY (`Entrega_idEntrega`)
    REFERENCES `Entrega` (`idEntrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Pagamento` (Fixed timestamp column)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pagamento` (
  `idPagamento` INT NOT NULL AUTO_INCREMENT,
  `Método de pagamento` VARCHAR(45) NOT NULL,
  `Data do pagamento` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPagamento`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `OrigemProduto` (Simplified primary key)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OrigemProduto` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  INDEX `fk_Fornecedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Produto_Fornecedor1_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Remaining tables (corrected as needed)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `Local` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstoque`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ProdutoPorEstoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`Estoque_idEstoque` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `Estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `RelaçãoProdutoPedido` (
  `Produto_idProduto` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `VendederMarketplace` (
  `idTerceiro - vendedor` INT NOT NULL AUTO_INCREMENT,
  `Razão Social` VARCHAR(45) NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTerceiro - vendedor`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ProdutosPorVendedor` (
  `Terceiro - vendedor_idTerceiro - vendedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `quantidade` INT NULL,
  PRIMARY KEY (`Terceiro - vendedor_idTerceiro - vendedor`, `Produto_idProduto`),
  INDEX `fk_Terceiro - vendedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Terceiro - vendedor_has_Produto_Terceiro - vendedor1_idx` (`Terceiro - vendedor_idTerceiro - vendedor` ASC) VISIBLE,
  CONSTRAINT `fk_Terceiro - vendedor_has_Produto_Terceiro - vendedor1`
    FOREIGN KEY (`Terceiro - vendedor_idTerceiro - vendedor`)
    REFERENCES `VendederMarketplace` (`idTerceiro - vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Terceiro - vendedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `PagamentoCliente` (
  `Pagamento_idPagamento` INT NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`Pagamento_idPagamento`, `Cliente_idCliente`),
  INDEX `fk_Pagamento_has_Cliente_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  INDEX `fk_Pagamento_has_Cliente_Pagamento1_idx` (`Pagamento_idPagamento` ASC) VISIBLE,
  CONSTRAINT `fk_Pagamento_has_Cliente_Pagamento1`
    FOREIGN KEY (`Pagamento_idPagamento`)
    REFERENCES `Pagamento` (`idPagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pagamento_has_Cliente_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `CartãoCrédito` (
  `idCartão de Crédito` INT NOT NULL AUTO_INCREMENT,
  `Bandeira` VARCHAR(45) NOT NULL,
  `Código` INT NOT NULL,
  `Validade` DATE NOT NULL,
  PRIMARY KEY (`idCartão de Crédito`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cartões` (
  `Cartão de Crédito_idCartão de Crédito` INT NOT NULL,
  `Pagamento_idPagamento` INT NOT NULL,
  PRIMARY KEY (`Cartão de Crédito_idCartão de Crédito`, `Pagamento_idPagamento`),
  INDEX `fk_Cartão de Crédito_has_Pagamento_Pagamento1_idx` (`Pagamento_idPagamento` ASC) VISIBLE,
  INDEX `fk_Cartão de Crédito_has_Pagamento_Cartão de Crédito1_idx` (`Cartão de Crédito_idCartão de Crédito` ASC) VISIBLE,
  CONSTRAINT `fk_Cartão de Crédito_has_Pagamento_Cartão de Crédito1`
    FOREIGN KEY (`Cartão de Crédito_idCartão de Crédito`)
    REFERENCES `CartãoCrédito` (`idCartão de Crédito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cartão de Crédito_has_Pagamento_Pagamento1`
    FOREIGN KEY (`Pagamento_idPagamento`)
    REFERENCES `Pagamento` (`idPagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Endereço` (
  `idEndereço` INT NOT NULL AUTO_INCREMENT,
  `Rua` VARCHAR(100) NOT NULL,
  `Número` VARCHAR(10) NOT NULL,
  `Cidade` VARCHAR(50) NOT NULL,
  `Estado` VARCHAR(2) NULL,
  `CEP` CHAR(8) NULL,
  PRIMARY KEY (`idEndereço`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `EndereçoPF` (
  `Endereço_idEndereço` INT NOT NULL,
  `PF_idPF` INT NOT NULL,
  PRIMARY KEY (`Endereço_idEndereço`, `PF_idPF`),
  INDEX `fk_Endereço_has_PF_PF1_idx` (`PF_idPF` ASC) VISIBLE,
  INDEX `fk_Endereço_has_PF_Endereço1_idx` (`Endereço_idEndereço` ASC) VISIBLE,
  CONSTRAINT `fk_Endereço_has_PF_Endereço1`
    FOREIGN KEY (`Endereço_idEndereço`)
    REFERENCES `Endereço` (`idEndereço`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Endereço_has_PF_PF1`
    FOREIGN KEY (`PF_idPF`)
    REFERENCES `PF` (`idPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `EndereçoPJ` (
  `PJ_idPJ` INT NOT NULL,
  `Endereço_idEndereço` INT NOT NULL,
  PRIMARY KEY (`PJ_idPJ`, `Endereço_idEndereço`),
  INDEX `fk_PJ_has_Endereço_Endereço1_idx` (`Endereço_idEndereço` ASC) VISIBLE,
  INDEX `fk_PJ_has_Endereço_PJ1_idx` (`PJ_idPJ` ASC) VISIBLE,
  CONSTRAINT `fk_PJ_has_Endereço_PJ1`
    FOREIGN KEY (`PJ_idPJ`)
    REFERENCES `PJ` (`idPJ`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PJ_has_Endereço_Endereço1`
    FOREIGN KEY (`Endereço_idEndereço`)
    REFERENCES `Endereço` (`idEndereço`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `category` (
  `category_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`category_id`));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
