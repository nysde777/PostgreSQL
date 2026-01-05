CREATE TABLE clientes(
	id INTEGER,
	nombre VARCHAR(100),
	email VARCHAR(150)
);

INSERT INTO clientes (id, nombre, email) VALUES 
(1, 'Juan Perez', 'juan@test.com'),
(2, 'Maria Gomez', 'maria@test.com');

SELECT * FROM clientes;

CREATE TABLE usuarios (
	id SERIAL PRIMARY KEY,
	nombre TEXT NOT NULL, 
	email TEXT UNIQUE NOT NULL
);

SELECT * FROM usuarios;

CREATE TABLE productos (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nombre TEXT NOT NULL
);

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    total NUMERIC(10,2) NOT NULL,
    usuario_id INT NOT NULL,
    CONSTRAINT fk_usuario
		FOREIGN KEY (usuario_id)
		REFERENCES usuarios(id)
);

SELECT * FROM pedidos;
-----------------------------------------
CREATE TABLE usuarios (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	email VARCHAR(150) UNIQUE NOT NULL,
	edad SMALLINT,
	creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

INSERT INTO usuarios
	(nombre, email, edad)
VALUES
	('Ana Lopez', 'ana2@yopmail.com', 35),
	('Carlos Ruiz', 'carlos@gmail.com', 20),
	('Pedro Sanchez', 'pedro@spain.com', 50)

SELECT *
FROM usuarios;

SELECT nombre, email
FROM usuarios;

SELECT *
FROM usuarios
WHERE edad > 25;

SELECT nombre, edad
FROM usuarios
ORDER BY edad DESC;

SELECT *
FROM usuarios
LIMIT 2;


UPDATE usuarios
SET email = 'ana.nuevo@gmail.com',
	edad = 29,
	nombre = 'Lizet Torres'
WHERE id = 3;

UPDATE usuarios
SET edad = edad + 1;

DELETE FROM usuarios
WHERE id = 3;

DELETE FROM usuarios
WHERE edad > 40;
------------------------------------------------
CREATE TABLE productos (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL, 
	precio NUMERIC(10,2) NOT NULL,
	categoria VARCHAR(50),
	sotck INTEGER DEFAULT 0
)

INSERT INTO productos (nombre, precio, categoria, sotck) VALUES
('laptop gamer', 1200.00, 'electronica', 15),
('mouse optico', 20.50, 'electronica', 150),
('camiseta de algodon', 18.90, 'ropa', 200),
('auriculares bloetooth', 89.99, 'electronica', 50),
('pantalones jeans', 45.00, 'ropa', 80);

SELECT *
FROM productos
WHERE categoria = 'electronica';

SELECT nombre, precio
FROM productos
WHERE precio > 50.00

SELECT *
FROM productos
WHERE categoria = 'ropa'
	AND precio > 20


SELECT *
FROM productos
WHERE categoria = 'electronica'
	OR precio >= 1000;


SELECT nombre, precio
FROM productos
ORDER BY precio DESC

SELECT nombre, categoria, precio
FROM productos
ORDER BY categoria ASC,
	precio DESC

SELECT nombre, precio
FROM productos
ORDER BY precio ASC
LIMIT 3

SELECT nombre, precio
FROM productos
ORDER BY precio ASC
LIMIT 3
OFFSET 3



SELECT
	nombre AS producto,
	precio AS costo, 
	sotck AS cantidad_en_stock
FROM productos
---------------------------------------------------------
CREATE TABLE ventas (
	id SERIAL PRIMARY KEY,
	producto_id INTEGER NOT NULL,
	cantidad INTEGER NOT NULL,
	fecha DATE DEFAULT CURRENT_DATE,
	total NUMERIC(10,2) NOT NULL
)

SELECT * FROM productos

INSERT INTO ventas (producto_id, cantidad, fecha, total) VALUES
(1, 2, '2026-01-20', 2400.00),
(2, 10, '2026-01-21', 255.00),
(3, 5, '2026-01-22', 94.00),
(1, 1, '2026-01-23', 1200.00),
(4, 3, '2026-01-24', 265.00),
(3, 8, '2026-01-25', 3000.00),
(1, 9, '2026-01-26', 151.00)

SELECT * FROM ventas


SELECT nombre, precio, categoria
FROM productos
WHERE precio >= 50.00
	AND categoria = 'electronica'
	OR nombre LIKE '%gamer%'

SELECT nombre, precio
FROM productos
WHERE precio BETWEEN 20.00 AND 100.00


SELECT nombre, categoria
FROM productos
WHERE categoria IN ('electronica')

SELECT nombre
FROM productos
WHERE nombre ILIKE 'a%'

SELECT COUNT(*) AS total_productos
FROM productos

SELECT COUNT(*) AS total_productos
FROM productos
WHERE categoria = 'ropa'

SELECT * FROM ventas

SELECT SUM(total) AS ingresos_totales
FROM ventas

SELECT AVG(precio) AS precio_promedio
FROM productos

SELECT 
	MIN(precio) AS precio_mas_bajo,
	MAX(precio) AS precio_mas_alto
FROM productos

SELECT 
	producto_id,
	COUNT(*) AS cantidad_ventas,
	SUM(cantidad) AS unidades_vendidas,
	SUM(total) AS ingresos_por_producto
FROM ventas
GROUP BY producto_id
ORDER BY ingresos_por_producto DESC


SELECT 
	producto_id,
	SUM(total) AS ingresos
FROM ventas
GROUP BY producto_id 
HAVING SUM(total) > 1000
ORDER BY ingresos DESC

SELECT DISTINCT categoria
FROM productos


SELECT nombre, precio
FROM productos
WHERE precio = (
	SELECT MAX(precio)
	FROM productos
)


SELECT nombre, precio, 
	CASE
		WHEN precio >= 1000 THEN 'Premium'
		WHEN precio >= 100 THEN 'Alto'
		WHEN precio >= 50 THEN 'Medio'
		ELSE 'Economico'
	END AS categoria_precio
FROM productos
ORDER BY precio DESC
------------------------------------------------------
CREATE TABLE personas (
	id SERIAL,
	nombre TEXT,
	edad INTEGER
)

INSERT INTO personas (nombre, edad) VALUES
('ana', 20),
('luis', 25),
('carlos', 30),
('maria', 35),
('pedro', 40),
('sofia', 45),
('juan', 50),
('lucia', 55),
('miguel', 60),
('elena', 65)

EXPLAIN ANALYZE
SELECT * FROM personas
WHERE edad = 40

CREATE INDEX 
idx_personas_edad
ON personas
(edad);

CREATE INDEX idx_personas_edad_hash
ON personas USING HASH (edad);
---------------------------------------------------
CREATE TABLE cuentas (
	id SERIAL PRIMARY KEY,
	nombre TEXT,
	saldo INTEGER
)

INSERT INTO cuentas (nombre, saldo)
VALUES ('Juan', 1000)

BEGIN;
UPDATE cuentas
SET saldo = saldo - 200
WHERE nombre = 'Juan';

COMMIT;

BEGIN;
UPDATE cuentas
SET saldo = saldo - 500
WHERE nombre = 'Juan'

SELECT * FROM cuentas;

ROLLBACK;

BEGIN;
UPDATE cuentas SET saldo = saldo - 200;

ROLLBACK;

ALTER TABLE cuentas
ADD CONSTRAINT saldo_no_negativo CHECK (saldo >= 0)

BEGIN;
UPDATE cuentas SET saldo = 500 WHERE nombre = 'Juan'

ROLLBACK;

BEGIN;
UPDATE cuentas SET saldo = saldo + 100 WHERE nombre = 'Juan'

SELECT * FROM cuentas;

COMMIT;
--------------------------------------------------------

CREATE OR REPLACE FUNCTION sumar_dos_numeros(numero1 INT, numero2 INT) RETURNS INT
AS $$
BEGIN
	RETURN numero1 + numero2;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION sumar_dos_numeros(integer,integer);

SELECT sumar_dos_numeros(5, 7);

CREATE OR REPLACE PROCEDURE mostrar_mensaje()
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE 'Hola este es un procedimiento';
END;
$$;

CALL mostrar_mensaje();



CREATE OR REPLACE FUNCTION verificar_numero( numero INT) RETURNS TEXT
AS $$
DECLARE 
	resultado TEXT;
BEGIN
	IF numero > 0 THEN
		resultado := 'EL numero es positivo';
	ELSIF numero < 0 THEN
		resultado := 'El numero es negativo';
	ELSE
		resultado := 'El numero es Cero';
	END IF;

	RETURN resultado;
END
$$ LANGUAGE plpgsql;



SELECT verificar_numero(0);

----------------------------------------------


















