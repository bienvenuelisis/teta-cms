# Teta CMS

[![pub package](https://img.shields.io/pub/v/teta_cms.svg)](https://pub.dev/packages/teta_cms)

The Dart client for [Teta CMS](https://teta.so)

### Introducing Teta CMS

Teta CMS is a low-code back-end service. We provide:

- Scalable NoSQL database
- Real-time subscriptions
- User authentication system and policies
- Perform custom queries on your collections with our [Ayaya](https://teta.so/ayaya-language/) language
- Use an easy-to-use and responsive user interface

## Getting Started

To use Teta CMS you have to create first a project on [Teta.so](https://teta.so)

### Compatibility

|          |  Auth              | Database | Ayaya  | Real-time   | Analytics |
| -------- | :--------------:   | :------: | :------:  | :-------: | :-------: |
| Android  |      ✅            |     ✅    |    ✅     |    ✅     |     ✅     |
| iOS      |      ✅            |     ✅    |    ✅     |    ✅     |     ✅     |
| Web      |      ✅            |     ✅    |    ✅     |    ✅     |     ✅     |
| macOS    |     Coming soon    |     ✅    |    ✅     |    ✅     |     ✅     |
| Windows  |     Coming soon    |     ✅    |    ✅     |    ✅     |     ✅     |
| Linux    |     Coming soon    |     ✅    |    ✅     |    ✅     |     ✅     |

## Examples

### Initialize
To get the credentials, go to [Teta](https://teta.so) > project dashboard > Getting Started

Since you call the .initialize method, you are able to use Teta.instance anywhere in your application
```dart
import 'package:teta_cms/teta_cms.dart';

Future main() async {
  await TetaCMS.initialize(
    token: prjToken,
    prjId: prjId,
  );
  
  runApp(
    // Your app...
  );
}
```
### Database with custom query

Making a query with the [Ayaya](https://teta.so/ayaya-language/) language

```dart
// Fetch all docs in `CollectionA` created less than a week, ordering by `created_at`
final response = await TetaCMS.instance.client.query(
  r'''
    MATCH name EQ CollectionA;
    IN docs;
    MATCH created_at GT DATESUB($now $week);
    SORT created_at -1;
    LIMIT 20;
  ''', 
);

// Check if it returns an error
if (response.error != null) {
  debugPrint('${response.error?.message}');
} else {
  // Safe to use response.data 🎉
}
```

### Fetch docs

```dart
// Fetch all docs by `collectionId`, ordering and filtering
final List<dynamic> response = await TetaCMS.instance.client.getCollection(
  collectionId, // You can retrieve this from your project dashboard
  limit: 10,
  page: 0,
  showDrafts: false,
  filters: [
    Filter(
      'Key',
      'Value',
      type: FilterType.like,
    ),
  ],
);
```

### Stream

```dart
// Stream all docs by `collectionId` ordering and filtering
final Stream<List<dynamic>> stream = TetaCMS.instance.realtime.streamCollection(
  collectionId, // You can retrieve this from your project dashboard
  limit: 10,
  page: 0,
  showDrafts: false,
  filters: [
    Filter(
      'Key',
      'Value',
      type: FilterType.like,
    ),
  ],
);
```

### Social authentication

```dart
// Sign up user with Apple OAuth provider
TetaCMS.instance.auth.signIn(
  provider: TetaProvider.apple,
  onSuccess: (final isFirstTime) async {
    // Success 🎉
  );
);
```

### Retrieve current user

```dart
// Sign up user with Apple OAuth provider
final user = await TetaCMS.instance.auth.user.get;
if (user?.isLogged) {
  // The user is logged 🎉
} else {
  // There is no current user
}
```

### Sign Out

```dart
await TetaCMS.instance.auth.signOut();
```

### Teta CMS is still in open alpha

- [x] Closed Alpha;
- [x] Open Alpha: We could still introduce some big changes;
- [ ] Open Alpha: Expect bugs, but it is ready for testing and side projects;
- [ ] Beta: first stable version;
- [ ] Teta: we are finally full Teta;

We are just at the beginning, and we still have a long way to go.

### Let us know what you think, we thank you for your support :)
![Reaction](https://media1.giphy.com/media/GOwylSCEZnINmgddJu/giphy.gif)