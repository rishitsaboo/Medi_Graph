from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from database import db
from models import Disease, Symptom, Drug, SearchResult
from fastapi.responses import RedirectResponse
import uvicorn
import logging

###
#TO start the backend server, run the following command:
# uvicorn main:app --reload
###


logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

# Initialize FastAPI application
app = FastAPI(title="Medical Graph API")

# Enable CORS (Cross-Origin Resource Sharing)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3001"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)
@app.get("/")
async def root():
    return RedirectResponse(url="/docs")
# Helper function to get disease data
def get_disease_data(tx, name: str):
    result = tx.run("""
    MATCH (d:Disease {name: $name})
    OPTIONAL MATCH (d)-[:HAS_SYMPTOM]->(s:Symptom)
    OPTIONAL MATCH (d)-[:TREATED_WITH]->(dr:Drug)
    RETURN d, collect(s) AS symptoms, collect(dr) AS drugs
    """, name=name)
    return result.single()
# Endpoint to get disease details
@app.get("/diseases/{disease_name}", response_model=Disease)
async def get_disease(disease_name: str):
    with db.get_session() as session:
        result = session.execute_read(get_disease_data, disease_name)
        if not result:
            raise HTTPException(status_code=404, detail="Disease not found")
        
        disease = result["d"]
        return Disease(
            name=disease["name"],
            type=disease.get("type"),
            symptoms=[Symptom(**s._properties) for s in result["symptoms"]],
            drugs=[Drug(**dr._properties) for dr in result["drugs"]]
        )

# Search endpoint
@app.get("/api/search", response_model=SearchResult)
async def search(query: str):
    with db.get_session() as session:
        # Enhanced query: fetch full disease info if the match is a Disease
        result = session.run("""
        MATCH (n)
        WHERE toLower(n.name) CONTAINS toLower($query)
        WITH n, labels(n)[0] AS type
        OPTIONAL MATCH (n)-[:HAS_SYMPTOM]->(s:Symptom)
        OPTIONAL MATCH (n)-[:TREATED_WITH]->(dr:Drug)
        RETURN n, type, collect(DISTINCT s) AS symptoms, collect(DISTINCT dr) AS drugs
        """, {"query": query})
        
        diseases = []
        symptoms = []
        drugs = []

        for record in result:
            node = record["n"]
            node_type = record["type"]
            node_props = node._properties

            if node_type == "Disease":
                disease_symptoms = [Symptom(**s._properties) for s in record["symptoms"] if s]
                disease_drugs = [Drug(**dr._properties) for dr in record["drugs"] if dr]

                diseases.append(Disease(
                    name=node_props["name"],
                    type=node_props.get("type"),
                    symptoms=disease_symptoms,
                    drugs=disease_drugs
                ))

                symptoms.extend(disease_symptoms)
                drugs.extend(disease_drugs)

            elif node_type == "Symptom":
                symptoms.append(Symptom(
                    name=node_props["name"],
                    severity=node_props.get("severity")
                ))
            elif node_type == "Drug":
                drugs.append(Drug(
                    name=node_props["name"],
                    type=node_props.get("type"),
                    dosage=node_props.get("dosage")
                ))

        return SearchResult(
            query=query,
            diseases=diseases,
            symptoms=symptoms,
            drugs=drugs
        )

@app.get("/api/graph")
async def get_graph(query: str = ""):
    with db.get_session() as session:
        if query:
            cypher_query = """
            MATCH (n)-[r]->(m)
            WHERE toLower(n.name) CONTAINS toLower($query) OR toLower(m.name) CONTAINS toLower($query)
            RETURN collect(DISTINCT n) AS nodes, collect(DISTINCT r) AS relationships, collect(DISTINCT m) AS nodes2
            """
            result = session.run(cypher_query, {"query": query})
        else:
            cypher_query = """
            MATCH (n)-[r]->(m)
            RETURN collect(DISTINCT n) AS nodes, collect(DISTINCT r) AS relationships, collect(DISTINCT m) AS nodes2
            """
            result = session.run(cypher_query)

        record = result.single()
        nodes = record["nodes"] + record["nodes2"]
        relationships = record["relationships"]

        # Prepare nodes list with unique nodes
        unique_nodes = {}
        for node in nodes:
            unique_nodes[node.id] = {
                "id": node.id,
                "labels": list(node.labels),
                "properties": dict(node._properties)
            }

        # Prepare relationships list
        rels = []
        for rel in relationships:
            rels.append({
                "id": rel.id,
                "type": rel.type,
                "startNode": rel.start_node.id,
                "endNode": rel.end_node.id,
                "properties": dict(rel._properties)
            })

        return {
            "nodes": list(unique_nodes.values()),
            "relationships": rels
        }

# Run the application
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)