class ApiEndpoints {
  ApiEndpoints._();

  /// FastAPI backend. Override at build time with
  /// `--dart-define=BACKEND_URL=http://192.168.1.103:8080` for local devices.
  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'https://medicare-plus-68356394205.europe-west1.run.app',
  );

  /// RAG API. Override at build time with
  /// `--dart-define=RAG_URL=http://192.168.1.103:8000` for local devices.
  static const String ragUrl = String.fromEnvironment(
    'RAG_URL',
    defaultValue: 'https://medicare-plus-rag-68356394205.europe-west1.run.app',
  );
}
