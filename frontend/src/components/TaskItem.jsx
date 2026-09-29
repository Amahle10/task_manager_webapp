import React, { useState } from 'react';
import '../App.css';

export default function TaskItem({ task, onUpdateTask, onDelete }) {
  const [isEditing, setIsEditing] = useState(false);
  const [editTitle, setEditTitle] = useState(task.title);
  const [editDesc, setEditDesc] = useState(task.description || '');
  const [editStatus, setEditStatus] = useState(task.status);

  const handleSave = () => {
    if (!editTitle.trim()) return;
    onUpdateTask(task.id, { title: editTitle.trim(), description: editDesc.trim(), status: editStatus });
    setIsEditing(false);
  };

  const handleCompleteAction = () => {
    onUpdateTask(task.id, { status: 'COMPLETED' });
  };

  const formatDate = (dateString) => {
    try {
      const options = { day: 'numeric', month: 'long', year: 'numeric' };
      return new Date(dateString).toLocaleDateString('en-GB', options);
    } catch (e) {
      return dateString;
    }
  };

  if (isEditing) {
    return (
      <div className="task-form edit-task-mode">
        <h2>Edit Task</h2>
        <div className="form-group">
          <label>Title</label>
          <input 
            type="text" 
            value={editTitle} 
            onChange={(e) => setEditTitle(e.target.value)} 
            maxLength={100}
          />
        </div>
        <div className="form-group">
          <label>Description</label>
          <textarea 
            value={editDesc} 
            onChange={(e) => setEditDesc(e.target.value)} 
            maxLength={500}
          />
        </div>
        <div className="form-group">
          <label>Status</label>
          <select value={editStatus} onChange={(e) => setEditStatus(e.target.value)}>
            <option value="TODO">TODO</option>
            <option value="IN_PROGRESS">IN_PROGRESS</option>
            <option value="COMPLETED">COMPLETED</option>
          </select>
        </div>
        <div className="action-group">
          <button onClick={() => setIsEditing(false)} className="cancel-btn">Cancel</button>
          <button onClick={handleSave} className="submit-btn inline-save">[Save]</button>
        </div>
      </div>
    );
  }

  return (
    <div className={`task-item ${task.status === 'COMPLETED' ? 'task-completed' : ''}`}>
      <div className="task-content">
        <h3 className="task-title">{task.title}</h3>
        {task.description && <p className="task-desc">{task.description}</p>}
        <div className="task-metadata">
          <span className={`status-badge ${task.status.toLowerCase().replace('_', '-')}`}>Status: {task.status}</span>
          <span className="task-date">Created: {formatDate(task.created_at)}</span>
        </div>
      </div>
      <div className="action-group card-actions">
        <button onClick={() => setIsEditing(true)} className="edit-btn">[Edit]</button>
        {task.status !== 'COMPLETED' && (
          <button onClick={handleCompleteAction} className="save-btn">[Complete]</button>
        )}
        <button onClick={() => onDelete(task.id)} className="delete-btn">[Delete]</button>
      </div>
    </div>
  );
}
