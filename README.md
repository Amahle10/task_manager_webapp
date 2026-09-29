# Task Management Application

## Project Overview
This application is a **full-stack task management application** designed to help users streamline their daily workflows and stay organized. 

Users can perform the following full CRUD operations:
- **Create new tasks** with custom titles, descriptive notes, and selectable execution states.
- **View all current tasks** inside an organized dashboard interface showing formatted dates.
- **Update existing records** by editing text contents or changing progress metrics via a dynamic dropdown interface.
- **Filter workflows** dynamically based on task progress states.
- **Permanently delete tasks** to clear them out of the tracking system entirely.

## Technologies Used
### Frontend
- React, Vite, JavaScript, CSS
### Backend
- Python, FastAPI, SQLAlchemy, Pydantic
### Database
- SQLite

## Running the Backend
1. Open a terminal and run: `cd backend`
2. Initialize environment: `python3 -m venv venv && source venv/bin/activate`
3. Install Python dependencies: `pip install --no-cache-dir -r requirements.txt`
4. Start FastAPI server: `python main.py`
5. Backend URL: `http://localhost:8000`

## Running the Frontend
1. Open a new terminal and run: `cd frontend`
2. Install dependencies: `npm install`
3. Start Vite web dashboard: `npm run dev`
4. Frontend URL: `http://localhost:3000`

## Database Setup
- **Database Engine:** SQLite serverless storage.
- **File Storage Location:** Stored directly under `backend/tasks.db`.
- **Initialization Workflow:** Initialized programmatically at runtime via SQLAlchemy metadata calls automatically.
- **Manual Configuration:** No manual configuration or migration engine required.

## API Documentation
- `GET /api/tasks`: Returns a list of all current task objects.
- `GET /api/tasks/{id}`: Returns a single task record or 404 error if non-existent.
- `POST /api/tasks`: Creates a task record from incoming body parameters.
- `PUT /api/tasks/{id}`: Modifies task parameters during open database contexts.
- `DELETE /api/tasks/{id}`: Clears a task by ID, returning a 204 confirmation status.

## Task Statuses
- `TODO`, `IN_PROGRESS`, `COMPLETED`

## Validation and Error Handling
- **Empty Titles:** Enforced by frontend space `.trim()` parsing configurations and backend Pydantic `min_length=1` field filters.
- **Invalid Task Data:** Blocked via Pydantic validator structures returning a detailed `422 Unprocessable Entity` response.
- **Missing Tasks:** Intercepted by explicit service index checks executing clean `404 Not Found` messages.
- **Backend/API Failures:** Caught using comprehensive db transactional `try-except` wrappers to manage server infrastructure protection.

## Technical Decisions
- **FastAPI / SQLite / SQLAlchemy:** Selected for async compatibility, immediate system data portability, and high developer loop execution velocity.
- **React Components / Filtering:** Separated into clear component files for modular structural management while computing sorting queries dynamically via state.

## Challenges
- **Challenge 1:** Python 3.14 compatibility wheel limitations with older Pydantic versions resolved by shifting dependencies to current updates (`pydantic>=2.12.0`).
- **Challenge 2:** Frontend execution network communication bugs resolved by updating target configuration paths explicitly to `http://localhost:8000`.
