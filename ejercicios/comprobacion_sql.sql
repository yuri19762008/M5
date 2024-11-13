-- Verificar la estructura de las tablas
\d autores
\d libros
\d comentarios

-- Verificar los datos insertados
SELECT COUNT(*) FROM autores; -- Debería mostrar 7 autores
SELECT COUNT(*) FROM libros;  -- Debería mostrar 10 libros
SELECT COUNT(*) FROM comentarios; -- Debería mostrar 12 comentarios

-- Prueba de cada consulta con verificación de resultados:

-- 1) Verificación de libros con autores
SELECT l.titulo, a.nombre as autor
FROM libros l
JOIN autores a ON l.autor_id = a.id
ORDER BY a.nombre;

-- 2) Verificación de comentarios para el libro con id = 1 (Cien años de soledad)
SELECT l.titulo, a.nombre as autor, c.comentario
FROM libros l
JOIN autores a ON l.autor_id = a.id
JOIN comentarios c ON l.id = c.libro_id
WHERE l.id = 1;

-- 3) Verificación de libros de García Márquez
SELECT l.titulo, l.precio
FROM libros l
JOIN autores a ON l.autor_id = a.id
WHERE a.nombre = 'Gabriel García Márquez'
ORDER BY l.titulo;

-- 4) Verificación del conteo de comentarios
SELECT l.titulo, 
       COUNT(c.id) as total_comentarios,
       STRING_AGG(SUBSTRING(c.comentario, 1, 20), ', ') as muestra_comentarios
FROM libros l
LEFT JOIN comentarios c ON l.id = c.libro_id
GROUP BY l.titulo
ORDER BY total_comentarios DESC;

-- 5) Verificación de libros caros (>$15)
SELECT l.titulo, a.nombre as autor, l.precio
FROM libros l
JOIN autores a ON l.autor_id = a.id
WHERE l.precio > 15
ORDER BY l.precio DESC;

-- 6) Verificación del conteo de libros por autor
SELECT a.nombre, 
       COUNT(l.id) as total_libros,
       STRING_AGG(l.titulo, ', ') as titulos
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
GROUP BY a.nombre
ORDER BY total_libros DESC;

-- 7) Verificación de búsqueda de "Excelente"
SELECT l.titulo, 
       c.comentario,
       a.nombre as autor
FROM libros l
JOIN comentarios c ON l.id = c.libro_id
JOIN autores a ON l.autor_id = a.id
WHERE c.comentario ILIKE '%Excelente%';

-- 8) Verificación del autor con más libros
WITH AutoresLibros AS (
    SELECT a.nombre, 
           COUNT(l.id) as total_libros,
           STRING_AGG(l.titulo, ', ') as titulos
    FROM autores a
    LEFT JOIN libros l ON a.id = l.autor_id
    GROUP BY a.nombre
)
SELECT *
FROM AutoresLibros
WHERE total_libros = (SELECT MAX(total_libros) FROM AutoresLibros);

-- 9) Verificación del precio promedio
SELECT 
    MIN(precio) as precio_minimo,
    MAX(precio) as precio_maximo,
    AVG(precio) as precio_promedio,
    COUNT(*) as total_libros
FROM libros;

-- 10 y 11) Verificación de libros con y sin comentarios
SELECT l.titulo,
       CASE 
           WHEN COUNT(c.id) > 0 THEN 'Con comentarios'
           ELSE 'Sin comentarios'
       END as estado,
       COUNT(c.id) as num_comentarios
FROM libros l
LEFT JOIN comentarios c ON l.id = c.libro_id
GROUP BY l.titulo
ORDER BY num_comentarios DESC;

-- 12) Verificación detallada de comentarios por libro
SELECT l.titulo,
       COUNT(c.id) as total_comentarios,
       STRING_AGG(SUBSTRING(c.comentario, 1, 30), ' | ') as comentarios
FROM libros l
LEFT JOIN comentarios c ON l.id = c.libro_id
GROUP BY l.titulo
ORDER BY total_comentarios DESC;

-- 13) Verificación del orden alfabético
SELECT a.nombre as autor,
       STRING_AGG(l.titulo, ', ' ORDER BY l.titulo) as libros_ordenados
FROM autores a
JOIN libros l ON a.id = l.autor_id
GROUP BY a.nombre
ORDER BY a.nombre;

-- 14) Verificación de libros sobre el promedio
WITH EstadisticasPrecios AS (
    SELECT AVG(precio) as precio_promedio
    FROM libros
)
SELECT l.titulo,
       l.precio,
       (SELECT precio_promedio FROM EstadisticasPrecios) as precio_promedio
FROM libros l
WHERE l.precio > (SELECT precio_promedio FROM EstadisticasPrecios)
ORDER BY l.precio DESC;

-- 15) Verificación del libro más caro
WITH LibroMasCaro AS (
    SELECT MAX(precio) as max_precio
    FROM libros
)
SELECT a.nombre as autor,
       l.titulo,
       l.precio
FROM libros l
JOIN autores a ON l.autor_id = a.id
WHERE l.precio = (SELECT max_precio FROM LibroMasCaro);

-- 16) Verificación de orden por ID de comentarios
SELECT l.titulo,
       c.id as comentario_id,
       c.comentario,
       a.nombre as autor
FROM libros l
JOIN comentarios c ON l.id = c.libro_id
JOIN autores a ON l.autor_id = a.id
ORDER BY c.id DESC;

-- 17) Verificación de comentarios por autor
SELECT a.nombre,
       COUNT(c.id) as total_comentarios,
       STRING_AGG(DISTINCT l.titulo, ', ') as libros,
       STRING_AGG(SUBSTRING(c.comentario, 1, 30), ' | ') as muestra_comentarios
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
LEFT JOIN comentarios c ON l.id = c.libro_id
GROUP BY a.nombre
ORDER BY total_comentarios DESC;