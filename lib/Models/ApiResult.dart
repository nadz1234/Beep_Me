class ApiResult {
  String? status;
  String? message;
  int? identity;
  int? total;
  Map<String, dynamic>? result;

  ApiResult({
    this.status,
    this.message,
    this.identity,
    this.total,
    this.result,
  });

  factory ApiResult.fromJson(Map<String, dynamic> parsedJson) {
    return ApiResult(
      status: parsedJson['status'],
      message: parsedJson['message'],
      identity: parsedJson['identity']?.toInt(),
      total: parsedJson['total']?.toInt(),
      result: parsedJson['result'],
    );
  }
}
