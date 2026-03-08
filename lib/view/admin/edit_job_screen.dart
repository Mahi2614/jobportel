import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditJobScreen extends StatefulWidget {
  final DocumentSnapshot job;

  const EditJobScreen(this.job, {super.key});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  late TextEditingController titleController;
  late TextEditingController companyController;
  late TextEditingController locationController;
  late TextEditingController salaryController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.job['title']);
    companyController = TextEditingController(text: widget.job['company']);
    locationController = TextEditingController(text: widget.job['location']);
    salaryController = TextEditingController(text: widget.job['salary']);
    descriptionController = TextEditingController(
      text: widget.job['description'],
    );
  }

  void updateJob() async {
    if (titleController.text.isEmpty || companyController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Fields cannot be empty")));
      return;
    }

    await FirebaseFirestore.instance
        .collection("jobs")
        .doc(widget.job.id)
        .update({
          "title": titleController.text,
          "company": companyController.text,
          "location": locationController.text,
          "salary": salaryController.text,
          "description": descriptionController.text,
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Job Updated")));

    Navigator.pop(context);
  }

  InputDecoration fieldStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Job"), backgroundColor: Colors.cyan),

      body: Container(
        padding: EdgeInsets.all(20),

        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: fieldStyle("Job Title"),
            ),

            SizedBox(height: 15),

            TextField(
              controller: companyController,
              decoration: fieldStyle("Company Name"),
            ),

            SizedBox(height: 15),

            TextField(
              controller: locationController,
              decoration: fieldStyle("Location"),
            ),

            SizedBox(height: 15),

            TextField(
              controller: salaryController,
              decoration: fieldStyle("Salary"),
            ),

            SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: fieldStyle("Description"),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: updateJob,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text("Update Job", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
