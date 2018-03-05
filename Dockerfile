FROM tomcat:7.0.85

#Descargamos el openbluedragon desde el repositorio oficial
ADD openbd /usr/local/tomcat/webapps/openbd/

VOLUME /usr/local/tomcat/webapps/

EXPOSE 8080