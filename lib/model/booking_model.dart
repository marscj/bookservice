import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../utils/date_format.dart';
import '../utils/random_string.dart';
import '../model/user_model.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel{
  String id;
  
  int cagetory;
  int info;
  int subInfo;
  String fromDate;
  String toDate;
  String addr;
  String url;
  String otherInfo;

  String userId;
  String userName;
  String userNumber;
  String userEmail;

  String serviceCode;
  String createTime;
  
  String staffId;
  String staffName;
  String staffNumber;
  String staffEmail;

  String evaluation;
  int evaluation_lv;

  PlaceModel place;

  int status; //0 pending 1 complete 2 cancel 3 deleted

  BookingModel() {
    id = Uuid().v1();
    serviceCode = randomNumeric(4);
    createTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
    status = 0;
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}