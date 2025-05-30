# MediGraph Project

## Overview
MediGraph is a medical knowledge graph that reveals hidden relationships between diseases, symptoms, drugs, and genetic factors. Built on Neo4j, it transforms scattered medical data into an interactive web of connected insights—helping doctors explore diagnoses, researchers uncover patterns, and patients understand conditions.

This project consists of two main parts:
- **Frontend:** A React-based web application for interacting with the knowledge graph.
- **Backend:** A FastAPI service that interfaces with the Neo4j database and serves data to the frontend.

---

## Frontend (medical-frontend)

### Description
The frontend is built with React using Create React App. It provides an interactive user interface to explore the medical knowledge graph.

### Setup and Installation

1. Navigate to the frontend directory:
   ```bash
   cd medical-frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Run the development server:
   ```bash
   npm start
   ```
   Open [http://localhost:3000](http://localhost:3000) in your browser to view the app.

### Available Scripts

- `npm start`: Runs the app in development mode.
- `npm test`: Launches the test runner.
- `npm run build`: Builds the app for production.
- `npm run eject`: Ejects the app configuration (one-way operation).

### Frontend Dependencies
Key dependencies include:
- react, react-dom
- react-router-dom
- react-force-graph-2d and 3d for graph visualization
- three.js for 3D rendering
- ESLint and Prettier for code quality and formatting

---

## Backend (MediGraph_backend)

### Description
The backend is a FastAPI application that connects to a Neo4j graph database. It exposes APIs to query and manipulate the medical knowledge graph.

### Setup and Installation

1. Navigate to the backend directory:
   ```bash
   cd MediGraph_backend
   ```

2. It is recommended to use a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/Scripts/activate   # On Windows
   # or
   source venv/bin/activate       # On Unix or MacOS
   ```

3. Install dependencies:
   ```bash
   pip install -r ../Requirements\ &\ Dependencies/requirements.txt
   ```

4. Run the FastAPI server:
   ```bash
   uvicorn main:app --reload
   ```
   The API will be available at [http://localhost:8000](http://localhost:8000).

### Backend Dependencies
Key dependencies include:
- fastapi for the web framework
- uvicorn as the ASGI server
- pydantic for data validation
- neo4j for database connectivity
- python-dotenv for environment variable management

---

## Requirements & Dependencies

- Frontend dependencies are listed in `Requirements & Dependencies/frontend-Depemdencies.txt`.
- Backend dependencies are listed in `Requirements & Dependencies/requirements.txt`.

---

## Usage

1. Start the Neo4j database and ensure it is accessible.
2. Run the backend FastAPI server.
3. Run the frontend React application.
4. Use the frontend UI to explore the medical knowledge graph.

---

## License

This project is licensed under the terms specified in the respective components.

---

## Contact

For questions or support, please contact the project maintainers.
