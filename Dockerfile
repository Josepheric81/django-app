# Use an official Python runtime
FROM python:3.12-slim

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Ensure Python output is sent straight to the terminal
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install operating system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file
COPY requirements.txt .

# Upgrade pip
RUN pip install --upgrade pip

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the application port
EXPOSE 8000

# Start the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]