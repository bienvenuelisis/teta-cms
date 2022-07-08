import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:teta_cms/src/constants.dart';

/// Schema of the collection, can be public or private
enum CollectionSchema {
  /// Users will see this in Teta dashboard
  public,

  /// Users won't see this in Teta dashboard
  private,
}

/// Collection role, useful to identify a certain scope
enum CollectionRole {
  /// Generic role
  nil,

  /// Used for custom queries
  query,
}

class CollectionObject extends Equatable {
  const CollectionObject({
    required this.name,
    required this.prjId,
    this.id = '0',
    this.schema = CollectionSchema.public,
    this.role = CollectionRole.nil,
  });

  CollectionObject.fromJson({
    required final Map<String, dynamic> json,
  })  : id = json[Constants.docId] as String,
        name = json['name'] as String,
        prjId = json[Constants.prjIdKey] as int,
        schema = EnumToString.fromString(
              CollectionSchema.values,
              json['schema'] as String? ?? 'public',
            ) ??
            CollectionSchema.public,
        role = EnumToString.fromString(
              CollectionRole.values,
              json['role'] as String? ?? 'nil',
            ) ??
            CollectionRole.nil;

  final String id;
  final String name;
  final int prjId;
  final CollectionSchema schema;
  final CollectionRole? role;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        Constants.prjIdKey: prjId,
        'security': 'prj_id',
        'schema': EnumToString.convertToString(schema),
        'role': EnumToString.convertToString(role),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        prjId,
        schema,
        role,
      ];

  @override
  String toString() => 'Collection { id: $id, name: $name, prjId: $prjId }';
}
