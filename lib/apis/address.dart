part of 'client.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: must_be_immutable

@JsonSerializable()
class Address extends Equatable {
  int id;
  bool defAddr;
  bool onMap;
  int model;
  int style;
  String city;
  String community;
  String street;
  String building;
  String roomNo;
  double lat;
  double lng;
  String address;

  Address({
    this.id,
    this.defAddr,
    this.onMap,
    this.model,
    this.style,
    this.city,
    this.community,
    this.street,
    this.building,
    this.roomNo,
    this.lat,
    this.lng,
    this.address,
  });

  static Address fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String get toTitle => onMap
      ? address
      : '${roomNo + ' / ' + building + ' / ' + street + ' / ' + community + ' / ' + city}';

  @override
  List<Object> get props => [
        id,
        defAddr,
        onMap,
        model,
        style,
        city,
        community,
        street,
        building,
        roomNo,
        lat,
        lng,
        address
      ];
}
