Diccionario de datos

Listado de las tablas con sus respectivos datos y

## huespedes
Persona que reserva: El documento es el RUT (chilenos) o el pasaporte (en caso de extranjeros)

|       Columna     |       Tipo Oracle     | ¿Nulo?    |           Restricción           |             Descripción             |
|-------------------|-----------------------|-----------|---------------------------------|-------------------------------------|
| `id_huesped`      | NUMBER(11) IDENTITY   | No        | `pk_huespedes` PK               | Identificador del huésped           |
| `documento`       | VARCHAR2(20)          | No        | `uq_huespedes_documento` UNIQUE | RUT o número de pasaporte           |
| `nombre`          | VARCHAR2(120)         | No        | —                               | Nombre completo                     |
| `email`           | VARCHAR2(100)         | No        | `uq_huespedes_email` UNIQUE     | Correo de contacto                  |
| `telefono`        | VARCHAR2(20)          | Sí        | —                               | Teléfono con código de país         |
| `pais`            | VARCHAR2(60)          | No        | —                               | País de origen                      |
| `fecha_registro`  | TIMESTAMP             | No        | DEFAULT hora UTC                | Cuándo se registró (la pone Oracle) |


## cabanas
Cabañas del complejo

| Columna       | Tipo Oracle           | ¿Nulo? |               Restricción                        |                     Descripción                       |
|---------------|-----------------------|--------|--------------------------------------------------|-------------------------------------------------------|
| `id_cabana`   | NUMBER(11) IDENTITY   | No     | `pk_cabanas` PK                                  | Identificador de la cabaña                            |
| `codigo`      | VARCHAR2(20)          | No     | `uq_cabanas_codigo` UNIQUE                       | Código interno (ej. `CAB-01`)                         |
| `nombre`      | VARCHAR2(100)         | No     | —                                                | Nombre comercial                                      |
| `descripcion` | CLOB                  | Sí     | —                                                | Descripción larga                                     |
| `capacidad`   | NUMBER(3)             | No     | `ck_cabanas_capacidad` CHECK `> 0`               | Máximo de personas (regla R2)                         |
| `valor_noche` | NUMBER(10,2)          | No     | `ck_cabanas_valor` CHECK `>= 0`                  | Tarifa por noche                                      |
| `activo`      | NUMBER(1)             | No     | `ck_cabanas_activo` CHECK `IN (0, 1)`, DEFAULT 1 | 1 = disponible para reservar, 0 = fuera de servicio   |


## servicios_extra
Servicios adicionales dentro de la reserva (tinaja, desayuno, leña para chimenea, etc)

|    Columna    |Tipo Oracle            | ¿Nulo? |              Restricción             |        Descripción            |
|---------------|-----------------------|--------|--------------------------------------|-------------------------------|
| `id_servicio` | NUMBER(11) IDENTITY   | No     | `pk_servicios_extra` PK              | Identificador del servicio    |
| `nombre`      | VARCHAR2(80)          | No     | `uq_servicios_nombre` UNIQUE         | Nombre del servicio           |
| `descripcion` | VARCHAR2(200)         | Sí     | —                                    | Qué incluye                   |
| `precio`      | NUMBER(10,2)          | No     | `ck_servicios_precio` CHECK `>= 0`   | Precio unitario vigente       |


## reservas (entidad principal)
Una estadía de un huésped en una cabaña

| Columna           | Tipo Oracle           |¿Nulo?|                      Restricción                             |                       Descripción                               |
|-------------------|-----------------------|------|--------------------------------------------------------------|-----------------------------------------------------------------|
| `id_reserva`      | NUMBER(11) IDENTITY   | No   | `pk_reservas` PK                                             | Identificador de la reserva                                     |
| `id_huesped`      | NUMBER(11)            | No   | `fk_reservas_huesped` FK → `huespedes`                       | Quién reserva                                                   |
| `id_cabana`       | NUMBER(11)            | No   | `fk_reservas_cabana` FK → `cabanas`                          | Cabaña reservada                                                |
| `fecha_llegada`   | DATE                  | No   | —                                                            | Día de llegada                                                  |
| `fecha_salida`    | DATE                  | No   | `ck_reservas_fechas` CHECK `fecha_salida >= fecha_llegada + 2`| Día de salida (mínimo 2 noches, regla R3)                      |
| `n_personas`      | NUMBER(3)             | No   | `ck_reservas_personas` CHECK `> 0`                           | Personas que se alojan (no debe superar la capacidad, R2)       |
| `total`           | NUMBER(12,2)          | No   | `ck_reservas_total` CHECK `>= 0`, DEFAULT 0                  | noches × `valor_noche` + servicios (R3). Lo calcula el caso de uso|
| `estado`          | VARCHAR2(10)          | No   | `ck_reservas_estado` CHECK `IN ('pendiente','confirmada',    |                                                                 |
|                   |                       |      |  'finalizada','cancelada')`, DEFAULT `'pendiente'`           | Estado de la reserva                                            |
| `fecha_creacion`  | TIMESTAMP             | No   | DEFAULT hora UTC                                             | Cuándo se creó (la pone Oracle)                                 |


## detalle_servicio (detalle, clave compuesta)
Servicios contratados dentro de una reserva

|       Columna     | Tipo Oracle  | ¿Nulo? |                                       Restricción                                              |               Descripción              |
|-------------------|--------------|--------|------------------------------------------------------------------------------------------------|----------------------------------------|
| `id_reserva`      | NUMBER(11)   | No     | `pk_detalle_servicio` PK (compuesta) · `fk_detalle_reserva` FK → `reservas` `ON DELETE CASCADE`| Reserva a la que pertenece la línea    |
| `id_servicio`     | NUMBER(11)   | No     | `pk_detalle_servicio` PK (compuesta) · `fk_detalle_servicio` FK → `servicios_extra`            | Servicio contratado                    |
| `cantidad`        | NUMBER(11)   | No     | `ck_detalle_cantidad` CHECK `> 0`                                                              | Unidades contratadas                   |
| `precio_unitario` | NUMBER(10,2) | No     | `ck_detalle_precio` CHECK `>= 0`                                                               | Precio al momento de reservar          |
|                   |              |        |                                                                                                | (copia de `servicios_extra.precio`)    |
| `subtotal`        | NUMBER(12,2) | —      | `GENERATED ALWAYS AS (cantidad * precio_unitario) VIRTUAL`                                     | Columna **virtual**: la calcula Oracle | 
|                   |              |        |                                                                                                | al leer                                |
