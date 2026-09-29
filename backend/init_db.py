# init_db.py
from database import engine, Base
import models  # Must import models so Base knows they exist

print("Creating database tables...")
Base.metadata.create_all(bind=engine)
print("Tables created successfully.")
