FROM python:3.9

ENV PYTHONUNBUFFERED=1


RUN apt-get update && apt-get install -y postgresql postgresql-contrib
RUN apt-get install -y nginx
RUN mkdir /testserver
WORKDIR /testserver
COPY . .
COPY nginx.conf /etc/nginx/conf.d/testserver.conf
RUN chmod +x entrypoint.sh
RUN pip install -r requirements.txt

RUN service postgresql start && \
    su - postgres -c "psql -c \"CREATE DATABASE db;\"" && \
    su - postgres -c "psql -c \"CREATE USER dbuser WITH PASSWORD 'dbpass';\"" && \
    su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE db TO dbuser;\""


EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]