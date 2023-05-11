import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:navi/pages/onBoarding.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:navi/pages/onBoarding.dart';


Widget buildPage({
  required Color color,
  required String urlImage,
  required String title,
  required String subtitle,
}) =>
    Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            urlImage, // Image
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const SizedBox(
            height: 64,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87, // Title
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(),
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

void main() {
  testWidgets('BuildPage widget displays title and subtitle', (WidgetTester tester) async {
    const String testTitle = 'Test Title';
    const String testSubtitle = 'Test Subtitle';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildPage(
            color: Colors.blue,
            urlImage: 'assets/intro1.jpg',
            title: testTitle,
            subtitle: testSubtitle,
          ),
        ),
      ),
    );

    final titleFinder = find.text(testTitle);
    final subtitleFinder = find.text(testSubtitle);

    expect(titleFinder, findsOneWidget);
    expect(subtitleFinder, findsOneWidget);
  });
}

