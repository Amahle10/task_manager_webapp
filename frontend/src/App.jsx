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
      setError('Unable to connect to the server.');
    }
  };

  const handleTaskCreated = async (taskData) => {
    if (!taskData.title.trim()) {
      setError("Task title is required.");
      return;
    }
    try {
      const newTask = await api.createTask(taskData);
      setTasks((prev) => [...prev, newTask]);
      setError(null);
    } catch (err) {
      setError('Failed to create task.');
    }
  };

  const handleTaskUpdated = async (id, fieldUpdates) => {
    if (fieldUpdates.title !== undefined && !fieldUpdates.title.trim()) {
      setError("Task title is required.");
      return;
    }
    try {
      const updated = await api.updateTask(id, fieldUpdates);
      setTasks((prev) => prev.map((t) => (t.id === id ? updated : t)));
      setError(null);
    } catch (err) {
      setError('Failed to update task.');
    }
  };

  const handleTaskDeleted = async (id) => {
    try {
      await api.deleteTask(id);
      setTasks((prev) => prev.filter((t) => t.id !== id));
      setError(null);
    } catch (err) {
      setError('Failed to delete task.');
    }
  };

  const filteredTasks = tasks.filter((task) => {
    if (filter === 'All') return true;
    return task.status === filter;
  });

  return (
    <div className="app-container">
      <header className="app-header">
        <h1>Task Management Application</h1>
        <p>Keep track of your daily routine</p>
      </header>

      {error && (
        <div className="error-banner">
          <span>{error}</span>
          <button onClick={() => setError(null)} className="error-close">&times;</button>
        </div>
      )}

      <TaskForm onTaskCreated={handleTaskCreated} setError={setError} />
      <TaskFilter currentFilter={filter} setFilter={setFilter} />
      <TaskList 
        tasks={filteredTasks} 
        onUpdateTask={handleTaskUpdated}
        onDelete={handleTaskDeleted} 
      />
    </div>
  );
}
