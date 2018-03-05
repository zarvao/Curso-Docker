Hola,
en mi empresa http://www.maic.pro/ los programadores trabajan con un motor open-source de coldfusion llamado openbluedragon (http://openbd.org/), este ha de ser montado sobre un tomcat y usamos datasources hacia MySQL.

Mi miniproyecto hace lo siguiente:

Despliega un tomcat7 y un MySQL 5.5, en el tomcat introducimos en el volumen persistente el motor openbd junto con la condifuracion del datasource, esta imagen se ha subido al docker hub como dockerzar/appbd,
conectamos los dos contenedores renderizando una mini app en la ruta http://192.168.1.141:8080/openbd/

En el yml deberoa ademas intruducir un dump con los datos de la base datos, pero esto ha sido imposible y tenemos que intrducirla a mano con el siguiente comando:

cat data.sql | docker exec -i dbcontainer mysql -uroot -padmin db_data

Se supone y segun la ayuda que insertando la siguiente linea al yml lo deberia de hacer pero lo cierto es que no lo hace :( :

- ./data.sql:/docker-entrypoint-initdb.d/data.sql

Adjunto los siguiente ficheros:

--------------------------------------------------------------------------
1.- Dockerfile
--------------------------------------------------------------------------
FROM tomcat:7.0.85

#Descargamos el openbluedragon desde el repositorio oficial
ADD openbd /usr/local/tomcat/webapps/openbd/

VOLUME /usr/local/tomcat/webapps/

EXPOSE 8080

--------------------------------------------------------------------------
2.- docker-compose.yml
--------------------------------------------------------------------------
version: '2' #probe a poner 3.3 para importar el dump sql pero tampoco

services:
  db:
    image: mysql:5.5
    volumes:
      - dbdata:/var/lib/mysql
      - ./data.sql:/docker-entrypoint-initdb.d/data.sql
    restart: always
    container_name: dbcontainer
    environment:
      MYSQL_ROOT_PASSWORD: admin
      MYSQL_DATABASE: db_data
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin

  appbd:
    depends_on:
      - db
    image: dockerzar/appbd
    ports:
      - "8080:8080"
    restart: always
    volumes:
      - datos:/usr/local/tomcat/webapps/
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: admin

volumes:
  dbdata:
  datos:
--------------------------------------------------------------------------
3.- data.sql
--------------------------------------------------------------------------
Dump de todo el mysql a importar al arrancar el contenedor mysql
--------------------------------------------------------------------------
4.- captura_openbd.png
--------------------------------------------------------------------------
Imagen con lo que deberiamos ver al final del despliegue

POSIBLES MEJORAS:

1.- Que funcione la importacion de la base da datos
2.- Montar mas tomcat y ponerlos en alta disponibilidad con swarm
3.- Montar varios tomcat y una haproxy para balancear cargas

OBSERVACIONES:
Durante dias mis intenciones fueron hacer lo mismo con un Alfresco (https://www.alfresco.com/es/) pero no tuve manera que me funcionara el mysql-conector en el contendor tomcat, era lo que me interesaba ya que el proceso de instalarlo a mano lo tenia documentado para FreeBSD que es realmente lo que administro pero tampoco he tenido el tiempo suficiente.

CONCLUSIONES:
Me ha parecido muy interesante los despliegues que se pueden hacer y su facilidad para la alta disponibilidad.



