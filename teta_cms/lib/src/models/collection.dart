import 'package:equatable/equatable.dart';
import 'package:teta_cms/src/constants.dart';

class CollectionObject extends Equatable {
  const CollectionObject({
    required this.name,
    required this.prjId,
    this.id = '0',
  });

  CollectionObject.fromJson({
    required final Map<String, dynamic> json,
  })  : id = json[Constants.docId] as String,
        name = json['name'] as String,
        prjId = json[Constants.prjIdKey] as int;

  final String id;
  final String name;
  final int prjId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        Constants.prjIdKey: prjId,
        'security': 'prj_id',
      };

  @override
  List<Object?> get props => [
        id,
        name,
        prjId,
      ];

  @override
  String toString() => 'Collection { id: $id, name: $name, prjId: $prjId }';
}
