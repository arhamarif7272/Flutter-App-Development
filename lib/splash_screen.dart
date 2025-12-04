import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comission_shop/login.dart'; // To access UserRoleManager
// IMPORTANT: Ensure this import points to your generated file location
import 'firebase_options.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _statusMessage = "Loading...";
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    try {
      // 1. Initialize Firebase HERE (while showing UI) to prevent white screen
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // 2. Artificial Delay (for drama/logo visibility)
      // We run this in parallel with data fetching if possible, but sequential is safer for splash logic
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      // 3. Check Authentication State
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        setState(() => _statusMessage = "Fetching User Profile...");

        // 4. User is Logged In: Fetch Role from Database
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

          if (userDoc.exists) {
            // Set the global role variable so the Drawer knows what to show
            UserRoleManager.currentRole = userDoc.get('role');
          }
        } catch (e) {
          debugPrint("Error fetching role: $e");
          // If fetch fails, we might still want to let them in, or show error
        }

        // Navigate to Home
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // 5. Not Logged In: Navigate to Login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      }

    } catch (e) {
      // Catch Initialization Errors (Fixes White Screen of Death)
      setState(() {
        _hasError = true;
        _statusMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                height: 240,
                width: 240,
                image: AssetImage('logos.png'),
              ),
              const SizedBox(height: 20),
              // 🎯 USING ICON (To prevent asset loading errors causing white screen)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Icon(
                      Icons.storefront_outlined,
                      size: 75,
                      color: Colors.amber
                  ),


                  const Text(
                    "Abdul Latif\nCommission Shop",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 40),

              // Show Error or Loading Indicator
              if (_hasError)
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                )
              else ...[
                const CircularProgressIndicator(color: Colors.amber),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}