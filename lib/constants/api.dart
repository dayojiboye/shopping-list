class API {
  const API({required this.endpoint});

  final String endpoint;

  final baseUrl = "flutter-prep-8e00d-default-rtdb.firebaseio.com";

  Uri get url {
    return Uri.https(baseUrl, endpoint);
  }
}
