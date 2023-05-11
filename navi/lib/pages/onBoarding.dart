import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_test/flutter_test.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  // a custom widget
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 30),
          // alttan 80 birimlik boşluk açtık.
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(
                () => isLastPage = index == 2,
              );
            },

            children: [
              buildPage(
                  color: Colors.green.shade200,
                  urlImage: 'assets/intro5.jpeg',
                  title: "Welcome To N.A.V.I",
                  subtitle: '(Navigation Assistance For Visually Impaired)'),
              buildPage(
                  color: Colors.green.shade200,
                  urlImage: 'assets/intro6.jpeg',
                  title: "What is N.A.V.I?",
                  subtitle:
                  'Navigation Assistance for the Visually Impaired, is a mobile application aimed to assist visually impaired people in reaching their destination by avoiding any potential obstacles such as cars, trees, bicycles, etc'),
              buildPage(
                  color: Colors.green.shade200,
                  urlImage: 'assets/intro7.jpeg',
                  title: "How to Use?",
                  subtitle:
                  'When using the app, the user needs to hold their phones on chest level and allow the app to access the camera.'),
            ],

          ),
        ),
        bottomSheet: isLastPage
            ? TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    primary: Colors.white,
                    backgroundColor: Colors.purple,
                    minimumSize: const Size.fromHeight(70)),
                child:
                    const Text('Get Started', style: TextStyle(fontSize: 24)),
                onPressed: () async {
                  Navigator.popAndPushNamed(context, '/navigate');
                },
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 70,
                color: Colors.purple,
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => _controller.jumpToPage(2),
                          child: const Text(
                              'SKIP')), // directly go to the last page.

                      Center(
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: 3, // dot numbers
                          effect: const WormEffect(
                            spacing: 17,
                            dotColor: Colors.black,
                            activeDotColor: Colors.greenAccent,
                          ),
                          onDotClicked: (index) => _controller.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn),
                        ),
                      ),
                      TextButton(
                          child: const Text('NEXT'),
                          onPressed: (() => _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut))),
                    ],
                  ),
                ),
              ),
      );
}


