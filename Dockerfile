FROM tomcat:jre25-temurin-noble

RUN mkdir /usr/local/tomcat/webapps/akusigmak

COPY . /usr/local/tomcat/webapps/akusigmak

EXPOSE 8080

