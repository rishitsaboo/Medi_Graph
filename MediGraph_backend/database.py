from neo4j import GraphDatabase
from dotenv import load_dotenv
import os

load_dotenv()  # Add this line

class Neo4jConnection:
    def __init__(self):
        self.driver = GraphDatabase.driver(
            os.getenv("NEO4J_URI"),  # Changed from os.environ[]
            auth=(os.getenv("NEO4J_USER"), os.getenv("NEO4J_PASSWORD"))
        )
    def close(self):
        self.driver.close()
     
    def get_session(self):
        return self.driver.session()

db = Neo4jConnection()