FROM openjdk:11-jdk
MAINTAINER bikash.bhandari@clusus.com
ARG code_version
ENV code_version $code_version
ARG db_name
ENV db_name $db_name
RUN useradd -ms /bin/bash myapp
USER myapp
WORKDIR /usr/src/myapp
COPY /target/assignment-$code_version.jar /usr/src/myapp/
CMD java -jar -Dspring.profiles.active=$db_name assignment-$code_version.jar

