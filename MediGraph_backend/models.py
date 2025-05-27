from pydantic import BaseModel
from typing import List, Optional

class Symptom(BaseModel):
    """Model for representing symptoms"""
    name: str
    severity: Optional[int] = None  # Severity scale (1-10)
    duration: Optional[str] = None  # e.g., "Chronic", "Acute"
    description: Optional[str] = None  # Additional details

class Drug(BaseModel):
    """Model for representing medications"""
    name: str
    type: Optional[str] = None  # e.g., "NSAID", "Antibiotic"
    dosage: Optional[str] = None  # e.g., "200mg daily"
    side_effects: Optional[List[str]] = None  # Common side effects

class DiseaseBase(BaseModel):
    """Base model for diseases (without relationships)"""
    name: str
    type: Optional[str] = None  # e.g., "Cardiovascular", "Neurological"
    prevalence: Optional[float] = None  # Percentage in population
    icd_code: Optional[str] = None  # ICD-11 code

class Disease(DiseaseBase):
    """Complete disease model with relationships"""
    symptoms: List[Symptom] = []  # Associated symptoms
    drugs: List[Drug] = []  # Treatment options
    complications: List[DiseaseBase] = []  # Possible complications

class SearchResult(BaseModel):
    """Model for search API responses"""
    query: str  # The original search term
    diseases: List[Disease] = []  # Matching diseases
    symptoms: List[Symptom] = []  # Matching symptoms
    drugs: List[Drug] = []  # Matching drugs

class ConnectionTestResult(BaseModel):
    """For testing database connection"""
    status: str
    neo4j_version: Optional[str] = None
    error: Optional[str] = None