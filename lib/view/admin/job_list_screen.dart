import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_portal/view/admin/edit_job_screen.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});
  void deleteJob(String jobId) async {
    final appsSnapshot = await FirebaseFirestore.instance
        .collection("applications")
        .where("jobId", isEqualTo: jobId)
        .get();

    // Delete all applications for this job
    for (var doc in appsSnapshot.docs) {
      await FirebaseFirestore.instance
          .collection("applications")
          .doc(doc.id)
          .delete();
    }

    // Delete the job itself
    await FirebaseFirestore.instance.collection("jobs").doc(jobId).delete();
  }

  void confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Job"),
        content: Text("Are you sure you want to delete this job?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              FirebaseFirestore.instance.collection("jobs").doc(id).delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Jobs"), backgroundColor: Colors.cyan),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("jobs").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var jobs = snapshot.data!.docs;

            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index];

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      job['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade800,
                      ),
                    ),
                    subtitle: Text(job['company']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditJobScreen(job),
                              ),
                            );
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("jobs")
                                .doc(job.id)
                                .delete();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
