SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `oficina` DEFAULT CHARACTER SET utf8 ;
USE `oficina` ;

-- -----------------------------------------------------
-- Table `Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `Endereco` VARCHAR(255) NOT NULL,
  `Celular` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCliente`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Veiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Veiculo` (
  `idVeiculo` INT NOT NULL AUTO_INCREMENT,
  `Fabricante` VARCHAR(50) NOT NULL,
  `Modelo` VARCHAR(50) NOT NULL,
  `Ano` YEAR NULL,
  `Placa` VARCHAR(10) NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idVeiculo`),
  INDEX `fk_Veiculo_Cliente_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Veiculo_Cliente`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Mecanico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mecanico` (
  `idMecanico` INT NOT NULL AUTO_INCREMENT,
  `Matricula` VARCHAR(20) NOT NULL,
  `Nome` VARCHAR(100) NOT NULL,
  `Endereco` VARCHAR(255) NULL,
  `Especialidade` VARCHAR(50) NULL,
  PRIMARY KEY (`idMecanico`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `OrdemServico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OrdemServico` (
  `idOrdemServico` INT NOT NULL AUTO_INCREMENT,
  `Numero` VARCHAR(20) NULL,
  `DataEmissao` DATETIME NULL,
  `DataEntregaPrevista` DATE NULL,
  `ValorTotal` DECIMAL(10,2) NULL,
  `Status` VARCHAR(20) NULL,
  `Autorizado` TINYINT NULL,
  `Veiculo_idVeiculo` INT NOT NULL,
  PRIMARY KEY (`idOrdemServico`),
  INDEX `fk_OrdemServico_Veiculo_idx` (`Veiculo_idVeiculo` ASC) VISIBLE,
  CONSTRAINT `fk_OrdemServico_Veiculo`
    FOREIGN KEY (`Veiculo_idVeiculo`)
    REFERENCES `Veiculo` (`idVeiculo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Equipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Equipe` (
  `OrdemServico_idOrdemServico` INT NOT NULL,
  `Mecanico_idMecanico` INT NOT NULL,
  PRIMARY KEY (`OrdemServico_idOrdemServico`, `Mecanico_idMecanico`),
  INDEX `fk_Equipe_Mecanico_idx` (`Mecanico_idMecanico` ASC) VISIBLE,
  CONSTRAINT `fk_Equipe_OrdemServico`
    FOREIGN KEY (`OrdemServico_idOrdemServico`)
    REFERENCES `OrdemServico` (`idOrdemServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Equipe_Mecanico`
    FOREIGN KEY (`Mecanico_idMecanico`)
    REFERENCES `Mecanico` (`idMecanico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `MaoDeObra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MaoDeObra` (
  `idMaoDeObra` INT NOT NULL AUTO_INCREMENT,
  `Descricao` TEXT NOT NULL,
  `Preco` DECIMAL(10,2) NULL,
  PRIMARY KEY (`idMaoDeObra`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Servico` (
  `idServico` INT NOT NULL AUTO_INCREMENT,
  `MaoDeObra_idMaoDeObra` INT NOT NULL,
  `OrdemServico_idOrdemServico` INT NOT NULL,
  `Status` VARCHAR(20) NULL,
  PRIMARY KEY (`idServico`),
  INDEX `fk_Servico_MaoDeObra_idx` (`MaoDeObra_idMaoDeObra` ASC) VISIBLE,
  INDEX `fk_Servico_OrdemServico_idx` (`OrdemServico_idOrdemServico` ASC) VISIBLE,
  CONSTRAINT `fk_Servico_MaoDeObra`
    FOREIGN KEY (`MaoDeObra_idMaoDeObra`)
    REFERENCES `MaoDeObra` (`idMaoDeObra`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Servico_OrdemServico`
    FOREIGN KEY (`OrdemServico_idOrdemServico`)
    REFERENCES `OrdemServico` (`idOrdemServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Peca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Peca` (
  `idPeca` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `Descricao` TEXT NOT NULL,
  `Preco` DECIMAL(10,2) NULL,
  `QuantidadeEstoque` INT NULL,
  PRIMARY KEY (`idPeca`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `PecaUsada`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PecaUsada` (
  `idPecaUsada` INT NOT NULL AUTO_INCREMENT,
  `Peca_idPeca` INT NOT NULL,
  `OrdemServico_idOrdemServico` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`idPecaUsada`),
  INDEX `fk_PecaUsada_Peca_idx` (`Peca_idPeca` ASC) VISIBLE,
  INDEX `fk_PecaUsada_OrdemServico_idx` (`OrdemServico_idOrdemServico` ASC) VISIBLE,
  CONSTRAINT `fk_PecaUsada_Peca`
    FOREIGN KEY (`Peca_idPeca`)
    REFERENCES `Peca` (`idPeca`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PecaUsada_OrdemServico`
    FOREIGN KEY (`OrdemServico_idOrdemServico`)
    REFERENCES `OrdemServico` (`idOrdemServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pagamento` (
  `idPagamento` INT NOT NULL AUTO_INCREMENT,
  `OrdemServico_idOrdemServico` INT NOT NULL,
  `Data` DATETIME NULL,
  `ValorTotal` DECIMAL(10,2) NULL,
  `MetodoPagamento` VARCHAR(50) NULL,
  PRIMARY KEY (`idPagamento`),
  INDEX `fk_Pagamento_OrdemServico_idx` (`OrdemServico_idOrdemServico` ASC) VISIBLE,
  CONSTRAINT `fk_Pagamento_OrdemServico`
    FOREIGN KEY (`OrdemServico_idOrdemServico`)
    REFERENCES `OrdemServico` (`idOrdemServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
