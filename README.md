# Resumen general para levantar BD's
1. Descomprime en el Escritorio y entra a la carpeta con manage.py: cd "$HOME\Desktop\Backend EVA3"
2. Revisa Python 3.12+ (si falla, usa py): python --version
3. Pruebar red a Oracle (debe decir True): Test-NetConnection db.freesql.com -Port 1521
4. Crear entorno: python -m venv entorno
5. Habilitar scripts (debe verse (entorno)): Set-ExecutionPolicy -Scope Process RemoteSigned; entorno\Scripts\activate ó .\entorno\Scripts\Activate.ps1
6. Instala dependencias: pip install -r requirements.txt
7. Confirmar Django 5.2: python -m django --version
8. Prueba la conexión (debe decir 0 issues): python manage.py check --database negocio
9. Inspeccionar la base de datos: python manage.py inspectdb --database negocio clientes categorias productos ventas detalle_venta

# 1- Levantar el Backend

Descomprime en el Escritorio y entra a la carpeta con manage.py, luego cd BackendProyectoFinal (en caso de no estar en la carpeta)

PRUEBAS BASICAS (OPCIONAL)
Revisa Python 3.12+ (si falla, usa py): python --version
Pruebar red a Oracle (debe decir True): Test-NetConnection db.freesql.com -Port 1521

python -m venv entorno

entorno\Scripts\activate
	->(EN CASO DE QUE NO FUNCIONE, EJECUTAR: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned)

pip install -r requirements.txt

PRUEBAS DJANGO (OPCIONAL)
Confirmar Django 5.2: python -m django --version

python manage.py migrate
(migracion de modelo de datos para usuarios)

(COMPLETAR PASO 2 ANTES DE CONTINUAR)

python manage.py runserver



# 2- Crear el superusuario/token

python manage.py createsuperuser
	usuario: user
	password: 1234

python manage.py runserver

Para obtener el token:
POST http://127.0.0.1:8000/api/token/

Pestaña Body → Form → agregar dos campos:
username	:	user
password	:	1234

Pestaña Headers → agregar un campo:
Content-Type	:	application/x-www-form-urlencoded


# 3- Prueba de conexion establecida con la BD's

Probar la conexión (debe decir 0 issues)    : python manage.py check --database negocio
Inspeccionar la base de datos               : python manage.py inspectdb --database negocio cabanas detalle_servicio huespedes reservas servicios_extra