# Implementing Dockarized application on AWS with ECS and CI/CD Pipeline.

- [1. Preparing Sourcecode](#1-preparing-source-code)
- [2. Migration Roadmap](#2-migration-roadmap)
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

├── code                                // source code goes here, Django in this case
├── Dockerfile                          // Dockerfile to build docker image
├── buildspec.yml                       // Build specification for AWS CodeBuild
├── requirements.txt                    // dependency file for Django packages
├── docker-entrypoint.sh                // Entrypoint scripts for Data definitions, migrations, and Unit tests
└── READMEM.rst                          // Basic informatino

## Create necessary files and folders
```sh
mkdir code
touch Dockerfile buildspec.yml docker-entrypoint.sh
```
- Copy folder <https://github.com/nordcloud/notejam/tree/master/django/notejam> to code in target directory
- Copy <https://github.com/nordcloud/notejam/edit/master/django/README.rst> to README.rst
- Copy <https://github.com/nordcloud/notejam/edit/master/django/requirements.txt> to requirements.txt

## Dockerizing the application


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
### update Dockerfile with the below contents
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
