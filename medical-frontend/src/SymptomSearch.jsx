import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import SearchBar from "./components/SearchBar";
import DiseaseCard from "./components/DiseaseCard";
import "./components/Results.css";
import "./App.css";

function SymptomSearch() {
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
      if (!data.diseases) {
        console.warn("No diseases field in API response");
      }
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
      <SearchBar onSearch={handleSearch} placeholder="Search Symptoms" />
      <div className="results-container" id="symptoms">
        <section>
          <h2>Related Diseases</h2>
          {results.diseases.length > 0 ? (
            results.diseases.map((disease) => (
              <DiseaseCard key={disease.name} disease={disease} />
            ))
          ) : (
            <p>No related diseases found.</p>
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

export default SymptomSearch;
