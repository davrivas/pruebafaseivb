-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema db_prueba
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `db_prueba` ;

-- -----------------------------------------------------
-- Schema db_prueba
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_prueba` DEFAULT CHARACTER SET utf8 ;
USE `db_prueba` ;

-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_tipos_documento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_tipos_documento` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_tipos_documento` (
  `id` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `sigla` VARCHAR(12) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_ciudades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_ciudades` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_ciudades` (
  `codigo` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(60) NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_tipos_usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_tipos_usuarios` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_tipos_usuarios` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_usuarios` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_usuarios` (
  `id` INT UNSIGNED NOT NULL,
  `documento` BIGINT UNSIGNED NOT NULL,
  `nombres` VARCHAR(60) NOT NULL,
  `primer_apellido` VARCHAR(45) NOT NULL,
  `segundo_apellido` VARCHAR(45) NULL,
  `direccion` TINYTEXT NULL,
  `telefono` VARCHAR(15) NULL,
  `correo` TINYTEXT NOT NULL,
  `clave` VARCHAR(45) NOT NULL,
  `estado` TINYINT NULL COMMENT '0 - Bloqueado\n1 - Activo\n',
  `tbl_tipos_documento_id` INT UNSIGNED NOT NULL,
  `tbl_ciudades_codigo` INT UNSIGNED NOT NULL,
  `tbl_tipos_usuarios_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tbl_usuarios_tbl_tipos_documento`
    FOREIGN KEY (`tbl_tipos_documento_id`)
    REFERENCES `db_prueba`.`tbl_tipos_documento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_usuarios_tbl_ciudades1`
    FOREIGN KEY (`tbl_ciudades_codigo`)
    REFERENCES `db_prueba`.`tbl_ciudades` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_usuarios_tbl_tipos_usuarios1`
    FOREIGN KEY (`tbl_tipos_usuarios_id`)
    REFERENCES `db_prueba`.`tbl_tipos_usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_usuarios_tbl_tipos_documento_idx` ON `db_prueba`.`tbl_usuarios` (`tbl_tipos_documento_id` ASC);

CREATE INDEX `fk_tbl_usuarios_tbl_ciudades1_idx` ON `db_prueba`.`tbl_usuarios` (`tbl_ciudades_codigo` ASC);

CREATE UNIQUE INDEX `documento_UNIQUE` ON `db_prueba`.`tbl_usuarios` (`documento` ASC);

CREATE INDEX `fk_tbl_usuarios_tbl_tipos_usuarios1_idx` ON `db_prueba`.`tbl_usuarios` (`tbl_tipos_usuarios_id` ASC);


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_sucursales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_sucursales` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_sucursales` (
  `id` INT NOT NULL,
  `barrio` VARCHAR(60) NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `telefonos` TINYTEXT NOT NULL,
  `tbl_ciudades_codigo` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tbl_sedes_hotel_tbl_ciudades1`
    FOREIGN KEY (`tbl_ciudades_codigo`)
    REFERENCES `db_prueba`.`tbl_ciudades` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_sedes_hotel_tbl_ciudades1_idx` ON `db_prueba`.`tbl_sucursales` (`tbl_ciudades_codigo` ASC);


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_tipos_cuentas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_tipos_cuentas` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_tipos_cuentas` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` TINYTEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_cuentas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_cuentas` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_cuentas` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `numero` INT UNSIGNED NOT NULL,
  `fecha_apertura` DATE NOT NULL,
  `saldo` DOUBLE NOT NULL DEFAULT 0,
  `estado` VARCHAR(15) NULL DEFAULT 'ABIERTA',
  `tbl_sucursal_id` INT NOT NULL,
  `tbl_tipos_cuentas_id` INT UNSIGNED NOT NULL,
  `tbl_usuarios_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tbl_habitaciones_tbl_sedes_hotel1`
    FOREIGN KEY (`tbl_sucursal_id`)
    REFERENCES `db_prueba`.`tbl_sucursales` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_habitaciones_tbl_tipos_habitaciones1`
    FOREIGN KEY (`tbl_tipos_cuentas_id`)
    REFERENCES `db_prueba`.`tbl_tipos_cuentas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tbl_cuentas_tbl_usuarios1`
    FOREIGN KEY (`tbl_usuarios_id`)
    REFERENCES `db_prueba`.`tbl_usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_habitaciones_tbl_sedes_hotel1_idx` ON `db_prueba`.`tbl_cuentas` (`tbl_sucursal_id` ASC);

CREATE INDEX `fk_tbl_habitaciones_tbl_tipos_habitaciones1_idx` ON `db_prueba`.`tbl_cuentas` (`tbl_tipos_cuentas_id` ASC);

CREATE INDEX `fk_tbl_cuentas_tbl_usuarios1_idx` ON `db_prueba`.`tbl_cuentas` (`tbl_usuarios_id` ASC);


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_movimientos_cuentas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_movimientos_cuentas` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_movimientos_cuentas` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `tipo_movimiento` VARCHAR(45) NOT NULL COMMENT 'Por ejemplo:\nRETIRO\nCONSIGNACIÓN\nCANCELACIÓN',
  `valor` DOUBLE NOT NULL,
  `tbl_cuentas_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tbl_movimientos_tbl_cuentas1`
    FOREIGN KEY (`tbl_cuentas_id`)
    REFERENCES `db_prueba`.`tbl_cuentas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_movimientos_tbl_cuentas1_idx` ON `db_prueba`.`tbl_movimientos_cuentas` (`tbl_cuentas_id` ASC);


-- -----------------------------------------------------
-- Table `db_prueba`.`tbl_observaciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_prueba`.`tbl_observaciones` ;

CREATE TABLE IF NOT EXISTS `db_prueba`.`tbl_observaciones` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` TINYINT NULL COMMENT '0 - Cerrada\n1 - Bloqueada\n2 - Reabierta\n3 - Desbloqueada',
  `observacion` VARCHAR(45) NULL,
  `fecha` VARCHAR(45) NULL,
  `tbl_cuentas_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tbl_observaciones_tbl_cuentas1`
    FOREIGN KEY (`tbl_cuentas_id`)
    REFERENCES `db_prueba`.`tbl_cuentas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tbl_observaciones_tbl_cuentas1_idx` ON `db_prueba`.`tbl_observaciones` (`tbl_cuentas_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_tipos_documento`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_tipos_documento` (`id`, `nombre`, `sigla`) VALUES (1, 'Cédula de ciudadanía', 'C.C.');
INSERT INTO `db_prueba`.`tbl_tipos_documento` (`id`, `nombre`, `sigla`) VALUES (2, 'Tarjeta de identidad', 'T.I.');

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_ciudades`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_ciudades` (`codigo`, `nombre`) VALUES (1, 'Bogotá');
INSERT INTO `db_prueba`.`tbl_ciudades` (`codigo`, `nombre`) VALUES (2, 'Cali');
INSERT INTO `db_prueba`.`tbl_ciudades` (`codigo`, `nombre`) VALUES (3, 'Tunja');
INSERT INTO `db_prueba`.`tbl_ciudades` (`codigo`, `nombre`) VALUES (4, 'Medellín');
INSERT INTO `db_prueba`.`tbl_ciudades` (`codigo`, `nombre`) VALUES (5, 'Cartagena');

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_tipos_usuarios`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_tipos_usuarios` (`id`, `nombre`) VALUES (1, 'Administrador');
INSERT INTO `db_prueba`.`tbl_tipos_usuarios` (`id`, `nombre`) VALUES (2, 'Empleado');
INSERT INTO `db_prueba`.`tbl_tipos_usuarios` (`id`, `nombre`) VALUES (3, 'Cliente');

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_usuarios`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (1, 1272892623, 'JUAN PATRICIO', 'GUTIERREZ', 'PEREZ', 'TRVS.139 # 132 24', '6141475', 'JPGUTIERREZPE@miapp.com', '123456789', 0, 1, 4, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (2, 1576784963, 'MARIA RITA', 'HIDALGO', 'ESCOBAR', 'CL. 193 # 23 59', '5990640', 'MRHIDALGOES@miapp.com', '123456789', 1, 1, 3, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (3, 1038420067, 'DAVID MARIO', 'SALVADOR', 'MENDEZ', 'CL. 52 # 57A 43', '2112942', 'DMSALVADORME@miapp.com', '123456789', 0, 1, 3, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (4, 1318971257, 'PATRICIA JHOANA', 'MENDEZ', 'ESCOBAR', 'CL. 198 # 166 40', '4017199', 'PJMENDEZES@miapp.com', '123456789', 1, 1, 3, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (5, 1448197069, 'JUAN WALTER', 'SALVADOR', 'ESCOBAR', 'TRVS.193 # 51 11', '2723070', 'JWSALVADORES@miapp.com', '123456789', 0, 2, 2, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (6, 1433636138, 'DANIELA INÉS', 'NIÑO', 'DÍAZ', 'CL. 160 # 88A 78', '7968562', 'DINIÑODÍ@miapp.com', '123456789', 1, 1, 4, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (7, 1394669699, 'DIEGO WALTER', 'PEREZ', 'ESCOBAR', 'TRVS.96 # 6 30', '4659929', 'DWPEREZES@miapp.com', '123456789', 0, 1, 3, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (8, 1520582352, 'MARIA JOSEFINA', 'SALVADOR', 'ESTRADA', 'TRVS.81 # 116 42', '5299178', 'MJSALVADORES@miapp.com', '123456789', 1, 2, 4, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (9, 1772471242, 'JUAN JOSÉ', 'TORRES', 'ARAGÓN', 'TRVS.105 # 174A 10', '2395064', 'JJTORRESAR@miapp.com', '123456789', 0, 1, 5, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (10, 1471828518, 'ROSAURA VALENTINA', 'SALVADOR', 'IGLESIAS', 'CR. 37 # 74 85', '4685618', 'RVSALVADORIG@miapp.com', '123456789', 1, 1, 3, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (11, 1318885446, 'JUAN IVAN', 'SÁNCHEZ', 'HIDALGO', 'CR. 171 # 198 80', '1686406', 'JISÁNCHEZHI@miapp.com', '123456789', 0, 1, 3, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (12, 1647202393, 'ANGELA MARIA', 'LUQUE', 'FLORES', 'DIG.123 # 102 85', '7103951', 'AMLUQUEFL@miapp.com', '123456789', 1, 1, 3, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (13, 1901410136, 'CARLOS JULIAN', 'RODRIGUEZ', 'TORRES', 'CL. 93 # 35 48', '2963510', 'CJRODRIGUEZTO@miapp.com', '123456789', 0, 1, 1, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (14, 1927334352, 'ISABEL DOROTI', 'MARTINEZ', 'PEREZ', 'TRVS.115 # 117 45', '5096289', 'IDMARTINEZPE@miapp.com', '123456789', 1, 2, 3, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (15, 1142912687, 'CRISTIAN ERNESTO', 'FUENTES', 'VELASQUEZ', 'DIG.134 # 71 54', '1209828', 'CEFUENTESVE@miapp.com', '123456789', 0, 2, 1, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (16, 1770378784, 'RITA ROSA', 'NIÑO', 'LÓPEZ', 'DIG.156 # 152G 43', '2596066', 'RRNIÑOLÓ@miapp.com', '123456789', 1, 2, 2, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (17, 1882719390, 'RODOLFO CARLOS', 'FLORES', 'RUIZ', 'TRVS.194 # 154 80', '1421501', 'RCFLORESRU@miapp.com', '123456789', 0, 1, 1, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (18, 1855612360, 'BEATRIS SANDRA', 'JIMENEZ', 'LUQUE', 'DIG.151 # 16 27', '5007853', 'BSJIMENEZLU@miapp.com', '123456789', 1, 2, 1, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (19, 1873230540, 'WALTER CARLOS', 'ESCOBAR', 'ARISTIZABAL', 'CR. 180 # 184A 98', '3609207', 'WCESCOBARAR@miapp.com', '123456789', 0, 2, 3, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (20, 1052691298, 'SANDRA ROSA', 'ZAPATA', 'CASTRO', 'CR. 110 # 97B 57', '5948022', 'SRZAPATACA@miapp.com', '123456789', 1, 1, 1, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (21, 1197468586, 'CAMILO JOSÉ', 'JIMENEZ', 'GONZALES', 'CL. 28 # 3 60', '5449516', 'CJJIMENEZGO@miapp.com', '123456789', 0, 1, 3, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (22, 1493565504, 'SANDRA JHOANA', 'SÁNCHEZ', 'MENDEZ', 'DIG.20 # 86 30', '2677438', 'SJSÁNCHEZME@miapp.com', '123456789', 1, 1, 3, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (23, 1237492965, 'MARIO NELSON', 'VELASQUEZ', 'MENDEZ', 'TRVS.167 # 44 26', '5282613', 'MNVELASQUEZME@miapp.com', '123456789', 0, 2, 2, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (24, 1673894082, 'VALENTINA PATRICIA', 'NIÑO', 'RUIZ', 'DIG.162 # 92 54', '1262357', 'VPNIÑORU@miapp.com', '123456789', 1, 1, 1, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (25, 1132049710, 'WALTER SAUL', 'JIMENEZ', 'URIBE', 'TRVS.65 # 167 34', '4062540', 'WSJIMENEZUR@miapp.com', '123456789', 0, 2, 4, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (26, 1535778324, 'ROSAURA ISABEL', 'VELASQUEZ', 'ESTRADA', 'CR. 63 # 131A 42', '412789', 'RIVELASQUEZES@miapp.com', '123456789', 1, 2, 3, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (27, 1207072622, 'WALTER JULIAN', 'IGLESIAS', 'CASTRO', 'CR. 136 # 192 42', '526702', 'WJIGLESIASCA@miapp.com', '123456789', 0, 1, 3, 2);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (28, 1831585193, 'MARIA FLOR', 'GONZALES', 'VELEZ', 'DIG.62 # 3 47', '7816109', 'MFGONZALESVE@miapp.com', '123456789', 1, 2, 5, 1);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (29, 1706783152, 'WALTER PEDRO', 'OSPINA', 'VELEZ', 'TRVS.168 # 9 71', '3508116', 'WPOSPINAVE@miapp.com', '123456789', 0, 1, 1, 3);
INSERT INTO `db_prueba`.`tbl_usuarios` (`id`, `documento`, `nombres`, `primer_apellido`, `segundo_apellido`, `direccion`, `telefono`, `correo`, `clave`, `estado`, `tbl_tipos_documento_id`, `tbl_ciudades_codigo`, `tbl_tipos_usuarios_id`) VALUES (30, 1389077651, 'MARIA DIANA', 'BETANCOURT', 'FUENTES', 'DIG.13 # 155 86', '2899169', 'MDBETANCOURTFU@miapp.com', '123456789', 1, 2, 3, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_sucursales`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (1, 'PRIMAVERA', 'CL. 94 # 135A 38', '7218781', 5);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (2, 'PRIMAVERA', 'CR. 98 # 189F 82', '5275770', 1);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (3, 'QUIROGA', 'TRVS.42 # 183A 83', '2235616', 3);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (4, 'VILLA CRISTINA', 'CR. 77 # 199 91', '7068524', 1);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (5, 'TUNAL', 'CR. 97 # 27 30', '3419633', 1);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (6, 'CARLOS LLERAS', 'TRVS.186 # 176 30', '8072655', 5);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (7, 'GARCES', 'DIG.24 # 8 65', '2991088', 5);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (8, 'SAN DIEGO', 'CR. 6 # 47 4', '5687061', 3);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (9, 'VILLA CRISTINA', 'TRVS.87 # 171 8', '897333', 3);
INSERT INTO `db_prueba`.`tbl_sucursales` (`id`, `barrio`, `direccion`, `telefonos`, `tbl_ciudades_codigo`) VALUES (10, 'GARCES', 'DIG.58 # 132 6', '5442861', 4);

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_tipos_cuentas`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_tipos_cuentas` (`id`, `nombre`, `descripcion`) VALUES (1, 'Ahorros', 'Cuenta para tener su dienero a la mano.');
INSERT INTO `db_prueba`.`tbl_tipos_cuentas` (`id`, `nombre`, `descripcion`) VALUES (2, 'Corriente', 'Cuenta recomenda para empresas');
INSERT INTO `db_prueba`.`tbl_tipos_cuentas` (`id`, `nombre`, `descripcion`) VALUES (3, 'CDT', 'Cuentas para ganar intereses a la mediano y largo plazo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_cuentas`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (1, 1361391, '1992-09-01', 2483041.0, 'CERRADA', 8, 1, 9);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (2, 1897120, '1996-08-11', 7671078.0, 'ABIERTA', 7, 2, 25);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (3, 1167459, '1976-11-24', 7311324.0, 'ABIERTA', 6, 1, 4);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (4, 1393206, '1989-09-17', 7320574.0, 'ABIERTA', 6, 3, 19);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (5, 1562219, '1992-09-01', 7880441.0, 'CERRADA', 4, 2, 19);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (6, 1970069, '1980-11-03', 2242582.0, 'ABIERTA', 7, 2, 18);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (7, 1353058, '1989-09-17', 3052089.0, 'ABIERTA', 5, 1, 13);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (8, 1822671, '1990-09-12', 1434640.0, 'ABIERTA', 2, 2, 5);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (9, 1017208, '1985-10-08', 1631831.0, 'CERRADA', 3, 2, 8);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (10, 1971707, '1970-12-26', 5612156.0, 'ABIERTA', 2, 1, 15);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (11, 1158858, '1978-11-14', 7297303.0, 'ABIERTA', 2, 2, 5);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (12, 1718530, '1998-08-01', 114229.0, 'ABIERTA', 8, 1, 21);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (13, 1831305, '1989-09-17', 5993522.0, 'CERRADA', 10, 1, 4);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (14, 1223041, '1974-12-05', 8804957.0, 'ABIERTA', 6, 3, 15);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (15, 1936368, '1986-10-03', 1209828.0, 'ABIERTA', 8, 1, 25);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (16, 1565776, '1969-12-31', 9256702.0, 'ABIERTA', 8, 2, 15);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (17, 1256411, '1984-10-13', 951962.0, 'CERRADA', 9, 3, 15);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (18, 1772420, '1986-10-03', 3940549.0, 'ABIERTA', 1, 3, 3);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (19, 1212153, '1979-11-09', 1435587.0, 'ABIERTA', 1, 2, 5);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (20, 1340118, '1987-09-28', 9419620.0, 'ABIERTA', 9, 1, 3);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (21, 1765474, '1977-11-19', 3107898.0, 'CERRADA', 7, 3, 17);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (22, 1105001, '1976-11-24', 4995723.0, 'ABIERTA', 4, 1, 30);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (23, 1092539, '1989-09-17', 239702.0, 'ABIERTA', 4, 1, 1);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (24, 1489541, '1980-11-03', 9902091.0, 'ABIERTA', 2, 1, 5);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (25, 1964821, '1985-10-08', 719254.0, 'CERRADA', 10, 3, 9);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (26, 1812515, '1978-11-14', 2907279.0, 'ABIERTA', 2, 1, 28);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (27, 1005142, '1994-08-22', 3925236.0, 'ABIERTA', 3, 2, 5);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (28, 1275425, '1985-10-08', 4303488.0, 'ABIERTA', 7, 2, 29);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (29, 1136036, '1971-12-21', 1788877.0, 'CERRADA', 8, 3, 14);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (30, 1691587, '1989-09-17', 2666238.0, 'ABIERTA', 4, 3, 15);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (31, 1252718, '1969-12-31', 1749874.0, 'ABIERTA', 9, 1, 28);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (32, 1595134, '1990-09-12', 5652221.0, 'ABIERTA', 2, 1, 26);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (33, 1787179, '1995-08-17', 5797463.0, 'CERRADA', 2, 1, 22);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (34, 1795210, '1992-09-01', 1019787.0, 'ABIERTA', 9, 2, 7);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (35, 1942902, '1984-10-13', 7923805.0, 'ABIERTA', 8, 2, 20);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (36, 1405311, '1988-09-22', 9302947.0, 'ABIERTA', 5, 2, 26);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (37, 1620413, '1993-08-27', 2201158.0, 'CERRADA', 3, 3, 6);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (38, 1320022, '1973-12-10', 9876405.0, 'ABIERTA', 7, 2, 30);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (39, 1129803, '1977-11-19', 2841021.0, 'ABIERTA', 8, 2, 3);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (40, 1844416, '1982-10-24', 869950.0, 'ABIERTA', 10, 3, 21);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (41, 1689391, '1995-08-17', 6055047.0, 'CERRADA', 1, 3, 30);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (42, 1593159, '1978-11-14', 1456391.0, 'ABIERTA', 7, 2, 22);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (43, 1019953, '1988-09-22', 2741458.0, 'ABIERTA', 3, 3, 19);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (44, 1389919, '1970-12-26', 1650180.0, 'ABIERTA', 5, 1, 17);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (45, 1478349, '1971-12-21', 1876129.0, 'CERRADA', 3, 3, 4);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (46, 1588215, '1981-10-29', 4324434.0, 'ABIERTA', 4, 1, 3);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (47, 1062997, '1976-11-24', 4294105.0, 'ABIERTA', 7, 3, 2);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (48, 1200977, '1991-09-07', 1732564.0, 'ABIERTA', 3, 1, 27);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (49, 1378490, '1980-11-03', 4785267.0, 'CERRADA', 3, 2, 21);
INSERT INTO `db_prueba`.`tbl_cuentas` (`id`, `numero`, `fecha_apertura`, `saldo`, `estado`, `tbl_sucursal_id`, `tbl_tipos_cuentas_id`, `tbl_usuarios_id`) VALUES (50, 1196597, '1987-09-28', 2886003.0, 'ABIERTA', 9, 2, 28);

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_movimientos_cuentas`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (1, '1992-10-16', 'RETIRO', 3071905.0, 1);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (2, '1992-11-29', 'CONSIGNACION', 5393945.0, 1);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (3, '1993-01-17', 'RETIRO', 404637.0, 1);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (4, '1996-09-19', 'RETIRO', 4727241.0, 2);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (5, '1996-10-24', 'CONSIGNACION', 1128224.0, 2);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (6, '1996-11-10', 'RETIRO', 5210082.0, 2);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (7, '1996-11-13', 'CONSIGNACION', 2436302.0, 2);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (8, '1996-11-23', 'RETIRO', 8254728.0, 2);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (9, '1996-12-17', 'CONSIGNACION', 2933438.0, 2);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (10, '1976-11-29', 'RETIRO', 1237996.0, 3);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (11, '1976-12-11', 'CONSIGNACION', 3594376.0, 3);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (12, '1977-01-18', 'RETIRO', 1491520.0, 3);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (13, '1977-02-11', 'CONSIGNACION', 9532143.0, 3);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (14, '1989-10-29', 'RETIRO', 2492420.0, 4);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (15, '1989-10-29', 'CONSIGNACION', 3841729.0, 4);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (16, '1989-12-03', 'RETIRO', 2300705.0, 4);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (17, '1989-12-12', 'CONSIGNACION', 3095430.0, 4);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (18, '1992-09-21', 'RETIRO', 9096380.0, 5);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (19, '1992-11-05', 'CONSIGNACION', 4936393.0, 5);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (20, '1992-11-09', 'RETIRO', 3101798.0, 5);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (21, '1980-11-03', 'RETIRO', 1726891.0, 6);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (22, '1980-12-14', 'CONSIGNACION', 2161386.0, 6);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (23, '1981-01-24', 'RETIRO', 6271122.0, 6);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (24, '1981-03-06', 'CONSIGNACION', 3242326.0, 6);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (25, '1981-03-20', 'RETIRO', 4803054.0, 6);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (26, '1989-09-23', 'RETIRO', 8915740.0, 7);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (27, '1989-09-25', 'CONSIGNACION', 3927073.0, 7);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (28, '1990-10-23', 'RETIRO', 7140937.0, 8);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (29, '1990-12-04', 'CONSIGNACION', 5334239.0, 8);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (30, '1990-12-05', 'RETIRO', 442825.0, 8);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (31, '1991-01-15', 'CONSIGNACION', 5526006.0, 8);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (32, '1991-02-05', 'RETIRO', 56456.0, 8);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (33, '1985-10-26', 'RETIRO', 4992071.0, 9);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (34, '1985-11-28', 'CONSIGNACION', 5270857.0, 9);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (35, '1986-01-02', 'RETIRO', 3171394.0, 9);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (36, '1986-01-06', 'CONSIGNACION', 4067631.0, 9);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (37, '1986-01-22', 'RETIRO', 5479181.0, 9);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (38, '1971-02-02', 'RETIRO', 8974149.0, 10);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (39, '1971-03-19', 'CONSIGNACION', 592638.0, 10);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (40, '1971-04-22', 'RETIRO', 8944870.0, 10);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (41, '1971-05-28', 'CONSIGNACION', 27699.0, 10);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (42, '1971-07-08', 'RETIRO', 6249562.0, 10);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (43, '1978-12-05', 'RETIRO', 5312734.0, 11);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (44, '1978-12-22', 'CONSIGNACION', 80808.0, 11);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (45, '1998-08-31', 'RETIRO', 1500520.0, 12);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (46, '1998-09-13', 'CONSIGNACION', 9749419.0, 12);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (47, '1998-09-24', 'RETIRO', 4526709.0, 12);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (48, '1989-11-05', 'RETIRO', 2542808.0, 13);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (49, '1989-12-09', 'CONSIGNACION', 4370663.0, 13);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (50, '1990-01-12', 'RETIRO', 9419548.0, 13);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (51, '1975-01-11', 'RETIRO', 1471720.0, 14);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (52, '1975-02-26', 'CONSIGNACION', 3097030.0, 14);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (53, '1969-12-31', 'RETIRO', 5078341.0, 16);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (54, '1969-12-31', 'CONSIGNACION', 7982755.0, 16);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (55, '1984-11-26', 'RETIRO', 8960927.0, 17);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (56, '1984-12-20', 'CONSIGNACION', 3872186.0, 17);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (57, '1986-10-10', 'RETIRO', 3404136.0, 18);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (58, '1986-11-02', 'CONSIGNACION', 5551435.0, 18);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (59, '1986-11-13', 'RETIRO', 7663379.0, 18);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (60, '1986-11-17', 'CONSIGNACION', 6165965.0, 18);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (61, '1986-12-06', 'RETIRO', 7359175.0, 18);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (62, '1979-11-13', 'RETIRO', 1182430.0, 19);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (63, '1979-11-16', 'CONSIGNACION', 3007222.0, 19);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (64, '1979-12-06', 'RETIRO', 595560.0, 19);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (65, '1980-01-13', 'CONSIGNACION', 8152837.0, 19);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (66, '1987-10-14', 'RETIRO', 9019848.0, 20);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (67, '1987-11-12', 'CONSIGNACION', 1308328.0, 20);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (68, '1987-12-05', 'RETIRO', 2302570.0, 20);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (69, '1988-01-14', 'CONSIGNACION', 3707815.0, 20);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (70, '1988-02-13', 'RETIRO', 5704270.0, 20);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (71, '1976-11-27', 'RETIRO', 1837587.0, 22);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (72, '1976-12-01', 'CONSIGNACION', 9230237.0, 22);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (73, '1977-01-02', 'RETIRO', 455140.0, 22);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (74, '1977-01-26', 'CONSIGNACION', 2601529.0, 22);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (75, '1978-12-29', 'RETIRO', 4682560.0, 26);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (76, '1979-01-12', 'CONSIGNACION', 3595124.0, 26);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (77, '1979-02-02', 'RETIRO', 3136975.0, 26);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (78, '1979-02-14', 'CONSIGNACION', 2911749.0, 26);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (79, '1979-02-25', 'RETIRO', 7620027.0, 26);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (80, '1979-04-10', 'CONSIGNACION', 6060255.0, 26);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (81, '1994-10-01', 'RETIRO', 8937026.0, 27);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (82, '1985-11-19', 'RETIRO', 2899887.0, 28);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (83, '1971-12-30', 'RETIRO', 3732909.0, 29);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (84, '1972-01-17', 'CONSIGNACION', 7828550.0, 29);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (85, '1972-01-27', 'RETIRO', 4276827.0, 29);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (86, '1972-03-16', 'CONSIGNACION', 7556190.0, 29);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (87, '1972-03-20', 'RETIRO', 6082669.0, 29);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (88, '1972-04-05', 'CONSIGNACION', 8697747.0, 29);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (89, '1989-10-16', 'RETIRO', 4651978.0, 30);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (90, '1989-11-14', 'CONSIGNACION', 7907196.0, 30);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (91, '1989-12-11', 'RETIRO', 3901668.0, 30);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (92, '1970-02-02', 'RETIRO', 9791140.0, 31);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (93, '1990-10-13', 'RETIRO', 8902884.0, 32);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (94, '1990-11-20', 'CONSIGNACION', 9101617.0, 32);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (95, '1991-01-08', 'RETIRO', 9532043.0, 32);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (96, '1991-02-17', 'CONSIGNACION', 2580451.0, 32);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (97, '1991-03-08', 'RETIRO', 6666661.0, 32);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (98, '1995-09-10', 'RETIRO', 8187537.0, 33);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (99, '1995-09-18', 'CONSIGNACION', 5909423.0, 33);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (100, '1995-09-18', 'RETIRO', 2653508.0, 33);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (101, '1995-10-07', 'CONSIGNACION', 5277094.0, 33);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (102, '1995-11-21', 'RETIRO', 837396.0, 33);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (103, '1995-12-06', 'CONSIGNACION', 8545059.0, 33);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (104, '1992-10-03', 'RETIRO', 7005052.0, 34);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (105, '1992-10-17', 'CONSIGNACION', 3444534.0, 34);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (106, '1992-12-03', 'RETIRO', 8831099.0, 34);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (107, '1993-01-08', 'CONSIGNACION', 880879.0, 34);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (108, '1993-02-16', 'RETIRO', 9660511.0, 34);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (109, '1984-11-02', 'RETIRO', 2056419.0, 35);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (110, '1984-11-08', 'CONSIGNACION', 5168923.0, 35);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (111, '1984-12-05', 'RETIRO', 4879005.0, 35);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (112, '1984-12-20', 'CONSIGNACION', 6990334.0, 35);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (113, '1985-01-08', 'RETIRO', 952948.0, 35);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (114, '1985-01-18', 'CONSIGNACION', 1189657.0, 35);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (115, '1993-09-08', 'RETIRO', 7239848.0, 37);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (116, '1993-10-09', 'CONSIGNACION', 2843363.0, 37);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (117, '1993-10-10', 'RETIRO', 1598707.0, 37);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (118, '1993-11-20', 'CONSIGNACION', 6889575.0, 37);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (119, '1993-11-28', 'RETIRO', 4236875.0, 37);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (120, '1974-01-28', 'RETIRO', 6418638.0, 38);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (121, '1974-02-22', 'CONSIGNACION', 5198166.0, 38);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (122, '1974-02-24', 'RETIRO', 6276444.0, 38);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (123, '1974-03-03', 'CONSIGNACION', 3936851.0, 38);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (124, '1974-04-08', 'RETIRO', 2654957.0, 38);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (125, '1982-11-11', 'RETIRO', 6046299.0, 40);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (126, '1982-12-10', 'CONSIGNACION', 8558794.0, 40);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (127, '1982-12-16', 'RETIRO', 9593336.0, 40);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (128, '1983-01-08', 'CONSIGNACION', 9838370.0, 40);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (129, '1983-01-14', 'RETIRO', 8985733.0, 40);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (130, '1995-09-03', 'RETIRO', 4265637.0, 41);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (131, '1978-12-04', 'RETIRO', 8192620.0, 42);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (132, '1988-10-08', 'RETIRO', 6045604.0, 43);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (133, '1988-11-12', 'CONSIGNACION', 9426985.0, 43);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (134, '1988-12-20', 'RETIRO', 5930697.0, 43);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (135, '1989-01-03', 'CONSIGNACION', 4517885.0, 43);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (136, '1971-01-13', 'RETIRO', 7486532.0, 44);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (137, '1971-02-05', 'CONSIGNACION', 4300614.0, 44);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (138, '1971-03-21', 'RETIRO', 1931010.0, 44);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (139, '1981-11-25', 'RETIRO', 8967186.0, 46);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (140, '1982-01-08', 'CONSIGNACION', 8032865.0, 46);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (141, '1982-02-10', 'RETIRO', 3043371.0, 46);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (142, '1976-12-25', 'RETIRO', 6111313.0, 47);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (143, '1991-09-30', 'RETIRO', 2989782.0, 48);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (144, '1980-11-26', 'RETIRO', 3851552.0, 49);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (145, '1987-10-22', 'RETIRO', 8943075.0, 50);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (146, '1987-10-24', 'CONSIGNACION', 9639256.0, 50);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (147, '1987-12-11', 'RETIRO', 6813364.0, 50);
INSERT INTO `db_prueba`.`tbl_movimientos_cuentas` (`id`, `fecha`, `tipo_movimiento`, `valor`, `tbl_cuentas_id`) VALUES (148, '1988-01-09', 'CONSIGNACION', 1230337.0, 50);

COMMIT;


-- -----------------------------------------------------
-- Data for table `db_prueba`.`tbl_observaciones`
-- -----------------------------------------------------
START TRANSACTION;
USE `db_prueba`;
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (1, 0, 'Se ha cerrado la cuenta', '1992-10-01', 1);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (2, 0, 'Se ha cerrado la cuenta', '1996-09-10', 5);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (3, 0, 'Se ha cerrado la cuenta', '1986-08-04', 9);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (4, 0, 'Se ha cerrado la cuenta', '1991-06-09', 13);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (5, 0, 'Se ha cerrado la cuenta', '1987-03-02', 17);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (6, 0, 'Se ha cerrado la cuenta', '1978-10-15', 21);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (7, 0, 'Se ha cerrado la cuenta', '1989-02-19', 25);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (8, 0, 'Se ha cerrado la cuenta', '1973-03-15', 29);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (9, 0, 'Se ha cerrado la cuenta', '1997-10-05', 33);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (10, 0, 'Se ha cerrado la cuenta', '1994-12-20', 37);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (11, 0, 'Se ha cerrado la cuenta', '1996-02-13', 41);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (12, 0, 'Se ha cerrado la cuenta', '1975-01-04', 45);
INSERT INTO `db_prueba`.`tbl_observaciones` (`id`, `tipo`, `observacion`, `fecha`, `tbl_cuentas_id`) VALUES (13, 0, 'Se ha cerrado la cuenta', '1982-11-23', 49);

COMMIT;

