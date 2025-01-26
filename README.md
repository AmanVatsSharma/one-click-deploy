# One-Click Deploy E-Commerce Platform

This repository is designed for rapid deployment of an e-commerce platform with test data using "one-click deploy" features of cloud hosting providers.

## Key Features

- Modular architecture for scalability and maintainability.
- Supports server and worker processes for handling operations efficiently.
- Static files and assets are stored separately for better organization.
- Built-in support for plugins to extend functionality.
- Database migrations for safe and efficient schema updates.
- Docker and Docker Compose support for seamless containerized deployments.

## Directory Structure

- `/src` contains the source code of your server. All custom code and plugins should reside here.
- `/static` contains static (non-code) files such as assets (e.g., uploaded images) and email templates.

## Development

```bash
npm run dev
```

This command starts both the server and worker processes from the `src` directory for development.

## Build

```bash
npm run build
```

This command compiles the TypeScript sources into the `/dist` directory.

## Production

For production, there are multiple deployment options based on your operational requirements:

### Running Directly

Run the compiled files with the following command:

```bash
npm run start
```

Consider using a process manager like [pm2](https://pm2.keymetrics.io/) to manage the server and worker processes.

### Using Docker

A sample `Dockerfile` is included in this repository. Build and run the container as follows:

```bash
# Build the Docker image
docker build -t ecommerce-platform .

# Run the server
docker run -dp 3000:3000 -e "DB_HOST=host.docker.internal" --name server-instance ecommerce-platform npm run start:server

# Run the worker
docker run -dp 3001:3000 -e "DB_HOST=host.docker.internal" --name worker-instance ecommerce-platform npm run start:worker
```

### Docker Compose

A sample `docker-compose.yml` file is included to orchestrate the server, worker, and database using Docker Compose.

## Plugins

This platform allows custom functionality to be implemented using plugins. Custom plugins should be located in the `./src/plugins` directory.

## Migrations

Database migrations ensure safe updates to the database schema. Use the following command to generate migrations:

```bash
npx migrate
```

Generated migration files will be located in the `./src/migrations/` directory and should be committed to source control. Outstanding migrations will be applied automatically when the server starts.

For early-stage development, you can enable automatic schema synchronization by setting `dbConnectionOptions.synchronize` to `true`. However, this is not recommended for production environments with live data.

---

For more details, explore the source code and available configuration options.

