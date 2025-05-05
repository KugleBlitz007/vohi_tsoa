# vohi_tsoa

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


- to add firebase : just run the firebase CLI tools to login and use flutterfire config to generate the proper firebase API, not forgetting to put all files with secrets in gitignore

- whenever installing new things, kill the terminal

- run flutter pub get to get all dependencies

- Current authentication methods only use email based login and and sign up, so as long as we do not use more secure authentication like google sign in or others, we can ignore firebase's warnings about authentication

-By default, Cloud Firestore in Flutter (using the cloud_firestore package) enables offline persistence. This means:
Data you have already loaded (queried or listened to) is cached locally on the device.
If you lose connection, your app can still read and query this cached data.
Writes (add/update/delete) you make while offline are queued and sent to Firestore when the connection is restored.
However:
If you try to access data that has never been loaded before (not in cache), you will not be able to retrieve it while offline.
The cache is not a full copy of your database, only what your app has accessed.
Summary:
Previously loaded data: Available offline (from cache).
New/unseen data: Not available without a connection.
Writes while offline: Queued and synced when back online.
You do NOT need to do anything extra for this basic offline support—it's enabled by default in Firestore for Flutter.
If you want to customize or ensure this behavior, let me know!

