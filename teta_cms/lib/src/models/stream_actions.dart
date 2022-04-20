// ignore_for_file: camel_case_types

class StreamAction {
  // ignore: avoid_positional_boolean_parameters
  const StreamAction(this.type, this.targetDocument);

  final String type;
  final bool targetDocument;

  static const StreamAction all = StreamAction('ALL', false);

  static const StreamAction createCollection =
      StreamAction('CREATE_COLLECTION', false);

  static const StreamAction deleteCollection =
      StreamAction('CREATE_COLLECTION', false);

  static const StreamAction updateCollection =
      StreamAction('UPDATE_COLLECTION', false);

  static const StreamAction createDoc = StreamAction('CREATE_DOCUMENT', true);

  static const StreamAction deleteDoc = StreamAction('DELETE_DOCUMENT', true);

  static const StreamAction updateDoc = StreamAction('UPDATE_DOCUMENT', true);
}
