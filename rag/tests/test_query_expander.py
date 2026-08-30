from domain.retriever.query_expander import expand_query


def test_diabetes_question_keeps_core_term():
    query = expand_query("What is diabetes?")
    assert "diabetes" in query.lower()
    assert "blood glucose" in query.lower() or "diabetes mellitus" in query.lower()


def test_sugar_expands_to_glucose_and_diabetes():
    query = expand_query("Why is my sugar high?")
    lowered = query.lower()
    assert "glucose" in lowered
    assert "diabetes" in lowered


def test_generic_this_disease_uses_patient_context():
    query = expand_query(
        "How can I control or manage this disease?",
        patient_context="Latest e-doc screening: diabetes prediction model. Glucose: 9.2 mmol/L.",
    )
    assert "diabetes" in query.lower()


def test_identify_diabetes_adds_diagnosis_terms():
    query = expand_query("how the identify the diabetes")
    lowered = query.lower()
    assert "diabetes" in lowered
    assert "diagnosis" in lowered
