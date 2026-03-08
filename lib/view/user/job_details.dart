import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/view/user/apply_job_screen.dart';

class JobDetails extends StatelessWidget {
  final job;
  const JobDetails(this.job, {super.key});

  Widget infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyan),
        SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
      ],
    );
  }

  Future<bool> checkApplied(String jobId) async {
    var user = FirebaseAuth.instance.currentUser;
    var snapshot = await FirebaseFirestore.instance
        .collection("applications")
        .where("jobId", isEqualTo: jobId)
        .where("userId", isEqualTo: user!.uid)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job['title']), backgroundColor: Colors.cyan),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan.shade800,
                          ),
                        ),
                        SizedBox(height: 15),
                        infoRow(Icons.business, "Company: ${job['company']}"),
                        SizedBox(height: 10),
                        infoRow(
                          Icons.location_on,
                          "Location: ${job['location']}",
                        ),
                        SizedBox(height: 10),
                        infoRow(
                          Icons.currency_rupee,
                          "Salary: ${job['salary']}",
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Job Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          job['description'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Apply Button / Applied Status
            FutureBuilder<bool>(
              future: checkApplied(job.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: null,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                bool applied = snapshot.data!;
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: applied
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ApplyJobScreen(job),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: applied
                          ? Colors.grey.shade400
                          : Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      applied ? "Applied" : "Apply Job",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
