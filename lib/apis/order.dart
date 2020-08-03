part of 'client.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: must_be_immutable

@JsonSerializable()
class Order extends Equatable {
  int id;

  User user;
  int user_id;
  List<String> job;
  Contract contract;
  int contract_id;
  String orderID;
  int image_count;
  int job_count;
  int comment_count;
  int status;
  int service;
  int main_info;
  int sub_info;
  String from_date;
  String to_date;
  String code;
  String address;
  double lat;
  double lng;
  String create_at;
  String change_at;

  Order({this.id});

  static Order fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  List<Object> get props => [
        id,
        user,
        user_id,
        job,
        contract,
        contract_id,
        orderID,
        image_count,
        job_count,
        comment_count,
        status,
        service,
        main_info,
        sub_info,
        from_date,
        to_date,
        code,
        address,
        lat,
        lng,
        create_at,
        change_at
      ];
}

@JsonSerializable()
class OrderList extends Equatable {
  int totalCount;
  int pageNo;

  List<Order> data;

  static OrderList fromJson(Map<String, dynamic> json) =>
      _$OrderListFromJson(json);
  Map<String, dynamic> toJson() => _$OrderListToJson(this);

  @override
  List<Object> get props => [totalCount, pageNo];
}
