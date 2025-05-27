CREATE (mig:Disease {name: "Migraine", type: "Neurological", prevalence: 12.0})
CREATE (mig)-[:HAS_SYMPTOM]->(:Symptom {name: "Throbbing Headache", severity: 7})
CREATE (mig)-[:HAS_SYMPTOM]->(:Symptom {name: "Nausea", severity: 5})
CREATE (mig)-[:HAS_SYMPTOM]->(:Symptom {name: "Light Sensitivity", severity: 6})
CREATE (mig)-[:TREATED_WITH]->(:Drug {name: "Ibuprofen", type: "NSAID", dosage: "200-400mg"})
CREATE (mig)-[:TREATED_WITH]->(:Drug {name: "Sumatriptan", type: "Triptan", dosage: "50-100mg"})
CREATE (mig)-[:TREATED_WITH]->(:Drug {name: "Propranolol", type: "Beta Blocker", dosage: "40-80mg/day"})
CREATE (mig)-[:ASSOCIATED_WITH]->(:Gene {name: "TRPM8"});

// Diabetes with complications
CREATE (dia:Disease {name: "Type 2 Diabetes", type: "Metabolic", prevalence: 9.3})
CREATE (dia)-[:HAS_SYMPTOM]->(:Symptom {name: "Frequent Urination", severity: 6})
CREATE (dia)-[:HAS_SYMPTOM]->(:Symptom {name: "Increased Thirst", severity: 5})
CREATE (dia)-[:HAS_SYMPTOM]->(:Symptom {name: "Blurred Vision", severity: 4})
CREATE (dia)-[:TREATED_WITH]->(:Drug {name: "Metformin", type: "Biguanide", dosage: "500-2000mg/day"})
CREATE (dia)-[:TREATED_WITH]->(:Drug {name: "Insulin Glargine", type: "Long-acting Insulin", dosage: "Individualized"})
CREATE (dia)-[:COMPLICATION]->(:Disease {name: "Diabetic Neuropathy"})
CREATE (dia)-[:COMPLICATION]->(:Disease {name: "Retinopathy"})
CREATE (dia)-[:ASSOCIATED_WITH]->(:Gene {name: "TCF7L2"});

// Influenza with prevention
CREATE (flu:Disease {name: "Influenza", type: "Viral Infection", prevalence: "Seasonal"})
CREATE (flu)-[:HAS_SYMPTOM]->(:Symptom {name: "Fever", severity: 8, duration: "3-5 days"})
CREATE (flu)-[:HAS_SYMPTOM]->(:Symptom {name: "Muscle Aches", severity: 6})
CREATE (flu)-[:HAS_SYMPTOM]->(:Symptom {name: "Cough", severity: 5})
CREATE (flu)-[:TREATED_WITH]->(:Drug {name: "Oseltamivir", type: "Antiviral", dosage: "75mg twice daily"})
CREATE (flu)-[:PREVENTED_BY]->(:Drug {name: "Influenza Vaccine", type: "Vaccine"});

CREATE (g:Disease {name: "GERD", type: "Gastrointestinal", prevalence: 20.0})
CREATE (g)-[:HAS_SYMPTOM]->(:Symptom {name: "Heartburn", severity: 7})
CREATE (g)-[:HAS_SYMPTOM]->(:Symptom {name: "Regurgitation", severity: 6})
CREATE (g)-[:HAS_SYMPTOM]->(:Symptom {name: "Chest Pain", severity: 5})
CREATE (g)-[:TREATED_WITH]->(:Drug {name: "Omeprazole", type: "PPI", dosage: "20-40mg/day"})
CREATE (g)-[:TREATED_WITH]->(:Drug {name: "Ranitidine", type: "H2 Blocker", dosage: "150mg twice daily"})
CREATE (g)-[:CAN_LEAD_TO]->(:Disease {name: "Esophagitis"});

CREATE (alz:Disease {name: "Alzheimer's Disease", type: "Neurodegenerative", prevalence: 5.0})
CREATE (alz)-[:HAS_SYMPTOM]->(:Symptom {name: "Memory Loss", severity: 9})
CREATE (alz)-[:HAS_SYMPTOM]->(:Symptom {name: "Confusion", severity: 8})
CREATE (alz)-[:HAS_SYMPTOM]->(:Symptom {name: "Mood Swings", severity: 7})
CREATE (alz)-[:TREATED_WITH]->(:Drug {name: "Donepezil", type: "Cholinesterase Inhibitor", dosage: "5-10mg/day"})
CREATE (alz)-[:TREATED_WITH]->(:Drug {name: "Memantine", type: "NMDA Antagonist", dosage: "10-28mg/day"})
CREATE (alz)-[:ASSOCIATED_WITH]->(:Gene {name: "APOE-e4"});
CREATE (c:Disease {name: "COPD", type: "Respiratory", prevalence: 6.0})
CREATE (c)-[:HAS_SYMPTOM]->(:Symptom {name: "Chronic Cough", severity: 7})
CREATE (c)-[:HAS_SYMPTOM]->(:Symptom {name: "Shortness of Breath", severity: 8})
CREATE (c)-[:HAS_SYMPTOM]->(:Symptom {name: "Wheezing", severity: 6})
CREATE (c)-[:TREATED_WITH]->(:Drug {name: "Tiotropium", type: "Anticholinergic", dosage: "18mcg daily"})
CREATE (c)-[:TREATED_WITH]->(:Drug {name: "Prednisone", type: "Corticosteroid", dosage: "5-60mg/day"})
CREATE (c)-[:PRIMARY_CAUSE]->(:Symptom {name: "Smoking"});

CREATE (ht:Disease {name: "Hyperthyroidism", type: "Endocrine", prevalence: 1.3})
CREATE (ht)-[:HAS_SYMPTOM]->(:Symptom {name: "Weight Loss", severity: 7})
CREATE (ht)-[:HAS_SYMPTOM]->(:Symptom {name: "Rapid Heartbeat", severity: 8})
CREATE (ht)-[:HAS_SYMPTOM]->(:Symptom {name: "Anxiety", severity: 6})
CREATE (ht)-[:TREATED_WITH]->(:Drug {name: "Methimazole", type: "Antithyroid", dosage: "5-30mg/day"})
CREATE (ht)-[:CAN_PROGRESS_TO]->(:Disease {name: "Thyroid Storm"});

CREATE (p:Disease {name: "Psoriasis", type: "Dermatological", prevalence: 3.0})
CREATE (p)-[:HAS_SYMPTOM]->(:Symptom {name: "Scaly Patches", severity: 7})
CREATE (p)-[:HAS_SYMPTOM]->(:Symptom {name: "Itching", severity: 6})
CREATE (p)-[:ASSOCIATED_WITH]->(:Gene {name: "IL23R"});

MATCH (s:symptom {name:"Joint Pain"})
MATCH (d3:Disease {name:"Rheumatoid Arthritis"})
MATCH (d4:Disease {name:"Psoriasis"})

CREATE (d3)-[:HAS_SYMPTOM]->(s) 
CREATE (d4)-[:HAS_SYMPTOM]->(s)

CREATE (cd:Disease {name: "Crohn's Disease", type: "Gastrointestinal", prevalence: 0.3})
CREATE (cd)-[:HAS_SYMPTOM]->(:Symptom {name: "Abdominal Cramps", severity: 8})
CREATE (cd)-[:HAS_SYMPTOM]->(:Symptom {name: "Rectal Bleeding", severity: 7})
CREATE (cd)-[:HAS_SYMPTOM]->(:Symptom {name: "Fistulas", severity: 6})
CREATE (cd)-[:TREATED_WITH]->(:Drug {name: "Infliximab", type: "Anti-TNF", dosage: "5mg/kg every 8 weeks"})
CREATE (cd)-[:TREATED_WITH]->(:Drug {name: "Budesonide", type: "Corticosteroid", dosage: "9mg daily"})
CREATE (cd)-[:ASSOCIATED_WITH]->(:Gene {name: "NOD2"});

CREATE (m:Disease {name: "Malaria", type: "Infectious", prevalence: "Endemic"})
CREATE (m)-[:HAS_SYMPTOM]->(:Symptom {name: "Cyclic Fevers", severity: 9})
CREATE (m)-[:HAS_SYMPTOM]->(:Symptom {name: "Hemolytic Anemia", severity: 8})
CREATE (m)-[:HAS_SYMPTOM]->(:Symptom {name: "Splenomegaly", severity: 7})
CREATE (m)-[:TREATED_WITH]->(:Drug {name: "Artemether-Lumefantrine", type: "ACT", dosage: "6-dose regimen"})
CREATE (m)-[:TREATED_WITH]->(:Drug {name: "Quinine", type: "Alkaloid", dosage: "600mg TDS"})
CREATE (m)-[:PREVENTED_BY]->(:Drug {name: "Atovaquone-Proguanil", type: "Prophylaxis"});

CREATE (c:Disease {name: "COPD", type: "Respiratory", prevalence: 6.5})
CREATE (c)-[:HAS_SYMPTOM]->(:Symptom {name: "Chronic Phlegm", severity: 7})
CREATE (c)-[:HAS_SYMPTOM]->(:Symptom {name: "Exercise Intolerance", severity: 8})
CREATE (c)-[:HAS_SYMPTOM]->(:Symptom {name: "Barrel Chest", severity: 5})
CREATE (c)-[:TREATED_WITH]->(:Drug {name: "Indacaterol", type: "LABA", dosage: "75mcg daily"})
CREATE (c)-[:TREATED_WITH]->(:Drug {name: "Roflumilast", type: "PDE4 Inhibitor", dosage: "500mcg daily"})
CREATE (c)-[:PRIMARY_CAUSE]->(:Symptom {name: "Smoking"});

CREATE (g:Disease {name: "GERD", type: "Gastrointestinal", prevalence: 18.0})
CREATE (g)-[:HAS_SYMPTOM]->(:Symptom {name: "Acid Regurgitation", severity: 7})
CREATE (g)-[:HAS_SYMPTOM]->(:Symptom {name: "Chronic Cough", severity: 5})
CREATE (g)-[:HAS_SYMPTOM]->(:Symptom {name: "Laryngitis", severity: 4})
CREATE (g)-[:TREATED_WITH]->(:Drug {name: "Esomeprazole", type: "PPI", dosage: "20-40mg/day"})
CREATE (g)-[:TREATED_WITH]->(:Drug {name: "Gaviscon", type: "Antacid", dosage: "10-20ml as needed"})
CREATE (g)-[:CAN_LEAD_TO]->(:Disease {name: "Barrett's Esophagus"});

// Shared symptom: Fatigue
MATCH (s:Symptom {name: "Fatigue"}), 
      (d1:Disease {name: "Rheumatoid Arthritis"}),
      (d2:Disease {name: "HIV/AIDS"})
CREATE (d1)-[:HAS_SYMPTOM]->(s),
       (d2)-[:HAS_SYMPTOM]->(s);

// Comorbidity: Asthma & Allergic Rhinitis
MATCH (a:Disease {name: "Asthma"}), (ar:Disease {name: "Allergic Rhinitis"})
CREATE (a)-[:COMORBID_WITH]->(ar);

// Treatment overlap: TNF Inhibitors
MATCH (d1:Disease {name: "Rheumatoid Arthritis"}),
      (d2:Disease {name: "Crohn's Disease"}),
      (drug:Drug {name: "Infliximab"})
CREATE (d1)-[:TREATED_WITH]->(drug),
       (d2)-[:TREATED_WITH]->(drug);

// Create relationships between existing nodes
MATCH (d1:Disease {name: "Migraine"}), (d2:Disease {name: "Diabetic Neuropathy"})
CREATE (d1)-[:COMORBID_WITH]->(d2);

MATCH (s:Symptom {name: "Headache"}), (d:Disease {name: "Hypertension"})
CREATE (d)-[:HAS_SYMPTOM]->(s);

MATCH (s:symptom {name:"Joint Pain"}),	
		(d1:Disease {name:"Rheumatoid Arthritis"})'
		(d2:Disease {name:"Psoriasis"})
CREATE (d1)-[:HAS_SYMPTOM]->(s),
		(d2)-[:HAS_SYMPTOM]->(s);

// Connect related diseases
MATCH (d1:Disease {name: "Rheumatoid Arthritis"}), (d2:Disease {name: "Psoriasis"})
CREATE (d1)-[:SHARES_PATHWAY_WITH]->(d2);

// Connect shared symptoms
MATCH (s:Symptom {name: "Fatigue"}), 
      (d1:Disease {name: "Major Depressive Disorder"}),
      (d2:Disease {name: "Hypothyroidism"})
CREATE (d1)-[:HAS_SYMPTOM]->(s),
       (d2)-[:HAS_SYMPTOM]->(s);

// Connect treatment alternatives
MATCH (d:Disease {name: "Rheumatoid Arthritis"}), (drug:Drug {name: "Adalimumab"})
CREATE (d)-[:TREATED_WITH]->(drug);