class HTTPServiceModal {
  final int? code;
  final dynamic msg;

  HTTPServiceModal({this.code, this.msg});

  factory HTTPServiceModal.fromJson(Map<String, dynamic> json) {
    return HTTPServiceModal(code: json['code'] as int, msg: json['msg'] as dynamic);
  }
}
