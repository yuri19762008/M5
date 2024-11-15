

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
    Celular VARCHAR(15) NOT NULL
);

CREATE TABLE Herramienta (
    IDHerramienta NUMERIC(12) PRIMARY KEY,
    Nombre VARCHAR(120) NOT NULL,
    PrecioDia NUMERIC(12, 2) NOT NULL
);

CREATE TABLE Arriendo (
    Folio NUMERIC(12) PRIMARY KEY,
    Fecha DATE NOT NULL,
    Dias NUMERIC(5) NOT NULL,
    ValorDia NUMERIC(12, 2) NOT NULL,
    Garantia VARCHAR(30) NOT NULL,
    Herramienta_IDHerramienta NUMERIC(12) NOT NULL,
    Cliente_RUT VARCHAR(10) NOT NULL,
    FOREIGN KEY (Herramienta_IDHerramienta) REFERENCES Herramienta(IDHerramienta),
    FOREIGN KEY (Cliente_RUT) REFERENCES Cliente(RUT)
);

--1. Listar todos los arriendos con las siguientes columnas: Folio, Fecha, Días, --   ValorDia, NombreCliente, RutCliente.

SELECT 
    a.Folio, 
    a.Fecha, 
    a.Dias, 
    a.ValorDia, 
    c.Nombre AS NombreCliente, 
    c.RUT AS RutCliente
FROM 
    Arriendo a
JOIN 
    Cliente c ON a.Cliente_RUT = c.RUT;


-- 2. Listar los clientes sin arriendos.

SELECT 
    c.RUT, 
    c.Nombre 
FROM 
    Cliente c
LEFT JOIN 
    Arriendo a ON c.RUT = a.Cliente_RUT
WHERE 
    a.Cliente_RUT IS NULL;


-- 3. Liste RUT y Nombre de las tablas empresa y cliente.

SELECT RUT, Nombre 
FROM Cliente
UNION
SELECT RUT, Nombre 
FROM Empresa;


-- 4. Liste la cantidad de arriendos por mes.

SELECT 
    DATE_TRUNC('month', Fecha) AS Mes,
    COUNT(*) AS CantidadArriendos
FROM 
    Arriendo
GROUP BY 
    DATE_TRUNC('month', Fecha)
ORDER BY 
    Mes;


