#!/bin/bash

# Запуск PostgreSQL
service postgresql start

# Ожидание доступности PostgreSQL
while ! pg_isready -q -h localhost -p 5432 -U dbuser
do
    sleep 1
done



# Предоставление прав доступа пользователю PostgreSQL
su - postgres -c "psql -c 'ALTER DATABASE db OWNER TO dbuser;'"
# su - postgres -c "psql -d db -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dbuser;'"
# su - postgres -c "psql -d db -c 'GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO dbuser;'"
# su - postgres -c "psql -d db -c 'GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO dbuser;'"
# su - postgres -c "psql -d db -c 'GRANT ALL PRIVILEGES ON SCHEMA public TO dbuser;'"

python manage.py migrate --noinput
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell

# Запуск Nginx и Gunicorn
service nginx start
gunicorn testdocker.wsgi:application --bind 0.0.0.0:8000