# Base python image
FROM python:3.12-slim-bookworm

# Setup the Working directory in the container
WORKDIR /app

# Copy files in the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code in the container
COPY . .

# Start producer along with the container
CMD ["python", "producer.py"]