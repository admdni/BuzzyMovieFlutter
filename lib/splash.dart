import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:buzzymovies/pincode.dart';
import 'package:buzzymovies/home.dart'; // HomeScreen'i içeren dosya

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _checkScreenToOpen();
  }

  Future<void> _checkScreenToOpen() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Internet yoksa direkt HomeScreen'i aç
      _navigateToScreen(HomeScreen());
    } else {
      // JSON dosyasını çek
      var response = await http
          .get(Uri.parse('https://appledeveloper.com.tr/screen/screen.json'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['screen'] == 1) {
          _navigateToScreen(PinCodeScreen());
        } else {
          _navigateToScreen(HomeScreen());
        }
      } else {
        // JSON dosyası çekilemezse HomeScreen'i aç
        _navigateToScreen(HomeScreen());
      }
    }
  }

  void _navigateToScreen(Widget screen) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => screen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text('Buzzy Movie Community',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
