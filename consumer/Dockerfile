# Python base image
FROM python:3.8-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy file in the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code in the container
COPY . .

# Start the consumer along with the container
CMD ["python", "consumer.py"]