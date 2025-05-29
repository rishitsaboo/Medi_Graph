import React from "react";
import { useNavigate } from "react-router-dom";
import "./home.css";

const Home = () => {
  const navigate = useNavigate();

  const handleDiseaseSearch = () => {
    navigate("/disease-search");
  };

  const handleSymptomSearch = () => {
    navigate("/symptom-search");
  };

  return (
    <div className="home-container">
      <h1>Welcome to Medi Graph</h1>
      <div className="search-options">
        <button onClick={handleDiseaseSearch} className="search-button">
          Search by Disease
        </button>
        <button onClick={handleSymptomSearch} className="search-button">
          Search by Symptoms
        </button>
      </div>
    </div>
  );
};

export default Home;
