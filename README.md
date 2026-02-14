# Ibarra Abastecida

Platform for GLP gas logistics.

## Project structure (monorepo)

- **`/backend`** – Backend API and services
- **`/admin-web`** – Admin web application
- **`/mobile`** – Mobile application

## Development environment

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose

### Start the environment

From the project root, run:

```bash
docker-compose up -d
```

This starts:

- **PostgreSQL + PostGIS** (`db`) on port `5432`
  - Database: `ibarra_db`
  - User: `postgres`
  - Password: `postgres`

To also start pgAdmin (optional) for viewing the database:

```bash
docker-compose --profile tools up -d
```

Then open pgAdmin at [http://localhost:5050](http://localhost:5050) (default: `admin@ibarra.local` / `admin`).

### Stop the environment

```bash
docker-compose down
```

Data is persisted in the `postgres_data` volume.
