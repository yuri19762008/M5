-- 001 creacion de tabla peliculas
CREATE TABLE peliculas (
    id integer PRIMARY KEY,
    pelicula VARCHAR(255) NOT NULL,
    estreno integer NOT NULL,
    director VARCHAR(255) NOT NULL
);

-- 002 creacion de tabla reparto 
CREATE TABLE reparto (
    id_pelicula integer,
    actor VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_pelicula) REFERENCES peliculas(id)
);
-- 003 carga de datos a las tablas correspondientes  
copy peliculas from 'D:\ApoyoCSV\peliculas.csv' with csv;

copy reparto from 'D:\ApoyoCSV\reparto.csv' with csv;

-- 004 Insertar datos de la película "Titanic"
INSERT INTO peliculas (pelicula, estreno, director) VALUES ('Titanic', '1997-12-19', 'James Cameron');

-- 005 Listar todos los actores que aparecen en la película "Titanic", indicando el título de la película,
-- año de estreno, director y todo el reparto
SELECT 
    p.pelicula,
    p.estreno,
    p.director,
    string_agg(r.actor, ', ') as reparto
FROM 
    peliculas p
JOIN 
    reparto r
ON 
    p.id = r.id_pelicula
WHERE 
    p.pelicula = 'Titanic'
GROUP BY 
    p.pelicula, p.estreno, p.director;
   
-- 008 Listar los 10 directores más populares, indicando su nombre y cuántas películas aparecen
-- en el top 100.
SELECT 
    director,
    COUNT(*) AS num_peliculas
FROM 
    peliculas
WHERE 
    id <= 100
GROUP BY 
    director
ORDER BY 
    num_peliculas DESC
LIMIT 10;



-- 009 Indicar cuántos actores distintos hay

SELECT COUNT(DISTINCT actor) AS num_actores_distintos
FROM reparto;

--010 Indicar las películas estrenadas entre los años 1990 y 1999 (ambos incluidos), ordenadas
--por título de manera ascendente.

SELECT 
    pelicula,
    estreno,
    director
FROM 
    peliculas
WHERE 
    estreno BETWEEN '1990' AND '1999'
ORDER BY 
    pelicula ASC;

   
-- 011 Listar los actores de la película más nueva
select
  p.pelicula ,
  r.actor
from
  peliculas p
  join reparto r on p.id = r.id_pelicula 
where
  p.estreno = (
    select
      max(estreno)
    from
      peliculas
  )
limit
  100;


 
-- 012 Insertar una película que queremos mantener solo en memoria
BEGIN;
INSERT INTO peliculas (id, pelicula, estreno, director) values 
(102,'Película temporal', 2024, 'Director temporal');
ROLLBACK;

-- 012 Insertar una película y confirmar la transacción
BEGIN;
INSERT INTO peliculas (id , pelicula, estreno, director) VALUES
(111,'Película persistente_2', '2024', 'Director persistente');
COMMIT;



-- 013 Comenzar una transacción
BEGIN;

-- Actualizar información de 5 directores
UPDATE peliculas SET director = 'Director Actualizado 1' WHERE id = 1;
UPDATE peliculas SET director = 'Director Actualizado 2' WHERE id = 2;
UPDATE peliculas SET director = 'Director Actualizado 3' WHERE id = 3;
UPDATE peliculas SET director = 'Director Actualizado 4' WHERE id = 4;
UPDATE peliculas SET director = 'Director Actualizado 5' WHERE id = 5;

-- Decidir deshacer los cambios
ROLLBACK;
COMMIT;



-- 014 Comenzar una transacción
BEGIN;

-- Crear un punto de guardado antes de insertar los actores
SAVEPOINT antes_de_insertar_actores;

-- el id de la película "Rambo" es 72
INSERT INTO reparto (id_pelicula, actor) VALUES (72, 'Actor 1');
INSERT INTO reparto (id_pelicula, actor) VALUES (72, 'Actor 2');
INSERT INTO reparto (id_pelicula, actor) VALUES (72, 'Actor 3');

-- Crear otro punto de guardado después de insertar los actores
SAVEPOINT despues_de_insertar_actores;

-- Si decides deshacer los cambios hasta antes de insertar los actores
-- ROLLBACK TO antes_de_insertar_actores;

-- O si decides confirmar todos los cambios realizados
COMMIT;




-- 015 Comenzar una transacción
BEGIN;

-- Eliminar las películas estrenadas en 2008
DELETE FROM peliculas WHERE EXTRACT(estreno FROM estreno) = 2008;

-- Revertir la transacción para que los cambios solo estén en memoria
ROLLBACK;


-- 016 Comenzar una transacción
BEGIN;

-- Insertar actores para cada película estrenada en 2001
WITH peliculas AS (
    SELECT id
    FROM peliculas
    WHERE EXTRACT(YEAR FROM estreno) = 2001
)

-- Insertar dos actores para cada película
INSERT INTO reparto (id_pelicula, actor)
SELECT id, 'Actor 1'
FROM peliculas ;

INSERT INTO reparto (id_pelicula, actor)
SELECT id, 'Actor 2'
FROM peliculas ;

-- Confirmar la transacción
COMMIT;

--17
-- Comenzar una transacción
BEGIN;

-- Actualizar el nombre de la película
UPDATE peliculas
SET pelicula = 'Donkey Kong'
WHERE pelicula = 'King Kong';

-- Revertir la transacción para no efectuar cambios en disco duro
ROLLBACK;


