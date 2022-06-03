import 'package:json_annotation/json_annotation.dart';
part 'blogModel.g.dart';
@JsonSerializable()
class Blogmodel {
  @JsonKey(name:'_id')
  String? id;
  String? title;
  String? catagory;
  String? description;
  String? image;
  String? date;

  Blogmodel({this.id, this.title, this.catagory, this.description, this.image});

  factory Blogmodel.fromJson(Map<String,dynamic> obj)=> _$BlogmodelFromJson(obj);
  Map<String,dynamic> toJson()=> _$BlogmodelToJson(this);
}
