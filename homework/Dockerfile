FROM python:3.9.1

# Update package list and install wget in a single layer
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir pandas sqlalchemy psycopg2-binary pyarrow

# Set working directory
WORKDIR /app

# Copy files and folder into the container
COPY load_lookup_table.py .
COPY ny_taxi_postgres_data/ ny_taxi_postgres_data/

# Define entrypoint
ENTRYPOINT [ "python", "load_lookup_table.py" ]