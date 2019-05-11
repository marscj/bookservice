import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@JsonSerializable()
class PlaceModel {

  double latitude;
  double longitude;
  String id;
  String name;
  String address;
  
  PlaceModel();

  @override
  String toString() {
    return '${name ?? ''} / ${address ?? ''}';
  }

  factory PlaceModel.fromJson(Map<String, dynamic> json) => _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}

@JsonSerializable()
class CustomerAddressModel {
  String uuid;
  // String country = '';
  String city = '';
  String community = '';
  String streetName = '';
  int type;
  String villaNo = '';

  PlaceModel place;
  int addrType = 0;

  CustomerAddressModel() {
    uuid = new Uuid().v1();
  }

  String toTitle() {
    // return '$country / $city';
    return '$city / ';
  }

  String toSubTitle() { 
    return '${community == null || community == '' ? '' : community + ' / '}${streetName == null || streetName == ''? '' : streetName + ' / '}${villaNo == null || villaNo == ''? '' : villaNo + ' / '}';
  }

  String toAllTitle() {
    if (addrType == 0) {
      return toTitle() + toSubTitle() ;
    }
    return place?.toString();
  }

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) => _$CustomerAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerAddressModelToJson(this);
}

@JsonSerializable()
class CompanyAddressModel {
  String uuid;
  // String country = '';
  String city = '';
  String community = '';
  String streetName = '';
  String buildingName = '';
  String officeNo = '';
  PlaceModel place;
  int addrType = 0;

  CompanyAddressModel() {
    uuid = new Uuid().v1();
  }

  String toTitle() {
    // return '$country / $city';
    return '$city / ';
  }

  String toSubTitle() {
    return '${community == null || community == '' ? '' : community + ' / '}${streetName == null || streetName == ''? '' : streetName + ' / '}${buildingName == null || buildingName == ''? '' : buildingName + ' / '}${officeNo == null || officeNo == ''? '' : officeNo + ' / '}'; 
  }

  String toAllTitle() {
    if (addrType == 0) {
      return toTitle() + toSubTitle() ;
    }
    return place?.toString();
  }

  factory CompanyAddressModel.fromJson(Map<String, dynamic> json) => _$CompanyAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyAddressModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class SkillModel {
  bool useful = false;
  String name;
  String other;

  SkillModel(this.name);

  factory SkillModel.fromJson(Map<String, dynamic> json) => _$SkillModelFromJson(json);

  Map<String, dynamic> toJson() => _$SkillModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class DayOfTimeModel {
  String form;
  String to;

  DayOfTimeModel();

  factory DayOfTimeModel.fromJson(Map<String, dynamic> json) => _$DayOfTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayOfTimeModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class WorkTimeModel {
  String name;
  bool useful = false;
  DayOfTimeModel time;

  WorkTimeModel(this.name) : time = new DayOfTimeModel();

  factory WorkTimeModel.fromJson(Map<String, dynamic> json) => _$WorkTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkTimeModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class FreelancerModel {
  // String country = '';
  String city = '';
  String community = '';
  String streetName = '';
  String villaNo = '';

  List<SkillModel> skills ;

  List<WorkTimeModel> workTimes;

  FreelancerModel();

  String toAllTitle() {
    // return '$country / $city / ${community == null || community == '' ? '' : community + ' / '}${streetName == null || streetName == ''? '' : streetName + ' / '}${villaNo == null || villaNo == ''? '' : villaNo + ' / '}';
    return '$city / ${community == null || community == '' ? '' : community + ' / '}${streetName == null || streetName == ''? '' : streetName + ' / '}${villaNo == null || villaNo == ''? '' : villaNo + ' / '}';
  }

  factory FreelancerModel.fromJson(Map<String, dynamic> json) => _$FreelancerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreelancerModelToJson(this);
}

@JsonSerializable()
class ProfileModel {
  String userId;
  String displayName;
  String email;
  bool isEmailVerified;
  String phoneNumber;

  ProfileModel();

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class UserModel {
  ProfileModel profile;
  int category;
  bool isAdmin;
  bool isEnable;
  String defAddr;
  ContractModel contract;
  FreelancerModel freelancerData;
  List<CustomerAddressModel> customerData;
  List<CompanyAddressModel> companyData;

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
} 

@JsonSerializable()
class JobModel {
  String date;
  String card;
  int type;
  String unit;
  String notes;

  JobModel();

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobModelToJson(this);
}

@JsonSerializable()
class ContractModel {
  int option;
  String dateOfIssue;
  String dateOfExpiry;
  List<int> visits = [0, 0, 0, 0, 0, 0];
  List<JobModel> jobs;

  ContractModel();

  factory ContractModel.fromJson(Map<String, dynamic> json) => _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);
}

@JsonSerializable()
class WhiteListModel {
  String name;
  String phoneNumber;
  int category;
  bool isAdmin;

  WhiteListModel();

  factory WhiteListModel.fromJson(Map<String, dynamic> json) => _$WhiteListModelFromJson(json);

  Map<String, dynamic> toJson() => _$WhiteListModelToJson(this);
}
