// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blogModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blogmodel _$BlogmodelFromJson(Map<String, dynamic> json) => Blogmodel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      catagory: json['catagory'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
    )..date = json['date'] as String?;

Map<String, dynamic> _$BlogmodelToJson(Blogmodel instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'catagory': instance.catagory,
      'description': instance.description,
      'image': instance.image,
      'date': instance.date,
    };
