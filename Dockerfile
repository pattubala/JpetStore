FROM tomcat:8.0.20-jre8
COPY target/jpetstore.war /usr/local/tomcat/webapps/jpetstore.war
