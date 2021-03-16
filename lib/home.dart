import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Custom.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'dart:ui';

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mobile Dashboard",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ARKitController arkitController;
  ARKitNode node;
  final Color accentColor = Color(0XFFFA2B0F);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          ARKitSceneView(
            onARKitViewCreated: onARKitViewCreated,
            planeDetection: ARPlaneDetection.horizontal,
            showFeaturePoints: true,
            enableTapRecognizer: true,
            showStatistics: false,
          ),
        
          Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 16),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello 👋",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              backgroundColor: Colors.black.withOpacity(0.1)),
                        ),
                        Text(
                          "We are proximityChat",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "The better, more interactive Zoom.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/screenshot.png',
                      fit: BoxFit.cover,
                    ),
                    Column(
                      children: [
                        BoldButton(
                          text: "Join a random room",
                          icon: Icons.room,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomProject()),
                            );
                          },
                        ),
                        BoldButton(
                          text: "connect with friends",
                          icon: Icons.login,
                          press: () {
                            () => Navigator.of(context).push<void>(
                                MaterialPageRoute(
                                    builder: (c) => CustomProject()));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
  }
}

class ItemModel {
  final String title;
  final int numOne;
  final int numTwo;

  ItemModel(this.title, this.numOne, this.numTwo);
}

class BoldButton extends StatelessWidget {
  const BoldButton({
    Key key,
    this.text,
    this.icon,
    this.press,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: () {
          HapticFeedback.mediumImpact();
          press();
        },
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.green.shade300,
              size: 22.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
