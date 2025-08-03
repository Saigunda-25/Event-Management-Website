FROM tomcat:9.0-jdk17

#Remove default Root app(optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

#Copy your war as ROOT.war so it serves as "/"
COPY EventManagementWebsite.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh","run"]
