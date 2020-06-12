--Elimina las tablas de la base de datos
DROP TABLE PROFESION CASCADE CONSTRAINTS;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE PACIENTE CASCADE CONSTRAINTS;
DROP TABLE EVALUACION CASCADE CONSTRAINTS;
DROP TABLE SINTOMA CASCADE CONSTRAINTS;
DROP TABLE DETALLE_EVALUACION CASCADE CONSTRAINTS;
DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS;
DROP TABLE SINTOMA_DIAGNOSTICO CASCADE CONSTRAINTS;
DROP TABLE SEGUIMIENTO CASCADE CONSTRAINTS;
DROP TABLE TRATAMIENTO CASCADE CONSTRAINTS;
DROP TABLE DETALLE_TRATAMIENTO CASCADE CONSTRAINTS;

--Creamos las tablas para la base de datos

--Creamos la Tabla Profesion, que contendra un catalogo de todas las profesiones
CREATE TABLE Profesion(
    Id_Profesion    NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50) NOT NULL
);

--Creamos la Tabla para Empleado, que contendra todos los empleados y su informacion
CREATE TABLE Empleado(
    Id_Empleado     NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombres         VARCHAR2(25) NOT NULL,
    Apellidos       VARCHAR2(50) NOT NULL,
    Direccion       VARCHAR2(50),
    Telefono        VARCHAR(20),
    Fecha_Nacimiento    DATE,
    Genero          VARCHAR(1),
    ID_PROFESION    NUMBER NOT NULL,
    CONSTRAINT FK_EMPLEADO_PROFESION FOREIGN KEY (ID_PROFESION) REFERENCES Profesion(Id_Profesion)
);

--Creamos la Tabla Paciente, que contendra todos los pacientes y su informacion
CREATE TABLE Paciente(
    Id_Paciente     NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombres         VARCHAR2(25) NOT NULL,
    Apellidos       VARCHAR2(50) NOT NULL,
    Direccion       VARCHAR2(50),
    Telefono        VARCHAR(20),
    Fecha_Nacimiento    DATE,
    Genero          VARCHAR(1),
    Altura          NUMBER,
    Peso            NUMBER
);

--Creamos la Tabla Evaluacion, que tendra la evaluacion de los pacientes
CREATE TABLE Evaluacion(
    Id_Evaluacion   NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Fecha           DATE,
    ID_EMPLEADO     NUMBER NOT NULL,
    ID_PACIENTE     NUMBER NOT NULL,
    CONSTRAINT FK_EVALUACION_EMPLEADO FOREIGN KEY (ID_EMPLEADO) REFERENCES Empleado(Id_Empleado),
    CONSTRAINT FK_EVALUACION_PACIENTE FOREIGN KEY (ID_PACIENTE) REFERENCES Paciente(Id_Paciente)
);

--Creamos la Tabla Sintoma, que tendra un catalogo con todos los sintomas
CREATE TABLE Sintoma(
    Id_Sintoma      NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50)
);

--Creamos la Tabla Detalle_Evaluacion, que tendra todos los sintomas que presento el paciente durante la evaluacion.
CREATE TABLE Detalle_Evaluacion(
    Id_Detalle      NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    ID_EVALUACION   NUMBER NOT NULL,
    ID_SINTOMA      NUMBER NOT NULL,
    CONSTRAINT FK_DETALLE_EVALUACION FOREIGN KEY (ID_EVALUACION) REFERENCES Evaluacion(Id_Evaluacion),
    CONSTRAINT FK_DETALLE_SINTOMA FOREIGN KEY (ID_SINTOMA) REFERENCES Sintoma(Id_Sintoma)
);

--Creamos la Tabla Diagnostico, que tendra un catalogo con todos los diagnosticos comprobados
CREATE TABLE Diagnostico(
    Id_Diagnostico  NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50)
);

--Creamos la Tabla con la que Asociamos Sintoma y Diagnostico
CREATE TABLE Sintoma_Diagnostico(
    Id_Sintoma_Diagnostico  NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Rango           NUMBER NOT NULL,
    ID_DIAGNOSTICO  NUMBER NOT NULL,
    ID_SINTOMA      NUMBER NOT NULL,
    CONSTRAINT FK_SINTOMA_DIAGNOSTICO_DIAGNOSTICO FOREIGN KEY (ID_DIAGNOSTICO) REFERENCES Diagnostico(Id_Diagnostico),
    CONSTRAINT FK_SINTOMA_DIAGNOSTICO_SINTOMA FOREIGN KEY (ID_SINTOMA) REFERENCES Sintoma(Id_Sintoma)
);

--*AUN POR VERIFICAR ESTA TABLA*
--Creamos la Tabla Seguimiento, que tendra en que fecha inicio los tratamientos
CREATE TABLE Seguimiento(
    Id_Seguimiento  NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Fecha           DATE,
    ID_PACIENTE     NUMBER NOT NULL,
    CONSTRAINT FK_SEGUIMIENTO_PACIENTE FOREIGN KEY (ID_PACIENTE) REFERENCES Paciente (Id_Paciente)
);

--Creamos la Tabla Tratamiento que tendra un catalogo con todos los tratamientos que se han comprobado
CREATE TABLE Tratamiento(
    Id_Tratamiento  NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50)
);

--Creamos la Tabla Detalle_Tratamiento donde estaran todos los tratamientos que esta llevando un Paciente
CREATE TABLE Detalle_Tratamiento(
    Id_Detalle      NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    ID_SEGUIMIENTO  NUMBER NOT NULL,
    ID_TRATAMIENTO  NUMBER NOT NULL,
    CONSTRAINT FK_DETALLE_TRATAMIENTO_SEGUIMIENTO FOREIGN KEY (ID_SEGUIMIENTO) REFERENCES Seguimiento(Id_Seguimiento),
    CONSTRAINT FK_DETALLE_TRATAMIENTO_TRATAMIENTO FOREIGN KEY (ID_TRATAMIENTO) REFERENCES Tratamiento(Id_Tratamiento)
);





