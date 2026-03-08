import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  Future<void> openResume(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Cannot open resume")));
    }
  }

  void removeApplication(String id, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("applications")
        .doc(id)
        .delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Application removed")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Applications"),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("applications")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var applications = snapshot.data!.docs;

          if (applications.isEmpty)
            return Center(child: Text("No Applications Yet"));

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              var app = applications[index];
              final name = app.data().containsKey('name')
                  ? app['name']
                  : 'Unknown';

              return Dismissible(
                key: Key(app.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Delete Application"),
                      content: Text(
                        "Are you sure you want to remove this applicant?",
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.cyan),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  removeApplication(app.id, context);
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade800,
                      ),
                    ),
                    subtitle: Text("${app['jobTitle']} at ${app['company']}"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(name),
                              // IconButton(
                              //   icon: Icon(Icons.delete, color: Colors.red),
                              //   onPressed: () {
                              //     removeApplication(app.id, context);
                              //     Navigator.pop(context);
                              //   },
                              // ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email: ${app['email']}"),
                              Text("Job: ${app['jobTitle']}"),
                              Text("Company: ${app['company']}"),
                              SizedBox(height: 10),
                              TextButton.icon(
                                onPressed: () =>
                                    openResume(app['resume'], context),
                                icon: Icon(
                                  Icons.description,
                                  color: Colors.cyan,
                                ),
                                label: Text("View Resume"),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
