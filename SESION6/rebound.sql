

CREATE TABLE Empresa (
    RUT VARCHAR(10) PRIMARY KEY,
    Nombre VARCHAR(120),
    Direccion VARCHAR(120),
    Telefono VARCHAR(15),
    Correo VARCHAR(80),
    Web VARCHAR(50)
);

CREATE TABLE Cliente (
    RUT VARCHAR(10) PRIMARY KEY,
    Nombre VARCHAR(120),
    Correo VARCHAR(80),
    Direccion VARCHAR(120),
    Celular VARCHAR(15),
    Alta CHAR(1)
);

CREATE TABLE TipoVehiculo (
    IDTipoVehiculo SERIAL PRIMARY KEY,
    Nombre VARCHAR(120)
);

CREATE TABLE Marca (
    IDMarca SERIAL PRIMARY KEY,
    Nombre VARCHAR(120)
);

CREATE TABLE Vehiculo (
    IDVehiculo SERIAL PRIMARY KEY,
    Patente VARCHAR(10),
    Marca VARCHAR(20),
    Modelo VARCHAR(20),
    Color VARCHAR(15),
    Precio NUMERIC(12, 2),
    FrecuenciaMantencion NUMERIC(5),
    Marca_IDMarca INT,
    TipoVehiculo_IDTipoVehiculo INT,
    FOREIGN KEY (Marca_IDMarca) REFERENCES Marca(IDMarca),
    FOREIGN KEY (TipoVehiculo_IDTipoVehiculo) REFERENCES TipoVehiculo(IDTipoVehiculo)
);

CREATE TABLE Venta (
    Folio SERIAL PRIMARY KEY,
    Fecha DATE,
    Monto NUMERIC(12, 2),
    Vehiculo_IDVehiculo INT,
    Cliente_RUT VARCHAR(10),
    FOREIGN KEY (Vehiculo_IDVehiculo) REFERENCES Vehiculo(IDVehiculo),
    FOREIGN KEY (Cliente_RUT) REFERENCES Cliente(RUT)

CREATE INDEX Venta__IDX ON Venta (Vehiculo_IDVehiculo);

);

CREATE TABLE Mantencion (
    IDMantencion SERIAL PRIMARY KEY,
    Fecha DATE,
    TrabajosRealizados VARCHAR(1000),
    Venta_Folio INT,
    FOREIGN KEY (Venta_Folio) REFERENCES Venta(Folio)
);


--Tabla empresa:
INSERT INTO empresa (rut, nombre, direccion, telefono, correo, web) VALUES
('11111111-1', 'Empresa 1', 'Av. Principal 123', '987654321', 'contacto@empresa1.cl', 'www.empresa1.cl'),
('22222222-2', 'Empresa 2', 'Calle Secundaria 456', '912345678', 'contacto@empresa2.cl', 'www.empresa2.cl');

--Tabla cliente:
INSERT INTO cliente (rut, nombre, correo, direccion, celular, alta) VALUES
('33333333-3', 'Juan Pérez', 'juan.perez@gmail.com', 'Calle A 789', '987654321', 'S'),
('44444444-4', 'Ana Gómez', 'ana.gomez@gmail.com', 'Av. B 321', '912345678', 'S');

--Tabla marca:
INSERT INTO marca (idMarca, nombre) VALUES
(1, 'Toyota'),
(2, 'Honda'),
(3, 'Ford');

--Tabla tipoVehiculo:
INSERT INTO tipoVehiculo (idTipoVehiculo, nombre) VALUES
(1, 'Sedán'),
(2, 'SUV'),
(3, 'Camioneta');

--Tabla vehiculo:
INSERT INTO vehiculo (idVehiculo, patente, marca, modelo, color, precio, frecuenciaMantencion, marca_idMarca, tipovehiculo_idTipoVehiculo) VALUES
(1, 'ABC123', 'Corolla', '2020', 'Rojo', 15000, 6, 1, 1),
(2, 'DEF456', 'Civic', '2019', 'Negro', 18000, 6, 2, 1),
(3, 'GHI789', 'Ranger', '2020', 'Blanco', 25000, 12 , 3, 3);

--Tabla venta:
INSERT INTO venta (folio, fecha, monto, vehiculo_idVehiculo, cliente_rut) VALUES
(1001, '2020-01-10', 15000, 1, '33333333-3'),
(1002, '2020-01-15', 18000, 2, '44444444-4');

--Tabla mantención:
INSERT INTO mantencion (idMantencion, fecha, trabajosRealizados, venta_folio) VALUES
(1, '2020-06-10', 'Cambio de aceite', 1001),
(2, '2020-06-20', 'Revisión general', 1002);


--1. Listar todos los vehículos que no han sido vendidos.

SELECT * 
FROM Vehiculo 
WHERE IDVehiculo NOT IN (SELECT Vehiculo_IDVehiculo FROM Venta);

SELECT v.* 
FROM Vehiculo v 
LEFT JOIN Venta ve ON v.IDVehiculo = ve.Vehiculo_IDVehiculo 
WHERE ve.Vehiculo_IDVehiculo IS NULL;


--2. Listar todas las ventas de enero del 2020 con las columnas: Folio, FechaVenta, MontoVenta, 
--   NombreCliente, RutCliente, Patente, NombreMarca, y Modelo.

SELECT 
    v.Folio, 
    v.Fecha AS FechaVenta, 
    v.Monto AS MontoVenta, 
    c.Nombre AS NombreCliente, 
    c.RUT AS RutCliente, 
    veh.Patente, 
    m.Nombre AS NombreMarca, 
    veh.Modelo
FROM 
    Venta v
JOIN 
    Cliente c ON v.Cliente_RUT = c.RUT
JOIN 
    Vehiculo veh ON v.Vehiculo_IDVehiculo = veh.IDVehiculo
JOIN 
    Marca m ON veh.Marca_IDMarca = m.IDMarca
WHERE 
    v.Fecha BETWEEN '2020-01-01' AND '2020-01-31';
   

   
-- 3. Sumar las ventas por mes y marca del año 2020.

SELECT 
    DATE_TRUNC('month', v.Fecha) AS Mes,
    m.Nombre AS Marca,
    SUM(v.Monto) AS TotalVentas
FROM 
    Venta v
JOIN 
    Vehiculo veh ON v.Vehiculo_IDVehiculo = veh.IDVehiculo
JOIN 
    Marca m ON veh.Marca_IDMarca = m.IDMarca
WHERE 
    v.Fecha BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY 
    DATE_TRUNC('month', v.Fecha), m.Nombre
ORDER BY 
    Mes, Marca;

-- 4. Listar Rut y Nombre de las tablas cliente y empresa.   

SELECT RUT, Nombre 
FROM Cliente
UNION
SELECT RUT, Nombre 
FROM Empresa;






