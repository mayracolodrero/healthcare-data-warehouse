CREATE DATABASE ProyectoC;
GO
USE ProyectoC;
GO

-- 1. CREACIÓN DE TABLAS Y CLAVES PRIMARIAS

CREATE TABLE [dbo].[detalleestancia](
	[id_detalleestancia_dw] [int] IDENTITY(1,1) NOT NULL,
	[unidadhospitalaria] [varchar](50) NULL,
	[tipoestancia] [varchar](15) NULL,
	CONSTRAINT [detalleestancia_pk] PRIMARY KEY CLUSTERED ([id_detalleestancia_dw] ASC)
);
GO

CREATE TABLE [dbo].[dim_diagnostico](
	[id_diagnostico_dw] [int] IDENTITY(1,1) NOT NULL,
	[diagnosticoid] [int] NOT NULL,
	[prioridad] [varchar](10) NULL,
	[codeicd9] [varchar](100) NULL,
	[nombrediagnostico] [varchar](100) NULL,
	[nombresubcategoria] [varchar](100) NULL,
	[nombreespecialidad] [varchar](100) NULL,
	CONSTRAINT [dim_diagnostico_pk] PRIMARY KEY CLUSTERED ([id_diagnostico_dw] ASC)
);
GO

CREATE TABLE [dbo].[dim_frecuencia](
	[id_frecuencia_dw] [int] IDENTITY(1,1) NOT NULL,
	[frecuencia] [varchar](100) NULL,
	[tipo_frecuencia] [varchar](50) NULL,
	CONSTRAINT [dim_frecuencia_pk] PRIMARY KEY CLUSTERED ([id_frecuencia_dw] ASC)
);
GO

CREATE TABLE [dbo].[dim_hospital](
	[id_hospital_dw] [int] IDENTITY(1,1) NOT NULL,
	[hospitalid] [int] NOT NULL,
	[region] [varchar](64) NULL,
	[docencia] [char](1) NULL,
	[rangocantidadcamas] [varchar](32) NULL,
	CONSTRAINT [dim_hospital_pk] PRIMARY KEY CLUSTERED ([id_hospital_dw] ASC)
);
GO

CREATE TABLE [dbo].[dim_laboratorio](
	[id_laboratorio_dw] [int] IDENTITY(1,1) NOT NULL,
	[laboratorioid] [int] NOT NULL,
	[nombre] [varchar](256) NULL,
	[medida] [varchar](255) NULL,
	[categoria] [varchar](30) NULL,
	CONSTRAINT [dim_laboratorio_pk] PRIMARY KEY CLUSTERED ([id_laboratorio_dw] ASC)
);
GO

CREATE TABLE [dbo].[dim_medicamento](
	[id_medicamento_dw] [int] IDENTITY(1,1) NOT NULL,
	[medicationid] [int] NOT NULL,
	[drughiclseqno] [int] NULL,
	[nombre] [varchar](220) NULL,
	[viaadministracion] [varchar](120) NULL,
	[dosis] [varchar](60) NULL,
	[id_frecuencia_dw] [int] NULL,
	CONSTRAINT [dim_medicamento_pk] PRIMARY KEY CLUSTERED ([id_medicamento_dw] ASC)
);
GO

CREATE TABLE [dbo].[dim_tiempo](
	[id_tiempo_dw] [int] IDENTITY(1,1) NOT NULL,
	[horaadmision] [time](7) NULL,
	[turnoadmision] [varchar](10) NULL,
	CONSTRAINT [dim_tiempo_pk] PRIMARY KEY CLUSTERED ([id_tiempo_dw] ASC)
);
GO

CREATE TABLE [dbo].[dim_tratamiento](
	[id_tratamiento_dw] [int] IDENTITY(1,1) NOT NULL,
	[tratamientoid] [int] NOT NULL,
	[activoalalta] [char](1) NULL,
	[nombretratamiento] [varchar](100) NULL,
	[subcategoria] [varchar](100) NULL,
	[especialidad] [varchar](100) NULL,
	CONSTRAINT [dim_tratamiento_pk] PRIMARY KEY CLUSTERED ([id_tratamiento_dw] ASC)
);
GO

CREATE TABLE [dbo].[fact_ingreso](
	[fact_ingreso_id] [int] IDENTITY(1,1) NOT NULL,
	[patientunitstayid] [int] NOT NULL,
	[duracioningresodias] [decimal](10, 2) NULL,
	[rangoedad] [varchar](15) NULL,
	[mortalidad] [char](1) NULL,
	[puntuacionapache] [int] NULL,
	[anioalta] [smallint] NULL,
	[dim_hospital_id_hospital_dw] [int] NULL,
	[dim_tiempo_id_tiempo_dw] [int] NULL,
	[paciente_id_paciente_dw] [int] NULL,
	[id_detalleestancia_dw] [int] NULL,
	CONSTRAINT [fact_ingreso_pk] PRIMARY KEY CLUSTERED ([fact_ingreso_id] ASC)
);
GO

CREATE TABLE [dbo].[fact_laboratorio](
	[id_fact_laboratorio_dw] [int] IDENTITY(1,1) NOT NULL,
	[resultado_laboratorio] [decimal](11, 4) NULL,
	[id_laboratorio_dw] [int] NOT NULL,
	[fact_ingreso_fact_ingreso_id] [int] NOT NULL,
	CONSTRAINT [fact_laboratorio_pk] PRIMARY KEY CLUSTERED ([id_fact_laboratorio_dw] ASC)
);
GO

CREATE TABLE [dbo].[ingreso_diagnostico](
	[fact_ingreso_fact_ingreso_id] [int] NOT NULL,
	[id_diagnostico_dw] [int] NOT NULL,
	CONSTRAINT [ingreso_diagnostico_pk] PRIMARY KEY CLUSTERED ([fact_ingreso_fact_ingreso_id] ASC, [id_diagnostico_dw] ASC)
);
GO

CREATE TABLE [dbo].[ingreso_medicamento](
	[fact_ingreso_fact_ingreso_id] [int] NOT NULL,
	[id_medicamento_dw] [int] NOT NULL,
	CONSTRAINT [ingreso_medicamento_pk] PRIMARY KEY CLUSTERED ([fact_ingreso_fact_ingreso_id] ASC, [id_medicamento_dw] ASC)
);
GO

CREATE TABLE [dbo].[ingreso_tratamiento](
	[fact_ingreso_fact_ingreso_id] [int] NOT NULL,
	[id_tratamiento_dw] [int] NOT NULL,
	CONSTRAINT [ingreso_tratamiento_pk] PRIMARY KEY CLUSTERED ([fact_ingreso_fact_ingreso_id] ASC, [id_tratamiento_dw] ASC)
);
GO

CREATE TABLE [dbo].[paciente](
	[id_paciente_dw] [int] IDENTITY(1,1) NOT NULL,
	[pacienteid] [int] NOT NULL,
	[genero] [nvarchar](25) NULL,
	[etnia] [varchar](50) NULL,
	[rango_altura] [varchar](20) NULL,
	[rango_peso] [varchar](20) NULL,
	CONSTRAINT [paciente_pk] PRIMARY KEY CLUSTERED ([id_paciente_dw] ASC)
);
GO

-- 2. CREACIÓN DE CLAVES FORÁNEAS (RELACIONES)

ALTER TABLE [dbo].[dim_medicamento] ADD CONSTRAINT [fk_dim_medicamento_frecuencia] FOREIGN KEY([id_frecuencia_dw]) REFERENCES [dbo].[dim_frecuencia] ([id_frecuencia_dw]);
GO

ALTER TABLE [dbo].[fact_ingreso] ADD CONSTRAINT [fk_facting_dim_hospital] FOREIGN KEY([dim_hospital_id_hospital_dw]) REFERENCES [dbo].[dim_hospital] ([id_hospital_dw]);
GO

ALTER TABLE [dbo].[fact_ingreso] ADD CONSTRAINT [fk_facting_dim_tiempo] FOREIGN KEY([dim_tiempo_id_tiempo_dw]) REFERENCES [dbo].[dim_tiempo] ([id_tiempo_dw]);
GO

ALTER TABLE [dbo].[fact_ingreso] ADD CONSTRAINT [fk_facting_paciente] FOREIGN KEY([paciente_id_paciente_dw]) REFERENCES [dbo].[paciente] ([id_paciente_dw]);
GO

ALTER TABLE [dbo].[fact_ingreso] ADD CONSTRAINT [fk_factingreso_detalleestancia] FOREIGN KEY([id_detalleestancia_dw]) REFERENCES [dbo].[detalleestancia] ([id_detalleestancia_dw]);
GO

ALTER TABLE [dbo].[fact_laboratorio] ADD CONSTRAINT [fk_factlab_dimlab] FOREIGN KEY([id_laboratorio_dw]) REFERENCES [dbo].[dim_laboratorio] ([id_laboratorio_dw]);
GO

ALTER TABLE [dbo].[ingreso_diagnostico] ADD CONSTRAINT [fk_ingdiag_dimdiag] FOREIGN KEY([id_diagnostico_dw]) REFERENCES [dbo].[dim_diagnostico] ([id_diagnostico_dw]);
GO

ALTER TABLE [dbo].[ingreso_diagnostico] ADD CONSTRAINT [fk_ingdiag_factingreso] FOREIGN KEY([fact_ingreso_fact_ingreso_id]) REFERENCES [dbo].[fact_ingreso] ([fact_ingreso_id]);
GO

ALTER TABLE [dbo].[ingreso_medicamento] ADD CONSTRAINT [fk_ingmed_dimmedicamento] FOREIGN KEY([id_medicamento_dw]) REFERENCES [dbo].[dim_medicamento] ([id_medicamento_dw]);
GO

ALTER TABLE [dbo].[ingreso_medicamento] ADD CONSTRAINT [fk_ingmed_factingreso] FOREIGN KEY([fact_ingreso_fact_ingreso_id]) REFERENCES [dbo].[fact_ingreso] ([fact_ingreso_id]);
GO

ALTER TABLE [dbo].[ingreso_tratamiento] ADD CONSTRAINT [fk_ingtrat_dimtratamiento] FOREIGN KEY([id_tratamiento_dw]) REFERENCES [dbo].[dim_tratamiento] ([id_tratamiento_dw]);
GO

ALTER TABLE [dbo].[ingreso_tratamiento] ADD CONSTRAINT [fk_ingtrat_factingreso] FOREIGN KEY([fact_ingreso_fact_ingreso_id]) REFERENCES [dbo].[fact_ingreso] ([fact_ingreso_id]);
GO

-- 3. PROCEDIMIENTOS ALMACENADOS

CREATE OR ALTER PROCEDURE [dbo].[borrar_almacen]
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. PRIMERO LAS TABLAS PUENTE
    DELETE FROM dbo.ingreso_diagnostico;
    DELETE FROM dbo.ingreso_medicamento;
    DELETE FROM dbo.ingreso_tratamiento;

    -- 2. SEGUNDO LAS TABLAS DE HECHOS
    DELETE FROM dbo.fact_laboratorio;
    DELETE FROM dbo.fact_ingreso;

    -- 3. TERCERO LAS DIMENSIONES DEPENDIENTES
    DELETE FROM dbo.dim_laboratorio;
    DELETE FROM dbo.dim_diagnostico;
    DELETE FROM dbo.dim_medicamento; 
    DELETE FROM dbo.dim_tratamiento;

    -- 4. CUARTO LAS DIMENSIONES BASE O PRINCIPALES
    DELETE FROM dbo.dim_frecuencia;
    DELETE FROM dbo.detalleestancia; 
    DELETE FROM dbo.paciente;
    DELETE FROM dbo.dim_hospital;
    DELETE FROM dbo.dim_tiempo;
END
GO