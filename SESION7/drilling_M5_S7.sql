-- MODELO ENTIDAD - RELACION 

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
    IDHerramienta NUMERIC(12) NOT NULL,
    Cliente_RUT VARCHAR(10) NOT NULL,
    FOREIGN KEY (IDHerramienta) REFERENCES Herramienta(IDHerramienta),
    FOREIGN KEY (Cliente_RUT) REFERENCES Cliente(RUT)
);


--1.Listar los clientes sin arriendos por medio de una subconsulta.

SELECT 
    c.RUT, 
    c.Nombre 
FROM 
    Cliente c
WHERE 
    c.RUT NOT IN (SELECT a.Cliente_RUT FROM Arriendo a);

-- 2.Listar todos los arriendos con las siguientes columnas: Folio, Fecha, Dias, ValorDia, NombreCliente, RutCliente.

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


-- 3.Clasificar los clientes según la siguiente tabla.
 
   
-- creamos una tabla temporal para almacenar la clasificación de cada cliente y el número de arriendos mensuales.
   
  CREATE TEMP TABLE ClienteClasificacion (
    RUT VARCHAR(10),
    Nombre VARCHAR(120),
    CantidadArriendosMensuales INT,
    Clasificacion VARCHAR(10)
);


-- insertamos los datos clasificados en la tabla temporal.

INSERT INTO ClienteClasificacion (RUT, Nombre, CantidadArriendosMensuales, Clasificacion)
SELECT 
    c.RUT,
    c.Nombre,
    COALESCE(COUNT(a.Folio), 0) AS CantidadArriendosMensuales,
    CASE 
        WHEN COALESCE(COUNT(a.Folio), 0) = 0 THEN 'Bajo'
        WHEN COALESCE(COUNT(a.Folio), 0) = 1 THEN 'Bajo'
        WHEN COALESCE(COUNT(a.Folio), 0) BETWEEN 2 AND 3 THEN 'Medio'
        WHEN COALESCE(COUNT(a.Folio), 0) >= 4 THEN 'Alto'
    END AS Clasificacion
FROM 
    Cliente c
LEFT JOIN 
    Arriendo a ON c.RUT = a.Cliente_RUT AND a.Fecha BETWEEN DATE_TRUNC('month', CURRENT_DATE) AND (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')
GROUP BY 
    c.RUT, c.Nombre;

-- consulta la tabla temporal para ver la clasificación de los clientes.  

SELECT * FROM ClienteClasificacion;

-- para borrar la tabla temporal 
  
DROP TABLE ClienteClasificacion;


--4. Por medio de una subconsulta, listar los clientes con el nombre de la herramienta más arrendada.

SELECT 
    c.RUT, 
    c.Nombre, 
    h.Nombre AS HerramientaMasArrendada
FROM 
    Cliente c
JOIN 
    Arriendo a ON c.RUT = a.Cliente_RUT
JOIN 
    Herramienta h ON a.IDHerramienta = h.IDHerramienta
WHERE 
    h.IDHerramienta = (
        SELECT 
            a2.IDHerramienta
        FROM 
            Arriendo a2
        GROUP BY 
            a2.IDHerramienta
        ORDER BY 
            COUNT(a2.Folio) DESC
        LIMIT 1
    );


   
   
   