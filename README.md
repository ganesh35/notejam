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