import datetime
from sqlalchemy import Column, Integer, String, DateTime
from database import Base

class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True, nullable=False)
    description = Column(String, nullable=True)
    status = Column(String, default="TODO", nullable=False)  # TODO, IN_PROGRESS, COMPLETED
    created_at = Column(DateTime, default=datetime.datetime.utcnow, nullable=False)
