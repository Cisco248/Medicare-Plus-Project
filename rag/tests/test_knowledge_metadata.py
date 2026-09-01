from data.ingestion.knowledge_metadata import context_prefix, metadata_for_source


def test_diabetes_glucose_parameter_metadata():
    meta = metadata_for_source("parameters/glucose.md")
    assert meta["parameter"] == "glucose"
    assert meta["category"] == "parameter"
    assert meta["disease"] == "diabetes"


def test_diabetes_model_metadata():
    meta = metadata_for_source("models/diabetes-model.md")
    assert meta["model"] == "diabetes_prediction"
    assert meta["disease"] == "diabetes"


def test_context_prefix_keeps_disease_on_chunk():
    prefix = context_prefix({"disease": "diabetes", "parameter": "glucose"})
    assert prefix.startswith("Medicare Plus educational knowledge.")
    assert "Disease: diabetes." in prefix
    assert "Health parameter: glucose." in prefix
