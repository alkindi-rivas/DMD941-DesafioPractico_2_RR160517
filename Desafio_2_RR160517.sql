CREATE DATABASE MovilidadCovidElSalvador;
GO


USE MovilidadCovidElSalvador;

/*
Creación de tabla dimensional de Tiempo
*/
CREATE TABLE dimTiempo (
    idTiempo INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE,
    anio INT,
    mes INT,
    dia INT,
    nombre_dia NVARCHAR(20)
);

INSERT INTO dimTiempo (fecha, anio, mes, dia, nombre_dia)
SELECT DISTINCT
    date,
    YEAR(date),
    MONTH(date),
    DAY(date),
    DATENAME(WEEKDAY, date)
FROM MovilidadElSalvador2020;

/*
Creación de tabla dimensional de Ubiçación
*/

CREATE TABLE dimUbicacion (
    idUbicacion INT IDENTITY(1,1) PRIMARY KEY,
    pais NVARCHAR(100),
    departamento NVARCHAR(100)
);

INSERT INTO dimUbicacion (pais, departamento)
SELECT DISTINCT
    country_region,
    sub_region_1
FROM MovilidadElSalvador2020;

/*
Creación de tabla dimensional de Categorías
*/
CREATE TABLE dimCategoria (
    idCategoria INT PRIMARY KEY,
    nombre_categoria NVARCHAR(100)
);

INSERT INTO dimCategoria (idCategoria, nombre_categoria)
VALUES 
(1, 'Comercio y recreacion'),
(2, 'Supermercados y farmacias'),
(3, 'Parques y espacios publicos'),
(4, 'Estaciones de transporte'),
(5, 'Lugares de trabajo'),
(6, 'Residencias');

/*
Creación de tabla de hechos
*/

CREATE TABLE HechosMovilidad (
    idHecho INT IDENTITY(1,1) PRIMARY KEY,
    idTiempo INT,
    idUbicacion INT,
    idCategoria INT,
    valorCambio INT,
    FOREIGN KEY (idTiempo) REFERENCES dimTiempo(idTiempo),
    FOREIGN KEY (idUbicacion) REFERENCES dimUbicacion(idUbicacion),
    FOREIGN KEY (idCategoria) REFERENCES dimCategoria(idCategoria)
);

ALTER TABLE HechosMovilidad
ALTER COLUMN valorCambio FLOAT;

/*
Insetar datos en la tabla Hechos
1) Comercio y recreación
*/

INSERT INTO HechosMovilidad (idTiempo, idUbicacion, idCategoria, valorCambio)
SELECT 
    t.idTiempo,
    u.idUbicacion,
    1,
    m.retail_and_recreation_percent_change_from_baseline
FROM MovilidadElSalvador2020 m
JOIN dimTiempo t ON m.date = t.fecha
JOIN dimUbicacion u 
    ON ISNULL(LTRIM(RTRIM(LOWER(m.country_region))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.pais))), '')
    AND ISNULL(LTRIM(RTRIM(LOWER(m.sub_region_1))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.departamento))), '');


/*
Insetar datos en la tabla Hechos
2) Supermercados y farmacias
*/
INSERT INTO HechosMovilidad (idTiempo, idUbicacion, idCategoria, valorCambio)
SELECT 
    t.idTiempo,
    u.idUbicacion,
    2, /* Supermercados y farmacias */
    m.grocery_and_pharmacy_percent_change_from_baseline
FROM MovilidadElSalvador2020 m
JOIN dimTiempo t ON m.date = t.fecha
JOIN dimUbicacion u 
    ON ISNULL(LTRIM(RTRIM(LOWER(m.country_region))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.pais))), '')
    AND ISNULL(LTRIM(RTRIM(LOWER(m.sub_region_1))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.departamento))), '');

/*
Insetar datos en la tabla Hechos
3) Parques y espacios publicos
*/
INSERT INTO HechosMovilidad (idTiempo, idUbicacion, idCategoria, valorCambio)
SELECT 
    t.idTiempo,
    u.idUbicacion,
    3, /* Parques y espacios publicos */
    m.parks_percent_change_from_baseline
FROM MovilidadElSalvador2020 m
JOIN dimTiempo t ON m.date = t.fecha
JOIN dimUbicacion u 
    ON ISNULL(LTRIM(RTRIM(LOWER(m.country_region))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.pais))), '')
    AND ISNULL(LTRIM(RTRIM(LOWER(m.sub_region_1))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.departamento))), '');

/*
Insetar datos en la tabla Hechos
4) Estaciones de transporte
*/
INSERT INTO HechosMovilidad (idTiempo, idUbicacion, idCategoria, valorCambio)
SELECT 
    t.idTiempo,
    u.idUbicacion,
    4, /* Estaciones de transporte */
    m.transit_stations_percent_change_from_baseline
FROM MovilidadElSalvador2020 m
JOIN dimTiempo t ON m.date = t.fecha
JOIN dimUbicacion u 
    ON ISNULL(LTRIM(RTRIM(LOWER(m.country_region))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.pais))), '')
    AND ISNULL(LTRIM(RTRIM(LOWER(m.sub_region_1))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.departamento))), '');

/*
Insetar datos en la tabla Hechos
5) Lugares de trabajo
*/
INSERT INTO HechosMovilidad (idTiempo, idUbicacion, idCategoria, valorCambio)
SELECT 
    t.idTiempo,
    u.idUbicacion,
    5, /* Lugares de trabajo */
    m.workplaces_percent_change_from_baseline
FROM MovilidadElSalvador2020 m
JOIN dimTiempo t ON m.date = t.fecha
JOIN dimUbicacion u 
    ON ISNULL(LTRIM(RTRIM(LOWER(m.country_region))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.pais))), '')
    AND ISNULL(LTRIM(RTRIM(LOWER(m.sub_region_1))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.departamento))), '');

/*
Insetar datos en la tabla Hechos
6) Residencias
*/
INSERT INTO HechosMovilidad (idTiempo, idUbicacion, idCategoria, valorCambio)
SELECT 
    t.idTiempo,
    u.idUbicacion,
    6, /* Residencias */
    m.residential_percent_change_from_baseline
FROM MovilidadElSalvador2020 m
JOIN dimTiempo t ON m.date = t.fecha
JOIN dimUbicacion u 
    ON ISNULL(LTRIM(RTRIM(LOWER(m.country_region))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.pais))), '')
    AND ISNULL(LTRIM(RTRIM(LOWER(m.sub_region_1))), '') = ISNULL(LTRIM(RTRIM(LOWER(u.departamento))), '');

SELECT TOP 100 * FROM HechosMovilidad;