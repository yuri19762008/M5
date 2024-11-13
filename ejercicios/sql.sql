-- 1) Obtener todos los libros con sus respectivos autores
SELECT l.titulo, a.nombre as autor
FROM libros l
JOIN autores a ON l.autor_id = a.id;

-- 2) Obtener todos los comentarios de un libro específico con nombre del libro y autor
SELECT l.titulo, a.nombre as autor, c.comentario
FROM libros l
JOIN autores a ON l.autor_id = a.id
JOIN comentarios c ON l.id = c.libro_id
WHERE l.id = 1;

-- 3) Obtener todos los libros escritos por Gabriel García Márquez
SELECT l.titulo
FROM libros l
JOIN autores a ON l.autor_id = a.id
WHERE a.nombre = 'Gabriel García Márquez';

-- 4) Obtener el número total de comentarios por libro
SELECT l.titulo, COUNT(c.id) as total_comentarios
FROM libros l
LEFT JOIN comentarios c ON l.id = c.libro_id
GROUP BY l.titulo;

-- 5) Obtener los libros y autores con precio mayor a $15
SELECT l.titulo, a.nombre as autor, l.precio
FROM libros l
JOIN autores a ON l.autor_id = a.id
WHERE l.precio > 15;

-- 6) Obtener los autores y la cantidad de libros que han escrito
SELECT a.nombre, COUNT(l.id) as total_libros
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
GROUP BY a.nombre;

-- 7) Obtener los libros y comentarios que contienen la palabra "Excelente"
SELECT l.titulo, c.comentario
FROM libros l
JOIN comentarios c ON l.id = c.libro_id
WHERE c.comentario ILIKE '%Excelente%';

-- 8) Obtener el autor con la mayor cantidad de libros
SELECT a.nombre, COUNT(l.id) as total_libros
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
GROUP BY a.nombre
ORDER BY total_libros DESC
LIMIT 1;

-- 9) Obtener el precio promedio de los libros
SELECT AVG(precio) as precio_promedio
FROM libros;

-- 10) Obtener los libros que tienen comentarios asociados
SELECT DISTINCT l.titulo
FROM libros l
JOIN comentarios c ON l.id = c.libro_id;

-- 11) Obtener los libros que NO tienen comentarios asociados
SELECT l.titulo
FROM libros l
LEFT JOIN comentarios c ON l.id = c.libro_id
WHERE c.id IS NULL;

-- 12) Obtener los libros y la cantidad de comentarios que tienen
SELECT l.titulo, COUNT(c.id) as total_comentarios
FROM libros l
LEFT JOIN comentarios c ON l.id = c.libro_id
GROUP BY l.titulo;

-- 13) Obtener los autores y sus libros ordenados alfabéticamente por título
SELECT a.nombre, l.titulo
FROM autores a
JOIN libros l ON a.id = l.autor_id
ORDER BY l.titulo;

-- 14) Obtener los libros con precio superior al promedio
SELECT titulo, precio
FROM libros
WHERE precio > (SELECT AVG(precio) FROM libros);

-- 15) Obtener el autor con el libro más caro
SELECT a.nombre, l.titulo, l.precio
FROM autores a
JOIN libros l ON a.id = l.autor_id
WHERE l.precio = (SELECT MAX(precio) FROM libros);

-- 16) Obtener los libros y sus comentarios ordenados por fecha
-- Nota: Como la tabla comentarios no tiene campo de fecha, 
-- esta consulta usaría ORDER BY c.id DESC asumiendo que el id es secuencial
SELECT l.titulo, c.comentario
FROM libros l
JOIN comentarios c ON l.id = c.libro_id
ORDER BY c.id DESC;

-- 17) Obtener los autores y la cantidad total de comentarios en sus libros
SELECT a.nombre, COUNT(c.id) as total_comentarios
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
LEFT JOIN comentarios c ON l.id = c.libro_id
GROUP BY a.nombre;