
# PERN STORE

This is a complete e-commerce system built with the PERN Stack (PostgreSQL, Express, React, Node.js). 
However, the main focus of this repository is DevOps and Infrastructure. It demonstrates how to automate CI/CD pipelines, use Infrastructure as Code (IaC), and deploy applications across Multiple Clouds (GCP and Azure) using Kubernetes.

## Screenshots

![Homepage Screen Shot](https://user-images.githubusercontent.com/51405947/104136952-a3509100-5399-11eb-94a6-0f9b07fbf1a2.png)

## Database Schema

[![ERD](https://user-images.githubusercontent.com/51405947/133893279-8872c475-85ff-47c4-8ade-7d9ef9e5325a.png)](https://dbdiagram.io/d/5fe320fa9a6c525a03bc19db)

## Containerization

1. Multi-stage Builds: Rewrote the Dockerfile for both the frontend and backend using multi-stage builds. This separates the build environment from the runtime environment, greatly reducing the final image size.

2. Security Hardening: Followed the "Least Privilege" rule. Containers are configured to run as a non-root node user instead of root, making the application much more secure against attacks.

3. Environment Parity: Used docker-compose.yml for local development (with hot-reloading) and docker-compose.prod.yml to test production settings locally before deploying.

4. Makefile Automation: Created a Makefile to automate daily tasks. Developers can easily format code, run database migrations, build Docker images, and push them to Google Artifact Registry (GAR) or Azure Container Registry (ACR) using simple make commands.

## Database Migration

* Used the Supabase CLI to manage database changes.

* All database changes (tables, roles, security policies) are saved as SQL scripts in supabase/migrations. This acts as version control for the database, making it easy to track changes or roll back if something goes wrong.

## CI/CD

Built a fully automated CI/CD pipeline using GitHub Actions to ensure code quality before it goes to Production:

**CI Pipeline (Testing & Quality):**

1. Automatically formats code using Prettier.

2. Runs static code analysis (Linting).

3. Runs Unit Tests.

**CD Pipeline (Deployment):**

1. Automatically runs database migrations.

2. Builds Docker images and tags them with the Git Commit SHA.

3. Pushes images to private registries (GAR / ACR).

4. Triggers a Helm deployment to update the application on Google Kubernetes Engine (GKE) with zero downtime.


## Run Locally

Clone the project

```bash
  git clone https://github.com/dhatguy/PERN-Store.git
```

Go to the project directory

```bash
  cd PERN-Store
```

Install dependencies

```bash
  npm install
```

Go to server directory and install dependencies

```bash
  npm install
```

Go to client directory and install dependencies

```bash
  npm install
```

Go to server directory and start the server

```bash
  npm run dev
```

Go to client directory and start the client

```bash
  npm run client
```

Start both client and server concurrently from the root directory

```bash
  npm run dev
```

## Running with docker

Make sure you have Docker installed

### Run the development environment

```bash
docker-compose -f docker-compose.dev.yml up
```

### Run the production environment

```bash
docker-compose up
```

Go to http://localhost:3000 to view the app running on your browser.

## Deployment

To deploy this project run

```bash
  npm run deploy
```

Check this article for [guidance](https://dev.to/stlnick/how-to-deploy-a-full-stack-mern-app-with-heroku-netlify-ncb)
on how to deploy.

## Tech

- [React](https://reactjs.org/)
- [Node](https://nodejs.org/en/)
- [Express](http://expressjs.com/)
- [Postgres](https://www.postgresql.org/)
- [node-postgres](https://node-postgres.com/)
- [Windmill React UI](https://windmillui.com/react-ui)
- [Tailwind-CSS](https://tailwindcss.com/)
- [react-hot-toast](https://react-hot-toast.com/docs)
- [react-Spinners](https://www.npmjs.com/package/react-spinners)
- [react-helmet-async](https://www.npmjs.com/package/react-helmet-async)

## Environment Variables

To run this project, you will need to add the following environment variables to your .env files in both client and server directory

#### client/.env

`VITE_GOOGLE_CLIENT_ID`

`VITE_GOOGLE_CLIENT_SECRET`

`VITE_API_URL`

`VITE_STRIPE_PUB_KEY`

### server/.env

`POSTGRES_USER`

`POSTGRES_HOST`

`POSTGRES_PASSWORD`

`POSTGRES_DATABASE`

`POSTGRES_DATABASE_TEST`

`POSTGRES_PORT`

`PORT`

`SECRET`

`REFRESH_SECRET`

`SMTP_FROM`

`STRIPE_SECRET_KEY`

## Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Feedback

Joseph Odunsi - [@odunsi](https://twitter.com/_odunsi_) - odunsiolakunbi@gmail.com

Project Link: [https://github.com/dhatguy/PERN-Store](https://github.com/dhatguy/PERN-Store)

Demo Link: [https://pern-store.netlify.app](https://pern-store.netlify.app)
