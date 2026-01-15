// ignore_for_file: public_member_api_docs, sort_constructors_first

class ToolsRequest {
  final int? id;
  final String? handasahName;
  final String? toolName;
  final int toolQty;
  final String? techName;
  final int requestStatus;
  final int isApproved;
  final DateTime date;
  final String? address;

  ToolsRequest({
    this.id,
    this.handasahName,
    this.toolName,
    this.toolQty = 0,
    this.techName,
    this.requestStatus = 1,
    this.isApproved = 0,
    required this.date,
    this.address,
  });

  factory ToolsRequest.fromJson(Map<String, dynamic> json) {
    return ToolsRequest(
      id: json['id'] as int?,
      handasahName: json['handasah_name'] as String?,
      toolName: json['tool_name'] as String?,
      toolQty: json['tool_qty'] as int? ?? 0,
      techName: json['tech_name'] as String?,
      requestStatus: json['request_status'] as int? ?? 1,
      isApproved: json['is_approved'] as int? ?? 0,
      date: json['date'] is String
          ? DateTime.parse(json['date'] as String)
          : json['date'] as DateTime,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handasah_name': handasahName,
      'tool_name': toolName,
      'tool_qty': toolQty,
      'tech_name': techName,
      'request_status': requestStatus,
      'is_approved': isApproved,
      'date': date.toIso8601String(),
      'address': address,
    };
  }
}
