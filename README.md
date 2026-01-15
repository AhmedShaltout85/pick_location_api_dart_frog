# Pick Location API

A complete REST API built with Dart Frog and MS SQL Server, featuring JWT authentication and password encryption.

## Features

- JWT Authentication
- Password Encryption (SHA-256)
- MS SQL Server Database (using mssql_dart - pure Dart implementation)
- RESTful API Design
- Protected Routes
- Model-based Architecture

## Prerequisites

- Dart SDK (>=3.0.0)
- MS SQL Server
- dart_frog CLI

## Installation

### Step 1: Install ODBC Driver

This project uses `dart_odbc` to connect to SQL Server, which requires the ODBC driver to be installed on your system.

**⚠️ IMPORTANT**: Before proceeding, follow the detailed setup instructions in [SETUP_GUIDE.md](SETUP_GUIDE.md) to install:
- unixODBC (Linux/macOS)
- Microsoft ODBC Driver 17 for SQL Server

### Step 2: Install Dart Dependencies

1. Install dart_frog CLI:
```bash
dart pub global activate dart_frog_cli
```

2. Install project dependencies:
```bash
dart pub get
```

### Step 3: Configure Database Connection

3. Create `.env` file from `.env.example`:
```bash
cp .env.example .env
```

4. Configure your database credentials in `.env`:
```
DB_DSN=Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=your_database_name;UID=your_username;PWD=your_password;
JWT_SECRET=your_super_secret_jwt_key
JWT_EXPIRY_HOURS=24
```

**Note**: See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed connection string options and troubleshooting.

## Project Structure

```
pick_location_api/
├── lib/
│   ├── config/
│   │   ├── database.dart
│   │   └── jwt.dart
│   ├── middleware/
│   │   └── auth_middleware.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── location.dart
│   │   ├── handasah.dart
│   │   ├── tools_request.dart
│   │   └── tracking_location.dart
│   ├── repositories/
│   │   ├── user_repository.dart
│   │   └── location_repository.dart
│   └── utils/
│       └── password_helper.dart
├── routes/
│   ├── auth/
│   │   ├── login.dart
│   │   └── register.dart
│   ├── users/
│   │   ├── _middleware.dart
│   │   ├── index.dart
│   │   └── [id].dart
│   └── locations/
│       ├── _middleware.dart
│       ├── index.dart
│       └── [id].dart
├── .env.example
├── pubspec.yaml
└── README.md
```

## Running the API

Development mode:
```bash
dart_frog dev
```

Production mode:
```bash
dart_frog build
cd build
dart run bin/server.dart
```

The API will run on `http://localhost:8080`

## API Endpoints

### Authentication

#### Register
```
POST /auth/register
Content-Type: application/json

{
  "username": "john_doe",
  "password": "secure_password",
  "role": 1,
  "control_unit": "Unit A",
  "technical_id": 123
}
```

#### Login
```
POST /auth/login
Content-Type: application/json

{
  "username": "john_doe",
  "password": "secure_password"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "user_name": "john_doe",
    "role": 1,
    "control_unit": "Unit A",
    "technical_id": 123
  }
}
```

### Users (Protected Routes)

All user routes require JWT token in Authorization header:
```
Authorization: Bearer YOUR_JWT_TOKEN
```

#### Get All Users
```
GET /users
```

#### Get User by ID
```
GET /users/{id}
```

#### Update User
```
PUT /users/{id}
Content-Type: application/json

{
  "username": "john_doe_updated",
  "password": "new_password",
  "role": 2,
  "control_unit": "Unit B",
  "technical_id": 456
}
```

#### Delete User
```
DELETE /users/{id}
```

### Locations (Protected Routes)

#### Get All Locations
```
GET /locations

Optional query parameters:
- handasah_name: Filter by handasah name
- pending: Set to 'true' to get only unfinished locations

Examples:
GET /locations?handasah_name=Engineering
GET /locations?pending=true
```

#### Create Location
```
POST /locations
Content-Type: application/json

{
  "address": "123 Main St, Cairo",
  "latitude": "30.0444",
  "longitude": "31.2357",
  "date": "2025-01-15",
  "handasah_name": "Engineering",
  "technical_name": "John Doe",
  "caller_name": "Ahmed Ali",
  "broken_type": "Water leak",
  "caller_number": "01234567890",
  "is_finished": 0,
  "is_approved": 0
}
```

#### Get Location by ID
```
GET /locations/{id}
```

#### Update Location
```
PUT /locations/{id}
Content-Type: application/json

{
  "address": "123 Main St, Cairo",
  "latitude": "30.0444",
  "longitude": "31.2357",
  "handasah_name": "Engineering",
  "technical_name": "John Doe",
  "is_finished": 1,
  "is_approved": 1
}
```

#### Delete Location
```
DELETE /locations/{id}
```

## Security Features

### Password Encryption
All passwords are hashed using SHA-256 before storage. The `PasswordHelper` class provides:
- `hashPassword(String password)`: Hashes a plain text password
- `verifyPassword(String password, String hashedPassword)`: Verifies password against hash

### JWT Authentication
JWT tokens are used for authentication with the following features:
- Configurable expiry time (default: 24 hours)
- Secure secret key from environment variables
- Automatic token verification on protected routes

### Protected Routes
Routes under `/users` and `/locations` are automatically protected by the `auth_middleware`, which:
- Validates the JWT token
- Extracts user information
- Provides user context to route handlers

## Database Models

The API includes models for all your database tables:
- `User` - pick_location_users
- `Location` - Locations
- `PickLocationHandasah` - pick_location_handasah
- `HandasatTool` - handasat_tools
- `ToolsRequest` - tools_requests
- `TrackingLocation` - tracking_locations

## Error Handling

The API returns consistent error responses:

```json
{
  "error": "Error message description"
}
```

Common HTTP status codes:
- `200 OK` - Successful request
- `201 Created` - Resource created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Missing or invalid authentication
- `404 Not Found` - Resource not found
- `405 Method Not Allowed` - HTTP method not supported
- `409 Conflict` - Resource conflict (e.g., duplicate username)
- `500 Internal Server Error` - Server error

## Testing with cURL

### Register a new user:
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test_user","password":"test123","role":1}'
```

### Login:
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test_user","password":"test123"}'
```

### Get all locations (with token):
```bash
curl http://localhost:8080/locations \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Next Steps

To extend this API, you can:

1. Create repositories and routes for remaining tables:
   - `pick_location_handasah`
   - `handasat_tools`
   - `tools_requests`
   - `tracking_locations`
   - `hot_line_data`
   - `hot_line_status_data`

2. Add additional features:
   - Role-based access control
   - Refresh tokens
   - Input validation
   - Pagination
   - Search and filtering
   - File uploads
   - Logging

3. Implement business logic specific to your application

## License

MIT