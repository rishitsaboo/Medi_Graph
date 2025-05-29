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
    allow_origins=["http://localhost:3000"],  # Allows all origins
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
    try:
        with db.get_session() as session:
            # 1. Diseases matched by name
            direct_result = session.run("""
            MATCH (d:Disease)
            WHERE toLower(d.name) CONTAINS toLower($query)
            OPTIONAL MATCH (d)-[:HAS_SYMPTOM]->(s:Symptom)
            OPTIONAL MATCH (d)-[:TREATED_WITH]->(dr:Drug)
            RETURN d, collect(DISTINCT s) AS symptoms, collect(DISTINCT dr) AS drugs
            """, {"query": query})

            # 2. Diseases connected to symptoms matching query
            symptom_result = session.run("""
            MATCH (s:Symptom)
            WHERE toLower(s.name) CONTAINS toLower($query)
            MATCH (d:Disease)-[:HAS_SYMPTOM]->(s)
            OPTIONAL MATCH (d)-[:HAS_SYMPTOM]->(s2:Symptom)
            OPTIONAL MATCH (d)-[:TREATED_WITH]->(dr:Drug)
            RETURN DISTINCT d, collect(DISTINCT s2) AS symptoms, collect(DISTINCT dr) AS drugs
            """, {"query": query})

            disease_map = {}
            all_symptoms = {}
            all_drugs = {}

            def process_record(record):
                d = record["d"]
                disease_name = d["name"]
                symptoms = [Symptom(**s._properties) for s in record["symptoms"] if s]
                drugs = [Drug(**dr._properties) for dr in record["drugs"] if dr]

                if disease_name not in disease_map:
                    disease_map[disease_name] = Disease(
                        name=disease_name,
                        type=d.get("type"),
                        symptoms=symptoms,
                        drugs=drugs
                    )
                else:
                    # avoid duplicates: extend only unique items
                    disease = disease_map[disease_name]
                    existing_symptom_names = {s.name for s in disease.symptoms}
                    existing_drug_names = {dr.name for dr in disease.drugs}
                    disease.symptoms.extend([s for s in symptoms if s.name not in existing_symptom_names])
                    disease.drugs.extend([dr for dr in drugs if dr.name not in existing_drug_names])

                for s in symptoms:
                    all_symptoms[s.name] = s
                for dr in drugs:
                    all_drugs[dr.name] = dr

            for record in direct_result:
                process_record(record)

            for record in symptom_result:
                process_record(record)

            return SearchResult(
                query=query,
                diseases=list(disease_map.values()),
                symptoms=list(all_symptoms.values()),
                drugs=list(all_drugs.values())
            )

    except Exception as e:
        logging.exception("Search failed")
        raise HTTPException(status_code=500, detail=str(e))
# Run the application
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)