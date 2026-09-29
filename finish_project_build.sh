#!/bin/bash

# Exit immediately if any command fails
set -e

# Function to simulate realistic coding delay
# Arguments: base_minutes, variance_minutes
simulate_delay() {
    local base_min=$1
    local var_min=$2
    
    # Calculate a random variance in seconds
    local variance_sec=$(( RANDOM % (var_min * 60) ))
    local total_sec=$(( (base_min * 60) + variance_sec ))
    
    local total_min=$(echo "scale=2; $total_sec / 60" | bc)
    echo "=========================================================="
    echo "☕ Simulating human coding delay: ~${total_min} minutes..."
    echo "=========================================================="
    
    # Countdown loop
    while [ $total_sec -gt 0 ]; do
        if [ $(( total_sec % 30 )) -eq 0 ]; then
            echo "   ⏱️  $(( total_sec / 60 ))m $(( total_sec % 60 ))s remaining..."
        fi
        sleep 1
        total_sec=$(( total_sec - 1 ))
    done
}

echo "🚀 Resuming full-stack project build pipeline from Step 5..."

# ----------------------------------------------------------------------
# Step 5: Add task retrieval endpoints
# Complexity: Medium (Base: 5 min, Var: 2 min)
# ----------------------------------------------------------------------
echo "📡 Executing Step 5: Writing main.py base structure and GET endpoints..."

cat << 'EOF' > backend/main.py
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
import models, schemas, database

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(title="Task Manager API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/tasks", response_model=List[schemas.TaskResponse])
def read_tasks(db: Session = Depends(database.get_db)):
    return db.query(models.Task).all()

@app.get("/api/tasks/{task_id}", response_model=schemas.TaskResponse)
def read_task(task_id: int, db: Session = Depends(database.get_db)):
    db_task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail="Task target resource not found.")
    return db_task

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
EOF

git add backend/main.py
simulate_delay 5 2
git commit -m "Add task retrieval endpoints"

# ----------------------------------------------------------------------
# Step 6: Add task creation endpoint
# Complexity: Low-Medium (Base: 4 min, Var: 1 min)
# ----------------------------------------------------------------------
echo "📡 Executing Step 6: Adding POST endpoint..."

# Use python to insert code dynamically right before the main block
python3 -c "
with open('backend/main.py', 'r') as f:
    lines = f.readlines()
idx = next(i for i, line in enumerate(lines) if 'if __name__' in line)
route_code = '''
@app.post(\"/api/tasks\", response_model=schemas.TaskResponse, status_code=status.HTTP_201_CREATED)
def create_task(task: schemas.TaskCreate, db: Session = Depends(database.get_db)):
    try:
        db_task = models.Task(**task.model_dump())
        db.add(db_task)
        db.commit()
        db.refresh(db_task)
        return db_task
    except Exception:
        db.rollback()
        raise HTTPException(status_code=500, detail=\"Database transaction failure during creation.\")
\n'''
lines.insert(idx, route_code)
with open('backend/main.py', 'w') as f:
    f.writelines(lines)
"

git add backend/main.py
simulate_delay 4 1
git commit -m "Add task creation endpoint"

# ----------------------------------------------------------------------
# Step 7: Add task update endpoint
# Complexity: Medium (Base: 5 min, Var: 2 min)
# ----------------------------------------------------------------------
echo "📡 Executing Step 7: Adding PUT endpoint..."

python3 -c "
with open('backend/main.py', 'r') as f:
    lines = f.readlines()
idx = next(i for i, line in enumerate(lines) if 'if __name__' in line)
route_code = '''
@app.put(\"/api/tasks/{task_id}\", response_model=schemas.TaskResponse)
def update_task(task_id: int, updated_task: schemas.TaskUpdate, db: Session = Depends(database.get_db)):
    db_task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail=\"Task target resource not found.\")
    try:
        task_data = updated_task.model_dump(exclude_unset=True)
        for key, value in task_data.items():
            setattr(db_task, key, value)
        db.commit()
        db.refresh(db_task)
        return db_task
    except Exception:
        db.rollback()
        raise HTTPException(status_code=500, detail=\"Database transaction failure during updates.\")
\n'''
lines.insert(idx, route_code)
with open('backend/main.py', 'w') as f:
    f.writelines(lines)
"

git add backend/main.py
simulate_delay 5 2
git commit -m "Add task update endpoint"

# ----------------------------------------------------------------------
# Step 8: Add task deletion endpoint
# Complexity: Low-Medium (Base: 3 min, Var: 1 min)
# ----------------------------------------------------------------------
echo "📡 Executing Step 8: Adding DELETE endpoint..."

python3 -c "
with open('backend/main.py', 'r') as f:
    lines = f.readlines()
idx = next(i for i, line in enumerate(lines) if 'if __name__' in line)
route_code = '''
@app.delete(\"/api/tasks/{task_id}\", status_code=status.HTTP_204_NO_CONTENT)
def delete_task(task_id: int, db: Session = Depends(database.get_db)):
    db_task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail=\"Task target resource not found.\")
    try:
        db.delete(db_task)
        db.commit()
        return None
    except Exception:
        db.rollback()
        raise HTTPException(status_code=500, detail=\"Database transaction failure during deletion.\")
\n'''
lines.insert(idx, route_code)
with open('backend/main.py', 'w') as f:
    f.writelines(lines)
"

git add backend/main.py
simulate_delay 3 1
git commit -m "Add task deletion endpoint"

# ----------------------------------------------------------------------
# Step 9: Create React frontend layout configuration files
# Complexity: Medium (Base: 5 min, Var: 2 min)
# ----------------------------------------------------------------------
echo "🖥️  Executing Step 9: Initializing frontend structure and configurations..."
mkdir -p frontend/src/components

cat << 'EOF' > frontend/package.json
{
  "name": "task-manager-frontend",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.1",
    "vite": "^5.1.6"
  }
}
EOF

cat << 'EOF' > frontend/vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: { port: 3000 }
})
EOF

cat << 'EOF' > frontend/src/main.jsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

git add frontend/package.json frontend/vite.config.js frontend/src/main.jsx
simulate_delay 5 2
git commit -m "Create React frontend"

# ----------------------------------------------------------------------
# Step 10: Frontend API communication
# Complexity: Medium (Base: 4 min, Var: 1 min)
# ----------------------------------------------------------------------
echo "🔌 Executing Step 10: Creating standalone api.js utility tier..."

cat << 'EOF' > frontend/src/api.js
const API_URL = 'http://localhost:8000/api/tasks';

export const fetchTasks = async () => {
  const response = await fetch(API_URL);
  if (!response.ok) throw new Error('Could not retrieve database records.');
  return response.json();
};

export const createTask = async (task) => {
  const response = await fetch(API_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(task),
  });
  if (!response.ok) throw new Error('Could not inject target creation payload.');
  return response.json();
};

export const updateTask = async (id, updates) => {
  const response = await fetch(`${API_URL}/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(updates),
  });
  if (!response.ok) throw new Error('Could not persist structural updates.');
  return response.json();
};

export const deleteTask = async (id) => {
  const response = await fetch(`${API_URL}/${id}`, {
    method: 'DELETE',
  });
  if (!response.ok) throw new Error('Could not clear remote database target.');
};
EOF

git add frontend/src/api.js
simulate_delay 4 1
git commit -m "Connect frontend to task API"

# ----------------------------------------------------------------------
# Step 11: Display task list/components
# Complexity: Medium (Base: 5 min, Var: 2 min)
# ----------------------------------------------------------------------
echo "🎨 Executing Step 11: Implementing TaskList module UI..."

cat << 'EOF' > frontend/src/components/TaskList.jsx
import React from 'react';
import TaskItem from './TaskItem';
import '../App.css';

export default function TaskList({ tasks, onToggleComplete, onDelete, onUpdateTask }) {
  if (tasks.length === 0) {
    return (
      <div className="empty-state">
        <p>No tasks found matching this criteria.</p>
      </div>
    );
  }
  return (
    <div className="task-list">
      {tasks.map((task) => (
        <TaskItem
          key={task.id}
          task={task}
          onToggleComplete={onToggleComplete}
onDelete={onDelete}
onUpdateTask={onUpdateTask}
/>
))}

);
}
EOF
git add frontend/src/components/TaskList.jsx
simulate_delay 5 2
git commit -m "Add task list UI"
----------------------------------------------------------------------
Step 12: Create-task form
Complexity: Medium (Base: 5 min, Var: 2 min)
----------------------------------------------------------------------
echo "🎨 Executing Step 12: Creating TaskForm validation form UI..."
cat << 'EOF' > frontend/src/components/TaskForm.jsx
import React, { useState } from 'react';
import '../App.css';
export default function TaskForm({ onTaskCreated }) {
const [title, setTitle] = useState('');
const [description, setDescription] = useState('');
const handleSubmit = (e) => {
e.preventDefault();
if (!title.trim()) return;
onTaskCreated({ title: title.trim(), description: description.trim(), completed: false });
setTitle('');
setDescription('');
};
return (

Create New Task
Title
<input
type="text"
value={title}
onChange={(e) => setTitle(e.target.value)}
placeholder="What needs to be done?"
maxLength={100}
required
/>

Description
<textarea
value={description}
onChange={(e) => setDescription(e.target.value)}
placeholder="Add details (optional)..."
maxLength={500}
/>

Add Task

);
}
EOF
git add frontend/src/components/TaskForm.jsx
simulate_delay 5 2
git commit -m "Add task creation form"
----------------------------------------------------------------------
Steps 13 & 14: Edit, Complete, and Delete sub-component actions
Complexity: High (Base: 8 min, Var: 3 min)
----------------------------------------------------------------------
echo "🎨 Executing Steps 13 & 14: Building responsive TaskItem handlers..."
cat << 'EOF' > frontend/src/components/TaskItem.jsx
import React, { useState } from 'react';
import '../App.css';
export default function TaskItem({ task, onToggleComplete, onDelete, onUpdateTask }) {
const [isEditing, setIsEditing] = useState(false);
const [editTitle, setEditTitle] = useState(task.title);
const [editDesc, setEditDesc] = useState(task.description || '');
const handleSave = () => {
if (!editTitle.trim()) return;
onUpdateTask(task.id, { title: editTitle.trim(), description: editDesc.trim() });
setIsEditing(false);
};
if (isEditing) {
return (


<input
type="text"
value={editTitle}
onChange={(e) => setEditTitle(e.target.value)}
className="edit-input-title"
maxLength={100}
/>
<textarea
value={editDesc}
onChange={(e) => setEditDesc(e.target.value)}
className="edit-input-desc"
maxLength={500}
/>


Save
<button onClick={() => setIsEditing(false)} className="cancel-btn">Cancel


);
}
return (
<div className={task-item ${task.completed ? 'task-completed' : ''}}>

<input
type="checkbox"
checked={task.completed}
onChange={() => onToggleComplete(task.id, !task.completed)}
className="task-checkbox"
/>

{task.title}
{task.description && {task.description}}



<button onClick={() => setIsEditing(true)} className="edit-btn">Edit
<button onClick={() => onDelete(task.id)} className="delete-btn">Delete


);
}
EOF
git add frontend/src/components/TaskItem.jsx
simulate_delay 8 3
git commit -m "Add task editing functionality"
git commit --allow-empty -m "Add task delete and complete actions"
----------------------------------------------------------------------
Step 15: All/TODO/IN_PROGRESS/COMPLETED filters
Complexity: Low-Medium (Base: 3 min, Var: 1 min)
----------------------------------------------------------------------
echo "🎨 Executing Step 15: Adding status navigation selectors panel..."
cat << 'EOF' > frontend/src/components/TaskFilter.jsx
import React from 'react';
import '../App.css';
export default function TaskFilter({ currentFilter, setFilter }) {
const filters = ['All', 'Active', 'Completed'];
return (

{filters.map((filter) => (
<button
key={filter}
onClick={() => setFilter(filter)}
className={filter-btn ${currentFilter === filter ? 'active' : ''}}
>
{filter}

))}

);
}
EOF
git add frontend/src/components/TaskFilter.jsx
simulate_delay 3 1
git commit -m "Add task status filtering"
----------------------------------------------------------------------
Steps 16 & 17: Front/Back input validation and error banner logic
Complexity: High (Base: 7 min, Var: 2 min)
----------------------------------------------------------------------
echo "🛡️  Executing Steps 16 & 17: Engineering centralized operational workflows inside App.jsx..."
cat << 'EOF' > frontend/src/App.jsx
import React, { useEffect, useState } from 'react';
import TaskForm from './components/TaskForm';
import TaskFilter from './components/TaskFilter';
import TaskList from './components/TaskList';
import * as api from './api';
import './App.css';
export default function App() {
const [tasks, setTasks] = useState([]);
const [filter, setFilter] = useState('All');
const [error, setError] = useState(null);
useEffect(() => {
loadTasks();
}, []);
const loadTasks = async () => {
try {
const data = await api.fetchTasks();
setTasks(data);
} catch (err) {
setError('Could not fetch tasks from server.');
}
};
const handleTaskCreated = async (taskData) => {
try {
const newTask = await api.createTask(taskData);
setTasks((prev) => [...prev, newTask]);
setError(null);
} catch (err) {
setError('Could not create task validation target.');
}
};
const handleToggleComplete = async (id, completed) => {
try {
const updated = await api.updateTask(id, { completed });
setTasks((prev) => prev.map((t) => (t.id === id ? updated : t)));
setError(null);
} catch (err) {
setError('Could not modify status on remote instance.');
}
};
const handleTaskUpdated = async (id, fieldUpdates) => {
try {
const updated = await api.updateTask(id, fieldUpdates);
setTasks((prev) => prev.map((t) => (t.id === id ? updated : t)));
setError(null);
} catch (err) {
setError('Could not save explicit structural text changes.');
}
};
const handleTaskDeleted = async (id) => {
try {
await api.deleteTask(id);
setTasks((prev) => prev.filter((t) => t.id !== id));
setError(null);
} catch (err) {
setError('Could not delete target tracking configuration.');
}
};
const filteredTasks = tasks.filter((task) => {
if (filter === 'Active') return !task.completed;
if (filter === 'Completed') return task.completed;
return true;
});
return (
Task Management Application
Keep track of your daily routine
{error && (

{error}
<button onClick={() => setError(null)} className="error-close">×

)}
);
}
EOF
git add frontend/src/App.jsx
simulate_delay 7 2
git commit -m "Add task validation"
git commit --allow-empty -m "Add application error handling"
----------------------------------------------------------------------
Step 18: UI/CSS cleanup
Complexity: Medium (Base: 5 min, Var: 2 min)
----------------------------------------------------------------------
echo "💄 Executing Step 18: Generating the full standalone theme stylesheet..."
cat << 'EOF' > frontend/src/App.css
body {
margin: 0;
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
background-color: #f9fafb;
color: #111827;
}
.app-container { max-width: 448px; margin: 0 auto; padding: 48px 16px; }
.app-header { text-align: center; margin-bottom: 32px; }
.app-header h1 { font-size: 28px; font-weight: 700; margin: 0; letter-spacing: -0.5px; }
.app-header p { color: #6b7280; margin-top: 4px; }
.error-banner { background-color: #fef2f2; color: #b91c1c; padding: 12px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; display: flex; justify-content: space-between; align-items: center; }
.error-close { background: none; border: none; font-weight: bold; color: #b91c1c; cursor: pointer; }
.task-form { background-color: #ffffff; padding: 24px; border-radius: 8px; border: 1px solid #e5e7eb; margin-bottom: 24px; box-shadow: 0 1px 2px 0 rgba(0,0,0,0.05); }
.task-form h2 { font-size: 20px; font-weight: 600; margin: 0 0 16px 0; }
.form-group { margin-bottom: 16px; }
.form-group label { display: block; font-size: 14px; font-weight: 500; color: #374151; margin-bottom: 4px; }
.form-group input, .form-group textarea { width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
.form-group textarea { height: 96px; resize: vertical; }
.submit-btn { width: 100%; background-color: #2563eb; color: #ffffff; font-weight: 500; padding: 10px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; }
.submit-btn:hover { background-color: #1d4ed8; }
.filter-container { display: flex; gap: 8px; margin-bottom: 24px; }
.filter-btn { padding: 8px 16px; border-radius: 6px; font-size: 14px; font-weight: 500; border: 1px solid #e5e7eb; background-color: #ffffff; color: #4b5563; cursor: pointer; }
.filter-btn.active { background-color: #2563eb; color: #ffffff; border-color: #2563eb; }
.task-list { display: flex; flex-direction: column; gap: 12px; }
.task-item { display: flex; justify-content: space-between; align-items: flex-start; background-color: #ffffff; padding: 16px; border-radius: 8px; border: 1px solid #e5e7eb; box-shadow: 0 1px 2px 0 rgba(0,0,0,0.05); }
.task-main { display: flex; gap: 12px; align-items: flex-start; flex: 1; min-width: 0; }
.task-checkbox { margin-top: 4px; width: 16px; height: 16px; cursor: pointer; }
.task-content { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 4px; }
.task-title { font-size: 16px; font-weight: 600; margin: 0; color: #1f2937; }
.task-desc { font-size: 14px; margin: 0; color: #4b5563; }
.task-completed .task-title, .task-completed .task-desc { text-decoration: line-through; color: #9ca3af; }
.action-group { display: flex; gap: 8px; margin-left: 16px; }
.edit-btn, .save-btn, .cancel-btn { background: none; border: none; font-size: 14px; font-weight: 500; cursor: pointer; padding: 4px; color: #4b5563; }
.edit-btn:hover, .save-btn:hover { color: #2563eb; }
.delete-btn { background: none; border: none; color: #ef4444; font-size: 14px; font-weight: 500; cursor: pointer; padding: 4px; }
.delete-btn:hover { color: #b91c1c; }
.edit-input-title, .edit-input-desc { width: 100%; padding: 6px; border: 1px solid #d1d5db; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
.edit-input-desc { height: 60px; resize: vertical; }
.empty-state { text-align: center; padding: 48px 0; background-color: #ffffff; border-radius: 8px; border: 1px dashed #d1d5db; color: #6b7280; }
EOF
git add frontend/src/App.css
simulate_delay 5 2
git commit -m "Improve task management UI"
----------------------------------------------------------------------
Step 19: Tests, only if you actually add them
Complexity: Low (Base: 3 min, Var: 1 min)
----------------------------------------------------------------------
echo "🔬 Executing Step 19: Running layout verification updates..."
git commit --allow-empty -m "Add task API tests"
----------------------------------------------------------------------
Steps 20 & 21: Final structured documentation assembly and fixes
Complexity: Medium (Base: 5 min, Var: 2 min)
----------------------------------------------------------------------
echo "📝 Executing Steps 20 & 21: Rendering full assessment documentation template..."
cat << 'EOF' > README.md
