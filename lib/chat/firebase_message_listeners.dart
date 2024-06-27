import 'package:firebase_messaging/firebase_messaging.dart';

void _configureFCMListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle incoming data message when the app is in the foreground
    print("Data message received: ${message.data}");
    // Extract data and perform custom actions
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle incoming data message when the app is in the background or terminated
    print("Data message opened: ${message.data}");
    // Extract data and perform custom actions
  });
}
