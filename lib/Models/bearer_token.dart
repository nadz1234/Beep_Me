class BearerToken {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  DateTime? created;
  BearerToken(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn,
      this.created});

  factory BearerToken.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson == null || parsedJson.isEmpty) {
      return BearerToken.empty();
    }
    int expires = parsedJson['expires_in']?.toInt() ?? 0;
    String? createdDate = parsedJson['created'];
    return BearerToken(
        accessToken: parsedJson['access_token'],
        tokenType: parsedJson['tokenType'],
        expiresIn: expires,
        created: createdDate == null || createdDate.isNotEmpty
            ? DateTime.now().add(new Duration(seconds: expires))
            : DateTime.parse(createdDate));
  }
  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        'expires_in': expiresIn
      };

  factory BearerToken.empty() {
    return new BearerToken(
        accessToken: '', tokenType: '', expiresIn: 0, created: DateTime.now());
  }
}
