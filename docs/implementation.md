# Implementing Dockarized application on AWS with ECS and CI/CD Pipeline.

- [1. Preparing Sourcecode](#1-preparing-source-code)
- [2. Dockerizing the application](#2-dockerizing-the-application)
- [3. Create Repository in ECR](#3-create-repository-in-ecr)
- [4. Create AWS ECS Cluster](#4-create-aws-ecs-cluster)
- [5. Create Task Definition](#5-create-task-definition)
- [3. Infrastructure](#3-infrastructure)
- [4. Outputs](#4-outputs)
    - [Solution Document](#solution-document)
    - [Artifacts](#artifacts)
    - [Working Solution](#working-solution)    
- [5. Challenges and Solutions](#5-challenges-and-solutions)    
- [6. Conclusion](#6-conclusion)
--------------------------------------------

## 1. Preparing Source code
Example Folder Structure for a Dockerized application:

Folder structure:
```bash
├── code                                # source code goes here, Django in this case
├── Dockerfile                          # Dockerfile to build docker image
├── buildspec.yml                       # Build specification for AWS CodeBuild
├── requirements.txt                    # dependency file for Django packages
├── docker-entrypoint.sh                # Entrypoint scripts for Data definitions, migrations, and Unit tests
└── READMEM.rst                         # Basic informatino
```

### Create necessary files and folders
```sh
mkdir code
touch Dockerfile buildspec.yml docker-entrypoint.sh
```
### Copy files
- Copy folder <https://github.com/nordcloud/notejam/tree/master/django/notejam> to code in target directory
- Copy <https://github.com/nordcloud/notejam/edit/master/django/README.rst> to README.rst
- Copy <https://github.com/nordcloud/notejam/edit/master/django/requirements.txt> to requirements.txt


### Create entrypoint file
File: docker-entrypoint.sh
```sh
#!/bin/bash
# Collect static files
echo "Collect static files"
python manage.py syncdb --noinput

# Apply database migrations
echo "Apply database migrations"
python manage.py migrate

# Running Tests
echo "Running Tests"
python manage.py test

# Start server
echo "Starting server"
python manage.py runserver 0.0.0.0:80
```

## 2. Dockerizing the application

### Update Dockerfile with the below contents
```dockerfile
#FROM python:2.7
FROM 619097795891.dkr.ecr.eu-central-1.amazonaws.com/python:2.7
ENV VIRTUAL_ENV=/opt/venv
RUN virtualenv $VIRTUAL_ENV -p python2.7
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
COPY ./code /code
RUN pip install -r requirements.txt
RUN pip install mysqlclient

ADD docker-entrypoint.sh /code/
RUN chmod +x /code/docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/code/docker-entrypoint.sh"]
```

### Build and Run Docker container
```sh
sudo docker build -t notejam-django-image .
sudo docker run --name notejam-running-app -p 80:80 notejam-django-image
```
### Step, Rebuild, Run container
```sh
sudo docker stop notejam-running-app; sudo docker rm notejam-running-app; sudo docker run -d --name notejam-running-app -p 80:80 notejam-django-image
```

- Create Git repository and push changes to it (or, clone repository from <https://github.com/ganesh35/notejam> )

----------------------------------
## 3. Create Repository in ECR
### Choose 'Create' from ECR 
Choose as Private repository and leave other fields to defaults.
![Choose 'Create' from ECR](imgs/03_ECR_01.png)
### Click 'create' to complete repository creation
![Choose 'Create' from ECR](imgs/03_ECR_02.png)
### Copy repository URI and save it for later use:
![Copy repository URI](imgs/03_ECR_03.jpg)

### Update contents of buildspec.yml with the new URI
```yml
version: 0.2

phases:
  pre_build:
    commands:
      - echo Loggin in to Amazon ECR...
      - aws --version
      - docker --version
      - aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 619097795891.dkr.ecr.eu-central-1.amazonaws.com
      # Replace repository URI
      - REPOSITORY_URI=619097795891.dkr.ecr.eu-central-1.amazonaws.com/notejam
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=build-$(echo $CODEBUILD_BUILD_ID | awk -F":" '{print $2}')
      - echo $COMMIT_HASH
      - echo $IMAGE_TAG
      - echo $REPOSITORY_URI
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Writing image definitions file...
      # Replace name as per ECR repository name
      - printf '[{"name":"notejam", "imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json   
      - cat imagedefinitions.json  
artifacts:
  files: 
    - imagedefinitions.json

```
----------------------------------
## 4. Create AWS ECS Cluster
Create  a Cluster with the below information:
### Choose 'Networking only' template
![Choose 'Networking only' template](imgs/04_Cluster_02.png)
### Provide 'Custer name' and click 'Create'
![Provide 'Custer name' and click 'Create'](imgs/04_Cluster_03.png)

----------------------------------
## 5. Create Task Definition
### Choose 'FARGATE' as launch type compatibility
![Choose 'FARGATE'](imgs/05_TaskDef_01.png)
### Provide a Task Definition name
![Task Definition name](imgs/05_TaskDef_02a.jpg)
### Provide a Task size 
![Task size](imgs/05_TaskDef_02b.jpg)
### Click on 'Add Container'
  - Provide a 'Container name'
  - Enter ECR Repository URI as Image 
  - add :latest at the end of the Image to make sure it picks up latest version
![Container](imgs/05_TaskDef_02ba.jpg)
![Container](imgs/05_TaskDef_02bb.jpg)
![Container](imgs/05_TaskDef_02bc.png)
Leave the rest fields as defaults and click 'Add' to complete.


















# notejam
Notejam application implemented using Django framework.  Django version: 1.6


******************************
Notejam: Django Dockerization
******************************

sudo docker build -t notejam-django-image .
sudo docker run --name notejam-running-app -p 80:80 notejam-django-image

restart:
sudo docker stop notejam-running-app; sudo docker rm notejam-running-app; sudo docker run -d --name notejam-running-app -p 80:80 notejam-django-image

sudo docker stop notejam-running-app; sudo docker rm notejam-running-app; sudo docker run -d --name notejam-running-app -p 80:80 notejam-django-image

sudo docker ps -aq; sudo docker stop $(sudo docker ps -aq); sudo docker rm $(sudo docker ps -aq); sudo docker rmi $(sudo docker images -q)
sudo docker exec -it notejam-running-app /bin/sh


# Amazon Container Services
- Create a Repository
- Create a Cluster
- Create Task Definitions
  - Add Container

- Create a Target Group
- Create a Load Balancer
- Create a Cluster Service

sudo aws configure
sudo aws ecr get-login-password --region eu-central-1 | sudo docker login --username AWS --password-stdin 619097795891.dkr.ecr.eu-central-1.amazonaws.com
sudo docker build -t notejam .
sudo docker tag notejam:latest 619097795891.dkr.ecr.eu-central-1.amazonaws.com/notejam:latest
sudo docker push 619097795891.dkr.ecr.eu-central-1.amazonaws.com/notejam:latest
