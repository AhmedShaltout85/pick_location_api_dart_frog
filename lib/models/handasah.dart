// ignore_for_file: public_member_api_docs, sort_constructors_first, always_put_required_named_parameters_first
import 'package:equatable/equatable.dart';

class PickLocationHandasah extends Equatable {
  final int? id;
  final String handasahName;
  final String storeName;
  final int storeNumber;

  const PickLocationHandasah({
    this.id,
    required this.handasahName,
    required this.storeName,
    required this.storeNumber,
  });

  factory PickLocationHandasah.fromJson(Map<String, dynamic> json) {
    return PickLocationHandasah(
      id: json['id'] as int?,
      handasahName: json['handasah_name'] as String,
      storeName: json['store_name'] as String,
      storeNumber: json['store_number'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handasah_name': handasahName,
      'store_name': storeName,
      'store_number': storeNumber,
    };
  }

  @override
  List<Object?> get props => [id, handasahName, storeName, storeNumber];
}

class HandasatTool {
  final int? id;
  final String? handasahName;
  final String? toolName;
  final int? toolQty;

  HandasatTool({
    this.id,
    this.handasahName,
    this.toolName,
    this.toolQty,
  });

  factory HandasatTool.fromJson(Map<String, dynamic> json) {
    return HandasatTool(
      id: json['id'] as int?,
      handasahName: json['handasah_name'] as String?,
      toolName: json['tool_name'] as String?,
      toolQty: json['tool_qty'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handasah_name': handasahName,
      'tool_name': toolName,
      'tool_qty': toolQty,
    };
  }
}
