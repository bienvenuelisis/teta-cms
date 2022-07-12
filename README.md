# Teta CMS

[![pub package](https://img.shields.io/pub/v/teta_cms.svg)](https://pub.dev/packages/teta_cms)

The Dart client for [Teta CMS](https://teta.so?utm_source=pub.dev&utm_medium=ClickToWebsite)

![](https://teta.so/wp-content/uploads/2022/07/bg.jpg)

## Introducing Teta CMS

Teta CMS is a low-code back-end service. We provide:

- Scalable NoSQL database
- Real-time subscriptions
- User authentication system and policies
- Perform custom queries on your collections with our [Ayaya](https://teta.so/ayaya-language/) language
- Use an easy-to-use and responsive user interface

## Getting Started

To use Teta CMS you have to create first a project on [Teta.so](https://teta.so?utm_source=pub.dev&utm_medium=ClickToWebsite)

### Compatibility

|          |  Auth              | Database | Ayaya  | Realtime   | Analytics |
| -------- | :--------------:   | :------: | :------:  | :-------: | :-------: |
| Android  |      ✅            |     ✅    |    ✅     |    ✅     |     ✅     |
| iOS      |      ✅            |     ✅    |    ✅     |    ✅     |     ✅     |
| Web      |      ✅            |     ✅    |    ✅     |    ✅     |     ✅     |
| macOS    |     Coming soon    |     ✅    |    ✅     |    ✅     |     ✅     |
| Windows  |     Coming soon    |     ✅    |    ✅     |    ✅     |     ✅     |
| Linux    |     Coming soon    |     ✅    |    ✅     |    ✅     |     ✅     |

## Examples

### Initialize
To get the credentials, go to [Teta](https://teta.so?utm_source=pub.dev&utm_medium=ClickToWebsite) > project dashboard > Getting Started

Since you call the .initialize method, you are able to use Teta.instance anywhere in your application
```dart
import 'package:teta_cms/teta_cms.dart';

void main() {
  TetaCMS.initialize(
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

Or you can use our **TetaFutureBuilder**.
It manages the cache by preventing unwanted calls.

```dart
TetaFutureBuilder(
  future: TetaCMS.instance.client.getCollection(
    collectionId, // You can retrieve this from your project dashboard
  ), 
  builder: (final context, final snap) {
    // build your widgets with snap.data as List<dynamic>
  },
);
```

TetaFutureBuilder supports any future. You can also use it to run an [Ayaya](https://teta.so/ayaya-language/) query.

### Realtime

```dart
// Stream all docs by `collectionId` ordering and filtering
final StreamController<List<dynamic>> controller = TetaCMS.instance.realtime.streamCollection(
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

// Remember to close it when you're done
controller.close();
```

Or you can use our **TetaStreamBuilder**.
It manages the cache by preventing unwanted calls and closes the stream controller at the dispose event.

```dart
TetaStreamBuilder(
  stream: TetaCMS.instance.realtime.streamCollection(
    collectionId, // You can retrieve this from your project dashboard
  ), 
  builder: (final context, final snap) {
    // build your widgets with snap.data as List<dynamic>
  },
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

The `isFirstTime` flag tells us whether the user is a first-time login, which is useful if we only need to perform actions for the first time.​

### Retrieve current user

```dart
// Get the current user
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

---
## Teta Auth configuration
Authentication with Teta CMS works by opening a browser to allow people to log in using different providers.
This method allows us to write much less code.

To open a browser and return to the application after successful login, you need to configure the deeplink in your application.

### Set your redirect URL

- Go to [app.teta.so](https://app.teta.so) > Project dashboard > Users > Config
- Fill the `Redirect Url` field (eg. com.example.app://welcome following the format `SCHEME://HOSTNAME`)

![Teta Auth redirect URL field](https://teta.so/wp-content/uploads/2022/07/Screenshot-2022-07-10-at-16.57.54.png)

### Teta social OAuth config

Follow our docs for the following OAuth providers:
- [Google](https://teta.so/login-with-google/)
- [Apple](https://teta.so/login-with-apple/)
- [GitHub](https://teta.so/login-with-github/)

### Android

Declare your Redirect Url inside the `ActivityManifest.xml` file.
In this example we are using the value `com.example.app://welcome`

```xml
<manifest ...>
  <application ...>
    <activity ...>
      <!-- ... -->

      <!-- Teta Auth Deeplink -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Your redirect URL -->
        <data
          android:scheme="com.example.app"
          android:host="welcome" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

Android docs: https://developer.android.com/training/app-links/deep-linking

### iOS

Declare your Redirect Url inside the `ios/Runner/Info.plist` file.
In this example we are using the value `com.example.app://welcome`

```xml
<plist>
<dict>
  <!-- Teta Auth Deeplink -->
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Editor</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>com.example.app</string>
      </array>
    </dict>
  </array>
  <!-- ... -->
</dict>
</plist>
```

Apple docs: https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app

### Web
Nothing needs to be set up for the Web.

### Windows, macOS, Linux
Authentication for desktop platforms is coming soon.

---

## Tutorials
This section will be updated whenever a new tutorial is released

- [Using Teta CMS for authentication in Flutter](https://teta.so/using-teta-cms-for-authentication-in-flutter/)
- [Secure your database with Teta CMS policies]( https://teta.so/policies/)

### Teta CMS is still in open alpha

- [x] Closed Alpha;
- [x] Open Alpha: We could still introduce some big changes;
- [ ] Open Alpha: Expect bugs, but it is ready for testing and side projects;
- [ ] Beta: first stable version;
- [ ] Teta: we are finally full Teta;

We are just at the beginning, and we still have a long way to go.

### Let us know what you think, we thank you for your support :)
![Reaction](https://media1.giphy.com/media/GOwylSCEZnINmgddJu/giphy.gif)