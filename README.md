# notejam
Notejam application implemented using Django framework.  Django version: 1.6




******************************
Notejam: Django Dockerization
******************************

sudo docker build -t notejam-django-image .
sudo docker run --name notejam-running-app -p 8000:8000 notejam-django-image

restart:
sudo docker stop notejam-running-app; sudo docker rm notejam-running-app; sudo docker run -d --name notejam-running-app -p 8000:8000 notejam-django-image

sudo docker ps -aq; sudo docker stop $(sudo docker ps -aq); sudo docker rm $(sudo docker ps -aq); sudo docker rmi $(sudo docker images -q)
sudo docker exec -it notejam-running-app /bin/sh


