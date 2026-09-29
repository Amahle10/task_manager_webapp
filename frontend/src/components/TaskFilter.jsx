import React from 'react';
import '../App.css';

export default function TaskFilter({ currentFilter, setFilter }) {
  const filters = ['All', 'TODO', 'IN_PROGRESS', 'COMPLETED'];

  return (
    <div className="filter-container">
      {filters.map((filter) => (
        <button
          key={filter}
          onClick={() => setFilter(filter)}
          className={`filter-btn ${currentFilter === filter ? 'active' : ''}`}
        >
          {filter}
        </button>
      ))}
    </div>
  );
}
