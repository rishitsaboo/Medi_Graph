import PropTypes from "prop-types";

const DiseaseCard = ({ disease }) => {
  return (
    <div className="disease-card">
      <h3>{disease.name}</h3>
      <p>Type: {disease.type}</p>
      <div className="symptoms">
        <h4>Symptoms:</h4>
        <ul>
          {Array.isArray(disease.symptoms) && disease.symptoms.length > 0 ? (
            disease.symptoms.map((symptom) => (
              <li key={symptom.name}>
                {symptom.name} (Severity: {symptom.severity})
              </li>
            ))
          ) : (
            <p>No symptoms available.</p>
          )}
        </ul>
      </div>
    </div>
  );
};

DiseaseCard.propTypes = {
  disease: PropTypes.shape({
    name: PropTypes.string.isRequired,
    type: PropTypes.string.isRequired,
    symptoms: PropTypes.arrayOf(
      PropTypes.shape({
        name: PropTypes.string.isRequired,
        severity: PropTypes.string.isRequired,
      }),
    ),
  }).isRequired,
};

export default DiseaseCard;
