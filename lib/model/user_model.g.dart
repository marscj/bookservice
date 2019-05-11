// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) {
  return PlaceModel()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..address = json['address'] as String;
}

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'id': instance.id,
      'name': instance.name,
      'address': instance.address
    };

CustomerAddressModel _$CustomerAddressModelFromJson(Map<String, dynamic> json) {
  return CustomerAddressModel()
    ..uuid = json['uuid'] as String
    ..city = json['city'] as String
    ..community = json['community'] as String
    ..streetName = json['streetName'] as String
    ..type = json['type'] as int
    ..villaNo = json['villaNo'] as String
    ..place = json['place'] == null
        ? null
        : PlaceModel.fromJson(json['place'] as Map<String, dynamic>)
    ..addrType = json['addrType'] as int;
}

Map<String, dynamic> _$CustomerAddressModelToJson(
        CustomerAddressModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'city': instance.city,
      'community': instance.community,
      'streetName': instance.streetName,
      'type': instance.type,
      'villaNo': instance.villaNo,
      'place': instance.place,
      'addrType': instance.addrType
    };

CompanyAddressModel _$CompanyAddressModelFromJson(Map<String, dynamic> json) {
  return CompanyAddressModel()
    ..uuid = json['uuid'] as String
    ..city = json['city'] as String
    ..community = json['community'] as String
    ..streetName = json['streetName'] as String
    ..buildingName = json['buildingName'] as String
    ..officeNo = json['officeNo'] as String
    ..place = json['place'] == null
        ? null
        : PlaceModel.fromJson(json['place'] as Map<String, dynamic>)
    ..addrType = json['addrType'] as int;
}

Map<String, dynamic> _$CompanyAddressModelToJson(
        CompanyAddressModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'city': instance.city,
      'community': instance.community,
      'streetName': instance.streetName,
      'buildingName': instance.buildingName,
      'officeNo': instance.officeNo,
      'place': instance.place,
      'addrType': instance.addrType
    };

SkillModel _$SkillModelFromJson(Map<String, dynamic> json) {
  return SkillModel(json['name'] as String)
    ..useful = json['useful'] as bool
    ..other = json['other'] as String;
}

Map<String, dynamic> _$SkillModelToJson(SkillModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('useful', instance.useful);
  writeNotNull('name', instance.name);
  writeNotNull('other', instance.other);
  return val;
}

DayOfTimeModel _$DayOfTimeModelFromJson(Map<String, dynamic> json) {
  return DayOfTimeModel()
    ..form = json['form'] as String
    ..to = json['to'] as String;
}

Map<String, dynamic> _$DayOfTimeModelToJson(DayOfTimeModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('form', instance.form);
  writeNotNull('to', instance.to);
  return val;
}

WorkTimeModel _$WorkTimeModelFromJson(Map<String, dynamic> json) {
  return WorkTimeModel(json['name'] as String)
    ..useful = json['useful'] as bool
    ..time = json['time'] == null
        ? null
        : DayOfTimeModel.fromJson(json['time'] as Map<String, dynamic>);
}

Map<String, dynamic> _$WorkTimeModelToJson(WorkTimeModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('useful', instance.useful);
  writeNotNull('time', instance.time);
  return val;
}

FreelancerModel _$FreelancerModelFromJson(Map<String, dynamic> json) {
  return FreelancerModel()
    ..city = json['city'] as String
    ..community = json['community'] as String
    ..streetName = json['streetName'] as String
    ..villaNo = json['villaNo'] as String
    ..skills = (json['skills'] as List)
        ?.map((e) =>
            e == null ? null : SkillModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..workTimes = (json['workTimes'] as List)
        ?.map((e) => e == null
            ? null
            : WorkTimeModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$FreelancerModelToJson(FreelancerModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('city', instance.city);
  writeNotNull('community', instance.community);
  writeNotNull('streetName', instance.streetName);
  writeNotNull('villaNo', instance.villaNo);
  writeNotNull('skills', instance.skills);
  writeNotNull('workTimes', instance.workTimes);
  return val;
}

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel()
    ..userId = json['userId'] as String
    ..displayName = json['displayName'] as String
    ..email = json['email'] as String
    ..isEmailVerified = json['isEmailVerified'] as bool
    ..phoneNumber = json['phoneNumber'] as String;
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'isEmailVerified': instance.isEmailVerified,
      'phoneNumber': instance.phoneNumber
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel()
    ..profile = json['profile'] == null
        ? null
        : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
    ..category = json['category'] as int
    ..isAdmin = json['isAdmin'] as bool
    ..defAddr = json['defAddr'] as String
    ..contract = json['contract'] == null
        ? null
        : ContractModel.fromJson(json['contract'] as Map<String, dynamic>)
    ..freelancerData = json['freelancerData'] == null
        ? null
        : FreelancerModel.fromJson(
            json['freelancerData'] as Map<String, dynamic>)
    ..customerData = (json['customerData'] as List)
        ?.map((e) => e == null
            ? null
            : CustomerAddressModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..companyData = (json['companyData'] as List)
        ?.map((e) => e == null
            ? null
            : CompanyAddressModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'profile': instance.profile,
      'category': instance.category,
      'isAdmin': instance.isAdmin,
      'defAddr': instance.defAddr,
      'contract': instance.contract,
      'freelancerData': instance.freelancerData,
      'customerData': instance.customerData,
      'companyData': instance.companyData
    };

JobModel _$JobModelFromJson(Map<String, dynamic> json) {
  return JobModel()
    ..date = json['date'] as String
    ..card = json['card'] as String
    ..type = json['type'] as int
    ..unit = json['unit'] as String
    ..notes = json['notes'] as String;
}

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'date': instance.date,
      'card': instance.card,
      'type': instance.type,
      'unit': instance.unit,
      'notes': instance.notes
    };

ContractModel _$ContractModelFromJson(Map<String, dynamic> json) {
  return ContractModel()
    ..option = json['option'] as int
    ..dateOfIssue = json['dateOfIssue'] as String
    ..dateOfExpiry = json['dateOfExpiry'] as String
    ..visits = (json['visits'] as List)?.map((e) => e as int)?.toList()
    ..jobs = (json['jobs'] as List)
        ?.map((e) =>
            e == null ? null : JobModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ContractModelToJson(ContractModel instance) =>
    <String, dynamic>{
      'option': instance.option,
      'dateOfIssue': instance.dateOfIssue,
      'dateOfExpiry': instance.dateOfExpiry,
      'visits': instance.visits,
      'jobs': instance.jobs
    };

WhiteListModel _$WhiteListModelFromJson(Map<String, dynamic> json) {
  return WhiteListModel()
    ..name = json['name'] as String
    ..phoneNumber = json['phoneNumber'] as String
    ..category = json['category'] as int
    ..isAdmin = json['isAdmin'] as bool;
}

Map<String, dynamic> _$WhiteListModelToJson(WhiteListModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'category': instance.category,
      'isAdmin': instance.isAdmin
    };
