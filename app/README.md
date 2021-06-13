# Fluttermin

A Single Page Application starter for Android, iOS and Web
with [Flutter](https://flutter.dev) and [PostgREST](https://postgrest.org/en/stable/).

## Requirements

* Flutter >= 2.x
* PostgREST >= 7.0.1 (check server/ directory for more information)

## Run Web

The app defaults to Flutter Web.

```bash
flutter run -d chrome
```

## Testing Android, iOS with ngrok

For Andorid, iOS testing the _isApp flag needs to flipped in lib/api.dart.

To test the mobile app, postgrest has to be configured to run on a local network
instead of the default localhost:3000.

Then [ngrok](https://ngrok.com/download) can be used to proxy traffic
from mobile app to postgrest running locally on localhost:3000.

After having started postgrest via __server/pgrest.sh__ start ngrok:

```bash
ngrok http 3000
```

Paste ngrok address into lib/api.dart's variable _baseUrlApp, save and run the app.
