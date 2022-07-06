# Teta CMS

The Dart client for Teta CMS

### Introducing Teta CMS

Teta CMS is a low-code back-end service. We provide:

- NoSQL scalable database
- Real-time subscriptions
- User authentication system and policies
- Perform custom queries on your collections with our Ayaya language
- Use a easy to use, responsive UI
- Control what your users do in your apps tracking events

## Examples

### Initialize
```dart
import 'package:teta_cms/teta_cms.dart';

main() async {
  await TetaCMS.initialize(
    token: prjToken,
    prjId: prjId,
  );
  
  runApp(
    // Your app...
  );
}
```

Since you call the .initialize method, you are able to use Teta.instance everywhere in your app

### Database

```dart
// Fetch all docs in `CollectionA` created less than a week, ordering by `created_at`
final response = await TetaCMS.instance.client.customQuery(
  '''
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
    )
  ],
);
```

### Social authentication

```dart
// Sign up user with Apple OAuth provider
TetaCMS.instance.auth.signIn(
  provider: TetaProvider.apple,
  onSuccess: () async {
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

- [x] We still could introduce some huge changes;
- [x] Expect bugs, but it is ready for testing and side projects;
- [ ] Beta: first stable version;
- [ ] Teta: we are finally full Teta;
