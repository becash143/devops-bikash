### Used Commands ##
```docker build -t bikclu/my-application:200810-a47e8ce --build-arg CODE_VERSION=16 .```
```docker stack deploy --compose-file docker-compose-swarm.yml stackdemo```
```docker service scale stackdemo_web-service=3```
