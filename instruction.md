# Configuration & Environment Variables Guide

As requested, here is the dedicated guide on mapping your API keys and passwords.

## Backend (Spring Boot)
Open the file located at: `backend/src/main/resources/application.yml`

This file handles all your connection configurations. You need to replace the variables (or set them in your local environment variables mapping to the application run). 

### 1. Database Credentials
Locate the `datasource` block:
```yaml
url: ${DATABASE_URL:jdbc:postgresql://localhost:5432/cinevault}
username: ${DB_USER:postgres}
password: ${DB_PASSWORD:your_actual_db_password_here}
```
**Action**: Replace `postgres` and `your_actual_db_password_here` with your actual Postgres username and password.

### 2. JWT Secure Secrets
Locate the `app.jwt` block:
```yaml
access-secret: ${JWT_ACCESS_SECRET:YOUR_SECURE_256_BIT_SECRET_HERE}
refresh-secret: ${JWT_REFRESH_SECRET:YOUR_SECURE_256_BIT_REFRESH_SECRET_HERE}
```
**Action**: You MUST replace these defaults with long strings that are hard to guess. These strings are used to cryptographically secure the login tickets.

### 3. TMDB API Key (IMPORTANT)
Locate the `app.tmdb` block:
```yaml
api-key: ${TMDB_API_KEY:mock_key}
```
**Action**: Replace `mock_key` with the real API key you got from TMDB. When the Admin Dashboard clicks "Sync", the backend will use this key to hydrate the database!

## Frontend (React / Vite)
If you wish to change the local port the backend defaults to, or host the app, you will need a `.env` file in the frontend.
1. Navigate to the `frontend/` folder.
2. Create a file named `.env`
3. Add the following line:
```
VITE_API_URL=http://localhost:5000/api
```
*(If you run your Spring Boot app on port 8080, adjust this to `http://localhost:8080/api`)*