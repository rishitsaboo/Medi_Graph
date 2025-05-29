import React, { useState } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import axios from "axios";
import Home from "./components/home";
import DiseaseCard from "./components/DiseaseCard";
import SearchBar from "./components/SearchBar";
import SymptomSearch from "./SymptomSearch";
import "./components/Results.css";
import "./App.css";

import { useNavigate } from "react-router-dom";

function DiseaseSearch() {
  const navigate = useNavigate();
  const [results, setResults] = useState({
    diseases: [],
    symptoms: [],
    drugs: [],
  });

  const handleSearch = async (query) => {
    try {
      const response = await axios.get(
        `http://localhost:8000/api/search?query=${query}`,
      );
      const data = response.data;
      console.log("Search response data:", data);
      setResults({
        diseases: data.diseases || [],
        symptoms: data.symptoms || [],
        drugs: data.drugs || [],
      });
    } catch (error) {
      console.error("Search failed:", error);
      setResults({ diseases: [], symptoms: [], drugs: [] });
    }
  };

  return (
    <div className="App">
      <SearchBar onSearch={handleSearch} placeholder="Search Diseases" />
      <div className="results-container" id="diseases">
        <section>
          <h2>Diseases</h2>
          {results.diseases.map((disease) => (
            <DiseaseCard key={disease.name} disease={disease} />
          ))}
        </section>
      </div>
      <div className="results-container" id="drugs">
        <section>
          <h2>Drugs</h2>
          {results.drugs.length > 0 ? (
            <ul>
              {results.drugs.map((drug) => (
                <li key={drug.name}>
                  {drug.name} ({drug.type})
                </li>
              ))}
            </ul>
          ) : (
            <p>No drugs found.</p>
          )}
        </section>
      </div>
      <button
        onClick={() => navigate("/")}
        className="go-back-button"
        style={{ display: "block", margin: "20px auto" }}
      >
        Go Back
      </button>
    </div>
  );
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/disease-search" element={<DiseaseSearch />} />
        <Route path="/symptom-search" element={<SymptomSearch />} />
      </Routes>
    </Router>
  );
}

export default App;
