import 'package:flutter_test/flutter_test.dart';
import 'firebase_test.dart'; // Import the mock initialization file
import 'package:distracted_driving/main.dart';

void main() {
  setUpAll(() async {
    await initializeFirebaseForTesting();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
  });
}
