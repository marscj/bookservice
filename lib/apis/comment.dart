part of 'client.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: must_be_immutable

@JsonSerializable()
class Comment extends Equatable {
  int id;
  String comment;
  int rating;
  bool read;
  Map<String, dynamic> image;
  String create_at;
  User user;
  List<Comment> child;

  String content_type;
  int object_id;
  int user_id;

  static Comment fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  List<Object> get props => [
        id,
        image,
        tag,
        content_type,
        object_id,
      ];
}
