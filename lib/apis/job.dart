part of 'client.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: must_be_immutable

@JsonSerializable()
class Job extends Equatable {
  int id;
  String date;
  String card;
  int unit;
  String remark;
  Order order;

  static Job fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);

  @override
  List<Object> get props => [id];
}
