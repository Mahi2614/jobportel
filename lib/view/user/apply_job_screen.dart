import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplyJobScreen extends StatefulWidget {
  final job;
  const ApplyJobScreen(this.job, {super.key});

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final resumeController = TextEditingController();
  bool isSubmitting = false;
  void applyJob() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        resumeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      var user = FirebaseAuth.instance.currentUser;

      // Check if already applied
      var snapshot = await FirebaseFirestore.instance
          .collection("applications")
          .where("jobId", isEqualTo: widget.job.id)
          .where("userId", isEqualTo: user!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You have already applied for this job")),
        );
        setState(() => isSubmitting = false);
        return;
      }

      // Add application
      await FirebaseFirestore.instance.collection("applications").add({
        "jobTitle": widget.job['title'],
        "company": widget.job['company'],
        "name": nameController.text,
        "email": emailController.text,
        "resume": resumeController.text,
        "jobId": widget.job.id,
        "userId": user.uid,
        "time": Timestamp.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Application Submitted")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit application: $e")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.cyan.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.cyan, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for Job"),
        backgroundColor: Colors.cyan.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.black26,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Applying for",
                      style: TextStyle(
                        color: Colors.cyan.shade700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.job['title'],
                      style: TextStyle(
                        color: Colors.cyan.shade900,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.job['company'],
                      style: TextStyle(
                        color: Colors.cyan.shade800,
                        fontSize: 16,
                      ),
                    ),
                    Divider(height: 32, color: Colors.cyan.shade200),

                    // Name
                    TextField(
                      controller: nameController,
                      decoration: fieldDecoration("Full Name"),
                    ),
                    SizedBox(height: 16),

                    // Email
                    TextField(
                      controller: emailController,
                      decoration: fieldDecoration("Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),

                    // Resume
                    TextField(
                      controller: resumeController,
                      decoration: fieldDecoration("Resume Link / Google Drive"),
                    ),
                    SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : applyJob,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSubmitting
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Submit Application",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
