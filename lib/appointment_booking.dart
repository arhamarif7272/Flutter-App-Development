import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Database
import 'package:firebase_auth/firebase_auth.dart';

import 'anime.dart'; // User ID

class appointment_booking extends StatefulWidget {
  const appointment_booking({super.key});

  @override
  State<appointment_booking> createState() => _appointment_bookingState();
}

class _appointment_bookingState extends State<appointment_booking> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  // Submit Function
  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String uid = currentUser?.uid ?? 'guest';

      // Save to Firestore 'appointments' collection
      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': uid,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'problem': _problemController.text.trim(),
        'status': 'Pending', // Default status
        'timestamp': FieldValue.serverTimestamp(), // Save current time
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment Request Submitted!'), backgroundColor: Colors.green),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const anime()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Helper for Input Fields
  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blueGrey),
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 40, color: Colors.black),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Describe your issue below. Admin will contact you shortly.",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Inputs
              const Text("Your Information", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              _buildInputField(label: "Full Name", icon: Icons.person, controller: _nameController),
              _buildInputField(label: "Phone Number", icon: Icons.phone, controller: _phoneController, type: TextInputType.phone),

              const SizedBox(height: 15),
              const Text("Issue Details", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              _buildInputField(label: "Describe your problem...", icon: Icons.comment, controller: _problemController, maxLines: 5),

              const SizedBox(height: 30),

              // Submit Button
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: _submitAppointment,
                  child: const Center(
                    child: Text(
                      "Submit Request",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}