

CREATE TABLE Empresa (
    RUT VARCHAR(10) PRIMARY KEY,
    Nombre VARCHAR(120) NOT NULL,
    Direccion VARCHAR(120) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Correo VARCHAR(80) NOT NULL,
    Web VARCHAR(50) NOT NULL
);


CREATE TABLE Cliente (
    RUT VARCHAR(10) PRIMARY KEY,
    Nombre VARCHAR(120) NOT NULL,
    Correo VARCHAR(80) NOT NULL,
    Direccion VARCHAR(120) NOT NULL,
    Celular VARCHAR(15) NOT NULL,
    Alta CHAR(1) NOT NULL
);

CREATE TABLE Marca (
    IDMarca NUMERIC(12) PRIMARY KEY,
    Nombre VARCHAR(120) NOT NULL
);

CREATE TABLE TipoVehiculo (
    IDTipoVehiculo NUMERIC(12) PRIMARY KEY,
    Nombre VARCHAR(120) NOT NULL
);


CREATE TABLE Vehiculo (
    IDVehiculo NUMERIC(12) PRIMARY KEY,
    Patente VARCHAR(10) NOT NULL,
    Marca VARCHAR(20) NOT NULL,
    Modelo VARCHAR(20) NOT NULL,
    Color VARCHAR(15) NOT NULL,
    Precio NUMERIC(12, 2) NOT NULL,
    FrecuenciaMantenimiento NUMERIC(5) NOT NULL,
    Marca_IDMarca NUMERIC(12) NOT NULL,
    TipoVehiculo_IDTipoVehiculo NUMERIC(12) NOT NULL,
    FOREIGN KEY (Marca_IDMarca) REFERENCES Marca(IDMarca),
    FOREIGN KEY (TipoVehiculo_IDTipoVehiculo) REFERENCES TipoVehiculo(IDTipoVehiculo)
);




CREATE TABLE Venta (
    Folio NUMERIC(12) PRIMARY KEY,
    Fecha DATE NOT NULL,
    Monto NUMERIC(12) NOT NULL,
    Vehiculo_IDVehiculo NUMERIC(12) NOT NULL,
    Cliente_RUT VARCHAR(10) NOT NULL,
    FOREIGN KEY (Vehiculo_IDVehiculo) REFERENCES Vehiculo(IDVehiculo),
    FOREIGN KEY (Cliente_RUT) REFERENCES Cliente(RUT)
);

CREATE INDEX Venta_IDX ON Venta (Vehiculo_IDVehiculo);


CREATE TABLE Mantenimiento (
    IDMantenimiento NUMERIC(12) PRIMARY KEY,
    Fecha DATE NOT NULL,
    TrabajosRealizados VARCHAR(1000) NOT NULL,
    Venta_Folio NUMERIC(12) NOT NULL,
    FOREIGN KEY (Venta_Folio) REFERENCES Venta(Folio)
);


-- 1. Listar los clientes sin ventas por medio de una subconsulta.

SELECT 
    c.RUT, 
    c.Nombre 
FROM 
    Cliente c
WHERE 
    c.RUT NOT IN (
        SELECT 
            v.Cliente_RUT 
        FROM 
            Venta v
    );

-- 2. Listar todas ventas con las siguientes columnas: Folio, Fecha, Monto, NombreCliente, RutCliente.
   
SELECT 
    v.Folio, 
    v.Fecha, 
    v.Monto, 
    c.Nombre AS NombreCliente, 
    c.RUT AS RutCliente
FROM 
    Venta v
JOIN 
    Cliente c ON v.Cliente_RUT = c.RUT;

--3. Clasificar los clientes según la tabla.
   
-- Tabla Temporal para Clasificación

CREATE TEMP TABLE ClienteClasificacion (
    RUT VARCHAR(10),
    Nombre VARCHAR(120),
    TotalVentasAnuales NUMERIC(12, 2),
    Clasificacion VARCHAR(10)
);

--  Insertar Datos en la Tabla Temporal.

INSERT INTO ClienteClasificacion (RUT, Nombre, TotalVentasAnuales, Clasificacion)
SELECT 
    c.RUT,
    c.Nombre,
    COALESCE(SUM(v.Monto), 0) AS TotalVentasAnuales,
    CASE 
        WHEN COALESCE(SUM(v.Monto), 0) BETWEEN 0 AND 1000000 THEN 'Standar'
        WHEN COALESCE(SUM(v.Monto), 0) BETWEEN 1000001 AND 3000000 THEN 'Gold'
        WHEN COALESCE(SUM(v.Monto), 0) >= 3000001 THEN 'Premium'
    END AS Clasificacion
FROM 
    Cliente c
LEFT JOIN 
    Venta v ON c.RUT = v.Cliente_RUT AND DATE_PART('year', v.Fecha) = DATE_PART('year', CURRENT_DATE)
GROUP BY 
    c.RUT, c.Nombre;


--  Consultar la Tabla Temporal.
   
 SELECT * FROM ClienteClasificacion;
  

   
-- 4. Por medio de una subconsulta, listar las ventas con la marca del vehículo más vendido.   

SELECT 
    v.Folio, 
    v.Fecha, 
    v.Monto, 
    m.Nombre AS MarcaVehiculo
FROM 
    Venta v
JOIN 
    Vehiculo ve ON v.Vehiculo_IDVehiculo = ve.IDVehiculo
JOIN 
    Marca m ON ve.Marca_IDMarca = m.IDMarca
WHERE 
    ve.Marca_IDMarca = (
        SELECT 
            ve2.Marca_IDMarca
        FROM 
            Venta v2
        JOIN 
            Vehiculo ve2 ON v2.Vehiculo_IDVehiculo = ve2.IDVehiculo
        GROUP BY 
            ve2.Marca_IDMarca
        ORDER BY 
            COUNT(v2.Folio) DESC
        LIMIT 1
    );

