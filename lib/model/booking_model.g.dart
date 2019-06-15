// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return BookingModel()
    ..id = json['id'] as String
    ..cagetory = json['cagetory'] as int
    ..info = json['info'] as int
    ..subInfo = json['subInfo'] as int
    ..fromDate = json['fromDate'] as String
    ..toDate = json['toDate'] as String
    ..addr = json['addr'] as String
    ..url = json['url'] as String
    ..otherInfo = json['otherInfo'] as String
    ..userId = json['userId'] as String
    ..userName = json['userName'] as String
    ..userNumber = json['userNumber'] as String
    ..userEmail = json['userEmail'] as String
    ..serviceCode = json['serviceCode'] as String
    ..createTime = json['createTime'] as String
    ..staffId = json['staffId'] as String
    ..staffName = json['staffName'] as String
    ..staffNumber = json['staffNumber'] as String
    ..staffEmail = json['staffEmail'] as String
    ..evaluation = json['evaluation'] as String
    ..evaluation_lv = json['evaluation_lv'] as int
    ..place = json['place'] == null
        ? null
        : PlaceModel.fromJson(json['place'] as Map<String, dynamic>)
    ..status = json['status'] as int;
}

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cagetory': instance.cagetory,
      'info': instance.info,
      'subInfo': instance.subInfo,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'addr': instance.addr,
      'url': instance.url,
      'otherInfo': instance.otherInfo,
      'userId': instance.userId,
      'userName': instance.userName,
      'userNumber': instance.userNumber,
      'userEmail': instance.userEmail,
      'serviceCode': instance.serviceCode,
      'createTime': instance.createTime,
      'staffId': instance.staffId,
      'staffName': instance.staffName,
      'staffNumber': instance.staffNumber,
      'staffEmail': instance.staffEmail,
      'evaluation': instance.evaluation,
      'evaluation_lv': instance.evaluation_lv,
      'place': instance.place,
      'status': instance.status
    };
