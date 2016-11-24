-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema NewsDataBase
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema NewsDataBase
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `NewsDataBase` DEFAULT CHARACTER SET utf8 ;
USE `NewsDataBase` ;

-- -----------------------------------------------------
-- Table `NewsDataBase`.`News`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `NewsDataBase`.`News` (
  `id_N` INT NOT NULL AUTO_INCREMENT,
  `News` VARCHAR(20000) NULL,
  PRIMARY KEY (`id_N`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `NewsDataBase`.`Words`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `NewsDataBase`.`Words` (
  `id_W` INT NOT NULL AUTO_INCREMENT,
  `Word` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_W`),
  UNIQUE INDEX `Word_UNIQUE` (`Word` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `NewsDataBase`.`N_W`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `NewsDataBase`.`N_W` (
  `id_N` INT NOT NULL,
  `id_W` INT NOT NULL,
  INDEX `id_N_idx` (`id_N` ASC),
  INDEX `id_W_idx` (`id_W` ASC),
  CONSTRAINT `id_N`
    FOREIGN KEY (`id_N`)
    REFERENCES `NewsDataBase`.`News` (`id_N`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_W`
    FOREIGN KEY (`id_W`)
    REFERENCES `NewsDataBase`.`Words` (`id_W`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `NewsDataBase`;

DELIMITER $$
USE `NewsDataBase`$$
CREATE DEFINER = CURRENT_USER TRIGGER `NewsDataBase`.`News_AFTER_INSERT` AFTER INSERT ON `News` FOR EACH ROW
BEGIN
	insert into n_w 
		select new.id_N, id_W
			from words
			where (select new.news regexp concat('[^a-zA-Z1-9]', word, '([ ,.!?;\t\r\n)\:\"\']|$)') ) = 1;
END$$

USE `NewsDataBase`$$
CREATE DEFINER = CURRENT_USER TRIGGER `NewsDataBase`.`Words_AFTER_INSERT` AFTER INSERT ON `Words` FOR EACH ROW
BEGIN
insert into N_W
	select id_N, new.id_W
		from news
        where (select news regexp concat('[^a-zA-Z1-9]', new.word, '([ ,.!?;\t\r\n)\:\"\']|$)') ) = 1;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
