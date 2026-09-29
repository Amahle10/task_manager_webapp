import React from 'react';
import TaskItem from './TaskItem';
import '../App.css';

export default function TaskList({ tasks, onUpdateTask, onDelete }) {
  if (tasks.length === 0) {
    return (
      <div className="empty-state">
        <p>No tasks available.</p>
      </div>
    );
  }

  return (
    <div className="task-list">
      {tasks.map((task) => (
        <TaskItem
          key={task.id}
          task={task}
          onUpdateTask={onUpdateTask}
          onDelete={onDelete}
        />
      ))}
    </div>
  );
}
