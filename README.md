# Docker image for Liferay 6.2 and Postgres 
Originally forked from https://github.com/snasello/docker-liferay-6.2

The image is build in docker registry: https://hub.docker.com/r/masieroi/liferay/ 

Pull it using
```
docker pull masieroi/liferay
```

### Link with Database
In order to start the Liferay container you have to link with a Postgres container using the image https://hub.docker.com/r/masieroi/postgres/
For this reason we can isolate the data volume for the Postgres container using a light Busybox image https://hub.docker.com/_/busybox/

```
docker create -v /var/lib/postgresql/data --name liferay-postgres-data busybox
```

then start the Postgres container linking the data folder to the Busybox *liferay-postgres-data*

```
docker run -p 5432:5432 -e DB_NAME=lportal -e DB_USER=lportal -e DB_PASS=lportal -d --name protones-postgres --volumes-from liferay-postgres-data masieroi/postgres:9.3.5
```

Then start the Liferay coninter with a link to the database
```
docker run -d -p 8080:8080 -p 8000:8000 -p 1898:1898 --name protones-liferay --link protones-postgres:db_lep -v /Users/<path>:/var/liferay-home
```

We expose the port 8080 for Tomcat, 8000 and 1898 to enable the remote debug in Eclipse or IntelliJ (in this case we have to use the external host address and port 8000 to establish a propoer connection).
We also set a shared volume in order to persist some Liferay folders (i.e. data, deploy, logs) so you can put *wars* in the hot-deploy folder *deploy*.

If you want to attach to the container's terminal you can add *-it* to the run command.