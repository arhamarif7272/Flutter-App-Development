import 'package:flutter/material.dart';

class termandpolicies extends StatelessWidget {
  const termandpolicies({super.key});

  // Helper widget to build a policy section
  Widget _buildPolicySection({required String title, required String content, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.amber, size: 28),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.5, // Better readability
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text(
          "Terms & Policies",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header / Intro
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, size: 30, color: Colors.black),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Please read our terms carefully before using the Abdul Latif Commission Shop services.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // 1. Commission Policy
          _buildPolicySection(
            title: "Commission & Charges",
            icon: Icons.monetization_on,
            content:
            "1. A standard commission rate of 4% is applied to the total sale price of every transaction.\n\n"
                "2. Out of the collected commission, 25% is allocated for labor costs and operational handling, while the remaining 75% is retained as platform revenue.\n\n"
                "3. Sellers agree to this deduction automatically upon listing a product.",
          ),

          // 2. User Responsibilities
          _buildPolicySection(
            title: "User Responsibilities",
            icon: Icons.person_outline,
            content:
            "• Sellers must ensure that the agricultural products listed (Wheat, Rice, Corn, etc.) are accurate in weight and quality.\n\n"
                "• Buyers must verify delivery details before confirming an order.\n\n"
                "• Any fraudulent activity or misrepresentation will result in immediate account suspension.",
          ),

          // 3. Privacy Policy
          _buildPolicySection(
            title: "Privacy & Data Usage",
            icon: Icons.security,
            content:
            "We respect your privacy. Your personal data, including bank account details and contact information, is stored securely in our database.\n\n"
                "We do not share your personal information with third parties without your consent, except for logistical partners required to fulfill your delivery.",
          ),

          // 4. Payments
          _buildPolicySection(
            title: "Payments & Refunds",
            icon: Icons.payment,
            content:
            "• All payments processed via Card are subject to bank verification.\n\n"
                "• Cash on Delivery (COD) is available for specific regions.\n\n"
                "• Disputes regarding quality must be raised within 24 hours of delivery through the 'Book Appointment' feature.",
          ),

          // Footer
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Last updated: December 2025",
              style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}