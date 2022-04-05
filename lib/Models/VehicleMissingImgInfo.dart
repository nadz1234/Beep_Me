class MissingImageSpec {
  String? status;
  String? message;
  int? identity;
  List<ResultMissing>? result;

  MissingImageSpec({this.status, this.message, this.identity, this.result});

  MissingImageSpec.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    identity = json['identity'];
    if (json['result'] != null) {
      result = <ResultMissing>[];
      json['result'].forEach((v) {
        result!.add(new ResultMissing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['identity'] = this.identity;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultMissing {
  int? vehicleStockID;
  String? friendlyName;
  String? stockCode;
  int? imageCount;
  int? imageRequired;
  String? image;

  ResultMissing(
      {this.vehicleStockID,
      this.friendlyName,
      this.stockCode,
      this.imageCount,
      this.imageRequired,
      this.image});

  ResultMissing.fromJson(Map<String, dynamic> json) {
    vehicleStockID = json['vehicleStockID'];
    friendlyName = json['friendlyName'];
    stockCode = json['stockCode'];
    imageCount = json['imageCount'];
    imageRequired = json['imageRequired'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleStockID'] = this.vehicleStockID;
    data['friendlyName'] = this.friendlyName;
    data['stockCode'] = this.stockCode;
    data['imageCount'] = this.imageCount;
    data['imageRequired'] = this.imageRequired;
    data['image'] = this.image;
    return data;
  }
}
