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
python manage.py runserver 0.0.0.0:8000

