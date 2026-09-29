# Task Management Application

## Project Overview
This application is a simple full-stack task manager that allows users to keep track of their daily routines. Users can create, view, view by ID, edit, filter, and delete tasks dynamically using a local database.

## Technologies Used

### Frontend
- React
- Vite
- JavaScript
- CSS

### Backend
- Python
- FastAPI
- SQLAlchemy
- Pydantic

### Database
- SQLite

## Running the Backend

Follow these steps to launch the backend application server:

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create and activate the Python virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```
3. Install the required Python dependencies:
   ```bash
   pip install --no-cache-dir -r requirements.txt
   ```
4. Start the FastAPI application server:
   ```bash
   python main.py
   ```
5. The backend URL is: `http://localhost:8000`

## Running the Frontend

Follow these steps to start the frontend user interface:

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install the node package dependencies:
   ```bash
   npm install
   ```
3. Start the Vite development server:
   ```bash
   npm run dev
   ```
4. The frontend URL is: `http://localhost:3000`

## Database Setup
- **Database Engine:** The system uses SQLite.
- **File Storage Location:** Stored directly as a single file inside the backend directory at `backend/tasks.db`.
- **Initialization:** Database tables are initialized automatically at application startup inside `main.py` when the script runs `models.Base.metadata.create_all(bind=database.engine)`. No manual configuration is required.

## API Documentation

### GET /api/tasks
Returns a list of all existing tasks in the database. Returns a `200 OK` status code.

### GET /api/tasks/{id}
Retrieves a single task matching the specific database ID. Returns a `200 OK` status code if found, and a `404 Not Found` status code if the task identifier does not exist.

### POST /api/tasks
Creates a new task record. The request schema accepts `title`, `description`, and `status`. The database automatically creates the unique integer `id` and the `created_at` timestamp. Returns a `201 Created` status code.

### PUT /api/tasks/{id}
Updates the fields of an existing task matching the URL path ID. Accepts updates to `title`, `description`, and `status`. Returns a `200 OK` status code along with the updated task object, or a `404 Not Found` if the task does not exist.

### DELETE /api/tasks/{id}
Removes a specific task matching the ID from the database. Returns a `200 OK` status code upon successful removal, or a `404 Not Found` if the task is missing.

## Task Statuses
- `TODO`: Default state assigned to all fresh tasks.
- `IN_PROGRESS`: Assigned to tasks currently under active execution.
- `COMPLETED`: Terminal state that applies a visual text strikeout effect.

## Validation and Error Handling
- **Empty Titles:** Blocked on the frontend using layout attributes, and rejected on the backend by Pydantic schema rules enforcing a minimum length of 1 character.
- **Invalid Data & Statuses:** Payloads containing incorrect data types or statuses outside the valid options (`TODO`, `IN_PROGRESS`, `COMPLETED`) are rejected by the backend validation layer.
- **Missing Tasks:** Unknown IDs requested on `GET`, `PUT`, or `DELETE` endpoints return an explicit `404 Not Found` status code.
- **Backend/API Failures:** Wrapped in transactional catch blocks. If an execution route fails or the server goes offline, the frontend catches the error state and displays a message banner indicating the failure.

## Technical Decisions
- **FastAPI:** Selected because it handles automatic data validation out of the box and is fast to set up for simple REST endpoints.
- **SQLite:** Chosen because it stores records inside a single local file, eliminating the need to install or configure an external database server.
- **SQLAlchemy:** Used as the mapper layer to write standard Python class definitions for models rather than writing raw database queries by hand.
- **React Structure:** Separated into simple, modular components (`TaskForm`, `TaskList`, `TaskItem`, `TaskFilter`) to keep code clean and make layout debugging easier.
- **Task Filtering:** Filter queries are processed inside React state memory, sorting tasks into columns instantly without needing extra API data lookups.

## Challenges

### Challenge 1: Python 3.14 Dependency Build Failures
- **Problem:** When attempting to run the project environment on **Python 3.14**, installing older pinned package definitions caused `pip` to crash when compiling Pydantic, failing on an internal typing engine parameter mismatch.
- **Solution:** Shifting the baseline dependency restrictions inside `requirements.txt` to newer releases (`pydantic>=2.12.0` and `fastapi>=0.115.0`) fixed the issue by allowing the package manager to pull down pre-built, compatible wheels directly.

### Challenge 2: Component Communication and Prop Routing
- **Problem:** When trying to save edits or change task progress metrics on the frontend dashboard, the layout threw an `onUpdateTask is not a function` error code, and data updates failed to reflect on the UI.
- **Solution:** Tracing the data flow revealed that while `App.jsx` passed the task update handler down to the main list container, the intermediate `TaskList.jsx` file forgot to accept it as a property parameter, causing an undefined reference error when it reached `TaskItem.jsx`. Adding the property to the intermediate layout wrapper fixed the transmission pipeline.
