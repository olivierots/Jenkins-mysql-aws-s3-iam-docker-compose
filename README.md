=======
## Project description ##

```
The primary goal is to create a Jenkins job that will take a MySQL & upload that back to an AWS s3 bucket
Workflow: user --> Up/downaload an object --> internet --> Amazon s3
with only a click on jenkins, my job will execute the entire process workflow
The Jenkins Job will have the follwing 3 main parameters. MSQL host, Database name & the AWS bucket name.
```
```
## step by step technical procedure ##

* Build a MySQL image using docker & docker-compose
* installed aws-cli with all the relevant python/pip packages using the Dockerfile
* Created an S3 Bucket on AWS 
* Created a user (IAM=identity & access mngt)) for AWS authentication & give the user the correct access policy to access the bucket
* Automated the db backup and upload using a shell script 
* configured my aws & mysql credentials on Jenkins using secret text as this is sensitive info
* Created a freestyle project - Jenkins job (manually on the UI) which will upload the DB to AWS using parameters as defined in the sh
  script e.g MYSQL_HOST, DATABASE_NAME, AWS_BUCKET_NAME
* used the build env - "use secret text option" for our credentials in the Job
* added a build step which will ssh into the remote host & execute the script
* Persisted the script in the container using volumes in docker so that we dont lose it whenever the container is deleted
* Added parameters to re-use the Jenkins Job so that backups from different dbs can be taken and uploaded to different s3 buckets also
```
```
Below are some useful ommands i've used & learnt throughout my learning experience:

1. ## docker-compose commands ##
* docker-compose up -d ==> start the docker container in the background
* docker info | grep -i root ==> where docker is saving its files
* docker logs -f <container> ==> check your container's logs 
* docker-compose stop ==> stop the service
* docker-compose restart <container> ==> restart the container
* docker-compose down ==> delete the service but it wont delelte the volume
* docker-compose up -d  ==> the service will be re-created using files in the volume
* docker exec -ti <container> bash ==> ssh into the container/work inside the container
* docker cp script.sh <container>:/path/script.sh ==> copy the script file from your machine to container & specify the location
* docker-compose build ==> Under the project directory,  run docker-compose build to build (rebuild) the service.
* docker images ==> list your docker images
* docker cp remote-key <container>:/tmp/remote-key ==> copy keys to the container to allow passwordless ssh
* docker rm -fv <container-name> ==> delelte a container
* docker cp table.j2 web:/var/www/html/index.php ==> copy that file to the container
* docker ps ==> list your running containers
* docker-compose start <service> ==> starts an existing service container.
* docker-compose stop
* docker-compose pause <service> ==> pauses running containers of a service. They can be unpaused with docker-compose unpause
* docker-compose unpause
* docker-compose up: see all of the docker containers currently running
* docker-compose up: start the docker container
* docker-compose down: remove all docker containers in the repository
* docker kill :container_id ==> remove a specific docker container
* docker-compose config ==> verify that the Compose file format is correct. If it is correct, the configuration is displayed. If the 
  format is incorrect, the cause of the error is displayed.
* docker-compose port ==> prints the public port to which a container port is mapped.
* docker-compose version ==> prints the version of docker-compose.
* docker-compose top ==> view the processes running within each service container.
* docker-compose pull <service> ==> pulls an image associated with a service defined in a docker-compose.yml
* docker-compose restart <service> ==> restarts all stopped and running services.

2. ## MySQL commands ##
* mysql -u root -h <db_container_name> -p: connect to the db
* show databases;
* create database <database_name> : create a new db
* use <database>: go in your db
* create table <table_name> (name varchar(20), lastname varchar(20), age int(2)); ==> create a table inside a db
* show tables: show your tables
* desc <table_name>; ==> show your table structure
* insert into <table_name> values('olivier', 'otshudi', 30); ==> insert name, lastname & age in my table
* mysqldump -u root -h <target_host_for the db> -p <name_of_db_that_we+want_exported> > /tmp/db.sql: take a db backup & send to tmp dir

3. ## s3 bucket upload command ##
* aws s3 cp /tmp/db.sql s3://s3-bucket-url/db.sql (note you need to configure your aws credentials before using this)

```
