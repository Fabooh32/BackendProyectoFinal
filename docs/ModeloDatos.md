Modelo de Datos Proyecto Cabañas
    HUESPEDES ||--o{ RESERVAS : "realiza"
    CABANAS ||--o{ RESERVAS : "se reservada en (o con)"
    RESERVAS ||--o{ DETALLE_SERVICIO : "tienen un"
    SERVICIOS_EXTRA ||--o{ DETALLE_SERVICIO : "se contrata en"

    HUESPEDES {
        number id_huesped PK
        varchar2 documento UK "RUT o pasaporte"
        varchar2 nombre
        varchar2 email UK
        varchar2 telefono
        varchar2 pais
        timestamp fecha_registro
    }
    CABANAS {
        number id_cabana PK
        varchar2 codigo UK
        varchar2 nombre
        clob descripcion
        number capacidad
        number valor_noche
        number activa
    }
    SERVICIOS_EXTRA {
        number id_servicio PK
        varchar2 nombre UK
        varchar2 descripcion
        number precio
    }
    RESERVAS {
        number id_reserva PK
        number id_huesped FK
        number id_cabana FK
        date fecha_llegada
        date fecha_salida
        number n_personas
        number total
        varchar2 estado
        timestamp fecha_creacion
    }
    DETALLE_SERVICIO {
        number id_reserva PK, FK
        number id_servicio PK, FK
        number cantidad
        number precio_unitario
        number subtotal "VIRTUAL"
    }