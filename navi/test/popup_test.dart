
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('AlertPopUp displays alert dialog with message',
          (WidgetTester tester) async {
        // Build the widget tree
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      alertPopUp(context, 'Test message');
                    },
                    child: const Text('Show Alert'),
                  );
                },
              ),
            ),
          ),
        );

        // Tap the button to show the alert dialog
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Check that the alert dialog is displayed with the correct message
        expect(find.text('Alert'), findsOneWidget);
        expect(find.text('Test message'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);

        // Tap the OK button to dismiss the alert dialog
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Check that the alert dialog is no longer displayed
        expect(find.byType(AlertDialog), findsNothing);
      });
}

void alertPopUp(BuildContext context, message) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Alert'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
