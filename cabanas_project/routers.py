"""
ROUTER DE lAS BASES DE DATOS
--------------------------
El proyecto usa DOS bases (ver DATABASES en settings.py):
"default" -> SQLite local (db.sqlite3): las tablas internas de Django
(usuarios, tokens, sesiones, admin, migraciones). 


"negocio" -> Oracle (tu esquema en FreeSQL): SOLO las tablas del negocio
(cabanas detalle_servicio huespedes reservas servicios_extra).

Este router manda los modelos de la app "cabanas" a Oracle y todo lo
demas a SQLite. Ademas impide que las migraciones creen o modifiquen
tablas en Oracle: 
"""
APPS_NEGOCIO = {"cabanas"}

class NegocioRouter:
    
    def db_for_read(self, model, **hints):
        return "negocio" if model._meta.app_label in APPS_NEGOCIO else "default"
    
    def db_for_write(self, model, **hints):
        return "negocio" if model._meta.app_label in APPS_NEGOCIO else "default"
    
    def allow_relation(self, obj1, obj2, **hints):
        # Solo se relacionan modelos que viven en la misma base
        return self.db_for_read(type(obj1)) == self.db_for_read(type(obj2))
    
    def allow_migrate(self, db, app_label, model_name=None, **hints):
    # Nada se migra en Oracle. En SQLite van las tablas de Django; los
    # modelos de negocio no, porque sus tablas ya estan en tu esquema.
        if db == "negocio":
            return False
        return app_label not in APPS_NEGOCIO
