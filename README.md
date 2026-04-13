# CineVault

A premium full-stack Bollywood and South Indian Movie review & discovery platform built with React, Spring Boot, and PostgreSQL. 

The application utilizes native PostgreSQL capabilities including pure native functions, recursive CTE computations (for co-star graphs), and 7 business-logic triggers (controlling ratings, constraints, and dynamic fields autonomously).

## Architecture

*   **Frontend**: React + Vite + Tailwind CSS. Session tracked automatically via HTTP JWT Bearer interceptors & localStorage `UUID` for guest-persistence merging.
*   **Backend**: Java 17 + Spring Boot 3. Stateless session using JWTs, managed via Spring Security.
*   **Database**: PostgreSQL 15+. 17 tightly mapped logic tables enforcing strict constraints.
*   **Remote Data**: Powered by the TMDB API.

## Starting Instructions

### 1. Database Setup
1. Open pgAdmin or `psql` and create a blank database: `CREATE DATABASE cinevault;`
2. Run `backend/db/schema.sql` against the database to generate all tables and triggers.
3. Run `backend/db/views.sql` to generate all views and custom functions.

### 2. Environment Configurations
Please refer directly to `instruction.md` for detailed instructions on where to precisely put your TMDB API keys, database URL, and JWT passwords!

### 3. Backend Start
1. Ensure Java 17+ and Maven are installed.
2. From the `backend` folder, run `./mvnw spring-boot:run` or invoke it directly from your IDE.

### 4. Frontend Start
1. Ensure Node.js is installed.
2. From the `frontend` folder, run the following:
```bash
npm install
npm run dev
```
3. Open `http://localhost:5173` to view CineVault.
