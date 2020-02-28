# Ubuntu-VNC

Este repositorio contiene una imagen acoplable con entorno VNC que permite iniciar un contenedor de docker con una interfaz GUI.

---
<u><h2> Contenido</u></h2>
* Entorno de escritorio [**Xfce4**](http://www.xfce.org) o [**IceWM**](http://www.icewm.org/)
* VNC-Server (default VNC port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - cliente HTML5 VNC  (default http port `6901`)
* Navegadores:
  * Mozilla Firefox
  * Chromium
  
![Docker VNC Desktop access via HTML page](.pics/vnc_container_view.png)

---
<u><h2>Instalacion</u></h2>

- Imprima la página de ayuda:

      docker run andresdfx/ubuntu --help

- Ejecutar comando con asignación al puerto local `5901` (vnc protocol) y `6901` (acceso web vnc):

      docker run -d -p 5901:5901 -p 6901:6901 andresdfx/ubuntu
  
- Cambie el usuario y el grupo predeterminados dentro de un contenedor a los suyos agregando `--user $(id -u):$(id -g)`:

      docker run -d -p 5901:5901 -p 6901:6901 --user $(id -u):$(id -g) andresdfx/ubuntu

- Si desea ingresar al contenedor, use el modo interactivo `-it` y `bash`:
      
      docker run -it -p 5901:5901 -p 6901:6901 andresdfx/ubuntu bash

- Crea una imagen desde cero:

      docker build -t andresdfx/ubuntu ubuntu
---

<u><h2>Conexion y Control</u></h2>

Si el contenedor se inicia como se mencionó anteriormente, conéctese a través de una de estas opciones:

* conectar via __VNC viewer `localhost:5901`__, contraseña por defecto: `vncpassword`
* conectar via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `vncpassword` 
* conectar via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 

---
<u><h2>Consejos</u></h2>

### 1) Extienda una imagen con su propio software
Desde la versión `1.1.0` Todas las imágenes se ejecutan como usuario no root de forma predeterminada, por lo que si desea ampliar la imagen e instalar el software, debe volver al usuario `root`:

```bash
## Custom Dockerfile
FROM andresdfx/ubuntu
ENV REFRESHED_AT 2019-07-17

# Switch to root user to install additional software
USER 0

## Install a gedit
RUN yum install -y gedit \
    && yum clean all

## switch back to default user
USER 1000
```

### 2) Cambiar usuario de ejecutar Sakuli Container

Por defecto, desde la versión `1.3.0` Todos los procesos del contenedor se ejecutarán con la identificación de usuario `1000`. Puede cambiar la identificación de usuario de la siguiente manera:

#### 2.1) Usando root (user id `0`)
Agregue el indicador `--user` a su comando de ejecución de docker:

    docker run -it --user 0 -p 6911:6901 andresdfx/ubuntu

#### 2.2) Usar la identificación de usuario y grupo del sistema host
Agregue el indicador `--user` a su comando de ejecución de docker:

    docker run -it -p 6911:6901 --user $(id -u):$(id -g) andresdfx/ubuntu

### 3) Anular variables de entorno de VNC
Las siguientes variables de entorno VNC se pueden sobrescribir en el `docker run` fase para personalizar su entorno de escritorio dentro del contenedor:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1280x1024`
* `VNC_PW`, default: `my-pw`

#### 3.1) Ejemplo: sobreescribir la contraseña de VNC
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=my-pw andresdfx/ubuntu

#### 3.2) Ejemplo: sobreesvribir la resolucion de VNC

Simplemente sobrescriba el valor de la variable de entorno `VNC_RESOLUTION`. Por ejemplo en el comando docker run:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 andresdfx/ubuntu

### 4) Ver solamente por VNC

Desde la versión `1.2.0` Es posible evitar el control no deseado a través de VNC. Por lo tanto, puede establecer la variable de entorno `VNC_VIEW_ONLY=true`. 
Si se establece, el script de inicio creará una contraseña aleatoria para la conexión de control y usará el valor de `VNC_PW` para ver solo la conexión a través de la conexión VNC.

     docker run -it -p 5901:5901 -p 6901:6901 -e VNC_VIEW_ONLY=true andresdfx/ubuntu

