-- ============================================================================
-- PROYECTO: Plataforma de Rutas Turísticas y Culturales de Venezuela
--           (RutasVenezuela)
-- MÓDULO:   Mariana Alejandra Cabrera Cisneros (Grupo 7)
-- ENTIDADES: ESTADO, MUNICIPIO, PARROQUIA, USUARIO, VISITANTE, GUIA,
--            COMERCIO, INSTITUCION, HITO_TURISTICO, HITO_CATEGORIA,
--            CREDENCIAL_DIGITAL
-- MOTOR:    PostgreSQL 19 (Modelo Relacional - Navathe)
-- ============================================================================

-- ============================================================================
-- SECCIÓN 1: CREACIÓN DE TABLAS
-- ============================================================================

CREATE TABLE estado (
    nombre_estado VARCHAR(80) PRIMARY KEY
);

CREATE TABLE municipio (
    nombre_estado    VARCHAR(80) NOT NULL,
    nombre_municipio VARCHAR(80) NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio),
    FOREIGN KEY (nombre_estado) REFERENCES estado(nombre_estado)
        ON UPDATE CASCADE
);

CREATE TABLE parroquia (
    nombre_estado    VARCHAR(80) NOT NULL,
    nombre_municipio VARCHAR(80) NOT NULL,
    nombre_parroquia VARCHAR(80) NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia),
    FOREIGN KEY (nombre_estado, nombre_municipio)
        REFERENCES municipio(nombre_estado, nombre_municipio)
        ON UPDATE CASCADE
);

CREATE TABLE usuario (
    id_usuario   SERIAL PRIMARY KEY,
    contrasena   VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(20)  NOT NULL
);

CREATE TABLE visitante (
    id_usuario                     INT          PRIMARY KEY,
    cedula                         VARCHAR(20)  UNIQUE,
    pasaporte                      VARCHAR(30)  UNIQUE,
    nombres                        VARCHAR(100) NOT NULL,
    apellidos                      VARCHAR(100) NOT NULL,
    pais_origen                    VARCHAR(80)  NOT NULL,
    idioma_nativo                  VARCHAR(50)  NOT NULL,
    telf_emergencia                VARCHAR(25)  NOT NULL,
    grupo_sanguineo                VARCHAR(10),
    especificaciones_accesibilidad TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE guia (
    nro_rtn              VARCHAR(30)    NOT NULL,
    cod_licencia         VARCHAR(30)    NOT NULL,
    acreditacion_oficial VARCHAR(100)   NOT NULL,
    anos_trayectoria     INT            NOT NULL,
    especialidades       TEXT           NOT NULL,
    idiomas_dominados    VARCHAR(150)   NOT NULL,
    tarifa_hora          NUMERIC(10, 2) NOT NULL,
    zona_asignada        VARCHAR(100)   NOT NULL,
    nombre_estado        VARCHAR(80)    NOT NULL,
    nombre_municipio     VARCHAR(80)    NOT NULL,
    id_usuario           INT            NOT NULL UNIQUE,
    PRIMARY KEY (nro_rtn, cod_licencia),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,
    FOREIGN KEY (nombre_estado, nombre_municipio)
        REFERENCES municipio(nombre_estado, nombre_municipio)
        ON UPDATE CASCADE
);

CREATE TABLE comercio (
    rif                   VARCHAR(20)  PRIMARY KEY,
    razon_social          VARCHAR(150) NOT NULL,
    categoria_comercial   VARCHAR(80)  NOT NULL,
    aforo                 INT          NOT NULL,
    nro_permiso_sanitario VARCHAR(50)  NOT NULL,
    horario_atencion      VARCHAR(100) NOT NULL,
    cuenta_bancaria       VARCHAR(30)  NOT NULL,
    id_usuario            INT          NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE institucion (
    rif                  VARCHAR(20)  PRIMARY KEY,
    denominacion_oficial VARCHAR(150) NOT NULL,
    nivel_territorial    VARCHAR(20)  NOT NULL,
    funcionario_enlace   VARCHAR(120) NOT NULL,
    decreto_adscripcion  VARCHAR(120) NOT NULL,
    id_usuario           INT          NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE hito_turistico (
    nombre_estado    VARCHAR(80)    NOT NULL,
    nombre_municipio VARCHAR(80)    NOT NULL,
    nombre_parroquia VARCHAR(80)    NOT NULL,
    nombre_hito      VARCHAR(120)   NOT NULL,
    estado_operativo VARCHAR(35)    NOT NULL,
    hora_apertura    TIME,
    hora_cierre      TIME,
    es_libre_acceso  BOOLEAN        NOT NULL,
    descripcion      TEXT           NOT NULL,
    latitud          NUMERIC(10, 7) NOT NULL,
    longitud         NUMERIC(10, 7) NOT NULL,
    altitud          NUMERIC(8, 2)  NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito),
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia)
        REFERENCES parroquia(nombre_estado, nombre_municipio, nombre_parroquia)
        ON UPDATE CASCADE
);

CREATE TABLE hito_categoria (
    nombre_estado    VARCHAR(80)  NOT NULL,
    nombre_municipio VARCHAR(80)  NOT NULL,
    nombre_parroquia VARCHAR(80)  NOT NULL,
    nombre_hito      VARCHAR(120) NOT NULL,
    categoria        VARCHAR(30)  NOT NULL,
    PRIMARY KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, categoria),
    FOREIGN KEY (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        REFERENCES hito_turistico(nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE credencial_digital (
    id_visitante       INT            NOT NULL,
    cod_verificacion   VARCHAR(40)    NOT NULL,
    fecha_hora_visita  TIMESTAMP      NOT NULL,
    monto_abonado      NUMERIC(10, 2) NOT NULL,
    cant_beneficiarios INT            NOT NULL,
    estado             VARCHAR(20)    NOT NULL,
    hito_estado        VARCHAR(80)    NOT NULL,
    hito_municipio     VARCHAR(80)    NOT NULL,
    hito_parroquia     VARCHAR(80)    NOT NULL,
    nombre_hito        VARCHAR(120)   NOT NULL,
    rif_comercio       VARCHAR(20),
    guia_nro_rtn       VARCHAR(30),
    guia_cod_licencia  VARCHAR(30),
    PRIMARY KEY (id_visitante, cod_verificacion),
    FOREIGN KEY (id_visitante)
        REFERENCES visitante(id_usuario)
        ON UPDATE CASCADE,
    FOREIGN KEY (hito_estado, hito_municipio, hito_parroquia, nombre_hito)
        REFERENCES hito_turistico(nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        ON UPDATE CASCADE,
    FOREIGN KEY (rif_comercio)
        REFERENCES comercio(rif)
        ON UPDATE CASCADE,
    FOREIGN KEY (guia_nro_rtn, guia_cod_licencia)
        REFERENCES guia(nro_rtn, cod_licencia)
        ON UPDATE CASCADE
);

