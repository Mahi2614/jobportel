import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final salaryController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  void addJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("jobs").add({
        "title": titleController.text.trim(),
        "company": companyController.text.trim(),
        "location": locationController.text.trim(),
        "salary": salaryController.text.trim(),
        "description": descriptionController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Job Added Successfully")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding job")));
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.cyan),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.cyan, width: 2),
      ),
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Job"), backgroundColor: Colors.cyan),
      body: Container(
        color: Colors.cyan.shade50,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: fieldDecoration("Job Title"),
                validator: requiredValidator,
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: companyController,
                decoration: fieldDecoration("Company Name"),
                validator: requiredValidator,
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: locationController,
                decoration: fieldDecoration("Location"),
                validator: requiredValidator,
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: salaryController,
                decoration: fieldDecoration("Salary"),
                validator: requiredValidator,
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: fieldDecoration("Description"),
                validator: requiredValidator,
              ),
              SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Add Job",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
