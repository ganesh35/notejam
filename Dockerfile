FROM python:2.7

ENV VIRTUAL_ENV=/opt/venv
RUN virtualenv $VIRTUAL_ENV -p python2.7
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

#ENV PYTHONUNBUFFERED 1
#RUN virtualenv .venv -p python2.7
#RUN source .venv/bin/activate

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
