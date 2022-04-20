// ignore_for_file: camel_case_types

abstract class StreamAction {
  // ignore: avoid_positional_boolean_parameters
  StreamAction(final String _type, final bool _targetDocument) {
    type = _type;
    targetDocument = _targetDocument;
  }

  late String type;
  late bool targetDocument;
}

class CREATE_COLLECTION extends StreamAction {
  CREATE_COLLECTION() : super('CREATE_COLLECTION', false);
}

class DELETE_COLLECTION extends StreamAction {
  DELETE_COLLECTION() : super('DELETE_COLLECTION', false);
}

class UPDATE_COLLECTION extends StreamAction {
  UPDATE_COLLECTION() : super('UPDATE_COLLECTION', false);
}

class CREATE_DOCUMENT extends StreamAction {
  CREATE_DOCUMENT() : super('CREATE_DOCUMENT', true);
}

class DELETE_DOCUMENT extends StreamAction {
  DELETE_DOCUMENT() : super('DELETE_DOCUMENT', true);
}

class UPDATE_DOCUMENT extends StreamAction {
  UPDATE_DOCUMENT() : super('UPDATE_DOCUMENT', true);
}
