import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class appointments extends StatelessWidget {
  const appointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text("All Appointments"),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Fetch appointments ordered by time (newest first)
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error loading data", style: TextStyle(color: Colors.white)));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.amber));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No appointments found.", style: TextStyle(color: Colors.white70, fontSize: 18)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              // Format Timestamp
              Timestamp? t = data['timestamp'];
              String dateString = "No Date";
              if (t != null) {
                DateTime dt = t.toDate();
                dateString = "${dt.day}/${dt.month}/${dt.year} at ${dt.hour}:${dt.minute}";
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Name and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blueGrey),
                            const SizedBox(width: 5),
                            Text(
                              data['name'] ?? 'Unknown',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        // Delete Button (Admin Feature)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('appointments').doc(doc.id).delete();
                          },
                        ),
                      ],
                    ),
                    const Divider(),

                    // Contact
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text("Contact: ${data['phone']}", style: const TextStyle(color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Problem Description
                    const Text("Problem / Request:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        data['problem'] ?? 'No details provided.',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Date Footer
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Requested: $dateString",
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}