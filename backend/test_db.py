# test_db.py
from sqlalchemy import text
from database import engine

# Open a connection and execute the harmless query
with engine.connect() as connection:
    connection.execute(text("SELECT 1"))
    print("Database connected successfully.")
