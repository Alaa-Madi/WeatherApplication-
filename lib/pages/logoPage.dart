
import 'package:flutter/material.dart';
import 'home.dart';

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image from URL
            Image.asset(
              'assets/Logo.png',
              fit: BoxFit.cover, // Set the fit property to cover the full page
            ),

            // Button to Navigate to Home Page
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child:  ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Go to WeatherItem',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
