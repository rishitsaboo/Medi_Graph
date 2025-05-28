import { useState } from "react";
import axios from "axios";
import SearchBar from "./components/SearchBar";
import DiseaseCard from "./components/DiseaseCard";
import "./components/Results.css";
import "./App.css"; // Added import for App.css

function App() {
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
      console.log("Search response data:", data); // Added for debugging
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
      <SearchBar onSearch={handleSearch} />
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
    </div>
  );
}

export default App;
