# Airflow Docker Compose Setup

This repository contains a Docker Compose configuration for setting up Apache Airflow with Postgres as the metadata database and an additional operations database.

## Features
- Apache Airflow (version 2.10.3) with a **LocalExecutor**
- Postgres metadata database for Airflow
- Separate operations Postgres database with custom initialization scripts
- Healthcheck for Airflow webserver
- Volume mounts for DAGs and logs

## Requirements
- Docker
- Docker Compose

## Setup Instructions
1. Clone this repository:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. Start the Docker containers:
   ```bash
   docker-compose up -d
   ```

3. Access the Airflow webserver:
   Open a browser and navigate to [http://localhost:8080](http://localhost:8080). Use the following credentials to log in:
   - Username: `admin`
   - Password: `admin`

4. Add your DAGs:
   Place your DAG files in the `dags` directory (`/Users/rogoben/Downloads/basic-airflow/dags`).

5. View logs:
   Logs are available in the `logs` directory (`/Users/rogoben/Downloads/basic-airflow/logs`).

## Customization
- Update environment variables in the `docker-compose.yml` file for your specific use case.
- Modify the `operations-db-init` directory to include SQL scripts for initializing the operations database.

## Stop Services
To stop the containers:
```bash
docker-compose down
```

## TODO
Create a process to run the creat data warehouse scripts on snowflake

## Troubleshooting
- Ensure Docker and Docker Compose are installed and running.
- Check logs using:
  ```bash
  docker-compose logs
  ```

