# DevOps Team Assignment

## Compilation
To compile the code, run the following command:

```mvn clean package```

## Running the application
To run the application locally using mySql database, use the following:

```java -jar assignment-0.0.1-SNAPSHOT.jar```

This will run the application on port 8090. To change that, use the following:

```java -jar -Dserver.port=8070 assignment-0.0.1-SNAPSHOT.jar```

To use H2 embedded in memory database, please use the following command:

```java -jar -Dspring.profiles.active=h2 assignment-0.0.1-SNAPSHOT.jar```

```java -jar -Dserver.port=8070 -Dspring.profiles.active=h2 assignment-0.0.1-SNAPSHOT.jar```

## Changing database configuration
The default database connection information is as following:
database: assignment
username: root
password: P@ssw0rd

To change any of the previous ones you can change the following in the application.yaml:
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1/assignment?allowPublicKeyRetrieval=true
    username: root
    password: P@ssw0rd

or, you can pass them to the application using java properties style (-D):

```java -jar -Dserver.port=8070 -Dspring.datasource.username=newuser  -Dspring.datasource.password=newpassword assignment-0.0.1-SNAPSHOT.jar```

## Exposed end points
The application exposes the following endpoints:

### /persons
This end point follows standard REST convention, in which, you can do the following:

 |HTTP Verb|Endpoint URL|Action|
 |---------|------------|------|
 |POST|/persons/|Create new person|
 |PUT|/persons/:id|Update existing person|
 |DELETE|/persons/:id|Delete existing person|
 |GET|/persons/|List persons|
 |GET|/persons/:id|Get specific person|
 
 For the POST and PUT, you have to provide JSON payload (request body) in the following format:
 ```$xslt
{
    "name": "a name",
    "age": 23
```
Also, make sure to include the following HTTP header:
```$xslt
Content-Type: application/json
```

When creating a new person, the HTTP response will include "Location" header which indicate the ID of the newly create person. You can use this ID later to update, delete or retrieve that person.
The list persons endpoint take two optional parameter: page and size, so if you have too many persons, and you want to list them in pages, then use the following url:

```http://localhost:8090/persons/?page=0&size=10```

This will list the first 10 records from the database. The default value for page is 0 and for size is 10.

### /actuator
This endpoint provides some health checking capabilities include:

- /health: Return HTTP 200 with the the word "Up" in response if the application is up and running.
- /prometheus: provide prometheus endpoint in order to allow prometheus to monitor the application

