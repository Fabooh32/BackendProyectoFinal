-- G08 · Cabanas «Bosque Nativo»
-- Datos de ejemplo realistas. Ejecutar DESPUES de 01_crear_tablas.sql.
-- Las claves foraneas se buscan por codigo/documento, asi el script no depende
-- de los numeros que genere IDENTITY.
-- Totales de las reservas = noches x valor_noche + servicios (regla R3).

-- Huespedes (4 chilenos con RUT y 2 extranjeros con pasaporte)
INSERT INTO huespedes (documento, nombre, email, telefono, pais)
VALUES ('15234567-4', 'María José Fuentes Araya', 'maria.fuentes@correo.cl', '+56912345601', 'Chile');
INSERT INTO huespedes (documento, nombre, email, telefono, pais)
VALUES ('16789012-1', 'Andrés Soto Pizarro', 'andres.soto@correo.cl', '+56923456702', 'Chile');
INSERT INTO huespedes (documento, nombre, email, telefono, pais)
VALUES ('17456321-7', 'Camila Rojas Valdés', 'camila.rojas@correo.cl', '+56934567803', 'Chile');
INSERT INTO huespedes (documento, nombre, email, telefono, pais)
VALUES ('18345678-4', 'Sebastián Muñoz Cárcamo', 'sebastian.munoz@correo.cl', NULL, 'Chile');
INSERT INTO huespedes (documento, nombre, email, telefono, pais)
VALUES ('AAB123456', 'Lucas Fernández Ibarra', 'lucas.fernandez@correo.com.ar', '+5491155550123', 'Argentina');
INSERT INTO huespedes (documento, nombre, email, telefono, pais)
VALUES ('C01X00T47', 'Hannah Becker', 'hannah.becker@beispiel.de', '+4915112345678', 'Alemania');

-- Cabanas (la Ulmo esta fuera de servicio: activo = 0)
INSERT INTO cabanas (codigo, nombre, descripcion, capacidad, valor_noche, activo)
VALUES ('CAB-01', 'Cabaña Coihue', 'Cabaña romántica para dos con vista al bosque y estufa a leña.', 2, 55000, 1);
INSERT INTO cabanas (codigo, nombre, descripcion, capacidad, valor_noche, activo)
VALUES ('CAB-02', 'Cabaña Lenga', 'Cabaña familiar con dos dormitorios, cocina equipada y terraza.', 4, 85000, 1);
INSERT INTO cabanas (codigo, nombre, descripcion, capacidad, valor_noche, activo)
VALUES ('CAB-03', 'Cabaña Alerce', 'Cabaña de tres dormitorios junto al estero, con quincho.', 6, 120000, 1);
INSERT INTO cabanas (codigo, nombre, descripcion, capacidad, valor_noche, activo)
VALUES ('CAB-04', 'Cabaña Canelo', 'Cabaña de dos dormitorios con loft y tinaja privada.', 4, 90000, 1);
INSERT INTO cabanas (codigo, nombre, descripcion, capacidad, valor_noche, activo)
VALUES ('CAB-05', 'Cabaña Araucaria', 'Cabaña grande para grupos, cuatro dormitorios y sala de estar.', 8, 150000, 1);
INSERT INTO cabanas (codigo, nombre, descripcion, capacidad, valor_noche, activo)
VALUES ('CAB-06', 'Cabaña Ulmo', 'Cabaña pequeña para dos, en mantención por reparación de techumbre.', 2, 60000, 0);

-- Servicios adicionales
INSERT INTO servicios_extra (nombre, descripcion, precio)
VALUES ('Tinaja caliente', 'Tinaja de madera con agua caliente a leña, por sesión de 2 horas.', 35000);
INSERT INTO servicios_extra (nombre, descripcion, precio)
VALUES ('Desayuno campesino', 'Pan amasado, mermeladas caseras, huevos de campo y café, por persona.', 9500);
INSERT INTO servicios_extra (nombre, descripcion, precio)
VALUES ('Leña (atado)', 'Atado de leña seca de roble para la estufa o la fogata.', 4500);
INSERT INTO servicios_extra (nombre, descripcion, precio)
VALUES ('Cena de campo', 'Cena de dos tiempos con productos locales, por persona.', 18000);
INSERT INTO servicios_extra (nombre, descripcion, precio)
VALUES ('Excursión guiada', 'Caminata guiada por el bosque nativo de 3 horas, por persona.', 15000);

-- Reservas: una por cada estado, y dos que se cruzan en la misma cabana
-- (la CAB-04 del 10 al 13 de diciembre esta cancelada, por eso la del 11 al 14 es valida: R1)
INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-09-18', DATE '2026-09-20', 2, 120000, 'finalizada'
FROM huespedes h, cabanas c WHERE h.documento = '18345678-4' AND c.codigo = 'CAB-06';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-10-09', DATE '2026-10-12', 3, 292500, 'finalizada'
FROM huespedes h, cabanas c WHERE h.documento = '15234567-4' AND c.codigo = 'CAB-02';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-11-20', DATE '2026-11-23', 5, 408500, 'confirmada'
FROM huespedes h, cabanas c WHERE h.documento = '16789012-1' AND c.codigo = 'CAB-03';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-12-05', DATE '2026-12-08', 2, 219000, 'pendiente'
FROM huespedes h, cabanas c WHERE h.documento = 'AAB123456' AND c.codigo = 'CAB-01';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-12-10', DATE '2026-12-13', 4, 270000, 'cancelada'
FROM huespedes h, cabanas c WHERE h.documento = '17456321-7' AND c.codigo = 'CAB-04';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-12-11', DATE '2026-12-14', 3, 298500, 'confirmada'
FROM huespedes h, cabanas c WHERE h.documento = '18345678-4' AND c.codigo = 'CAB-04';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-12-12', DATE '2026-12-15', 4, 255000, 'pendiente'
FROM huespedes h, cabanas c WHERE h.documento = '15234567-4' AND c.codigo = 'CAB-02';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-12-20', DATE '2026-12-22', 2, 249000, 'pendiente'
FROM huespedes h, cabanas c WHERE h.documento = '17456321-7' AND c.codigo = 'CAB-03';

INSERT INTO reservas (id_huesped, id_cabana, fecha_llegada, fecha_salida, n_personas, total, estado)
SELECT h.id_huesped, c.id_cabana, DATE '2026-12-26', DATE '2027-01-02', 6, 1210000, 'confirmada'
FROM huespedes h, cabanas c WHERE h.documento = 'C01X00T47' AND c.codigo = 'CAB-05';

-- Servicios contratados en cada reserva (el precio_unitario copia el precio vigente del servicio)
INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 2, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-10-09' AND s.nombre = 'Leña (atado)';
INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 3, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-10-09' AND s.nombre = 'Desayuno campesino';

INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 1, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-11-20' AND s.nombre = 'Tinaja caliente';
INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 3, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-11-20' AND s.nombre = 'Leña (atado)';

INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 2, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-12-05' AND s.nombre = 'Desayuno campesino';
INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 1, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-12-05' AND s.nombre = 'Tinaja caliente';

INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 3, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-12-11' AND s.nombre = 'Desayuno campesino';

INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 2, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-12-20' AND s.nombre = 'Leña (atado)';

INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 2, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-12-26' AND s.nombre = 'Tinaja caliente';
INSERT INTO detalle_servicio (id_reserva, id_servicio, cantidad, precio_unitario)
SELECT r.id_reserva, s.id_servicio, 6, s.precio
FROM reservas r, servicios_extra s
WHERE r.fecha_llegada = DATE '2026-12-26' AND s.nombre = 'Excursión guiada';

COMMIT;