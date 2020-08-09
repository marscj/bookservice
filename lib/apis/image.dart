part of 'client.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: must_be_immutable

@JsonSerializable()
class SourceImage extends Equatable {
  int id;
  Map<String, String> image;
  String tag;
  String content_type;
  int object_id;

  static SourceImage fromJson(Map<String, dynamic> json) =>
      _$SourceImageFromJson(json);
  Map<String, dynamic> toJson() => _$SourceImageToJson(this);

  @override
  List<Object> get props => [
        id,
        image,
        tag,
        content_type,
        object_id,
      ];
}
