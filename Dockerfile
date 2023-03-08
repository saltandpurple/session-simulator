FROM python:3.9

WORKDIR /usr/src/app

COPY webserver.py .

CMD [ "python", "./webserver.py"]

EXPOSE 8080