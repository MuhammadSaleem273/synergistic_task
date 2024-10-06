import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:random_string/random_string.dart';
import 'package:synergistic_task/wdgets/custom_textfield/custom_textfield.dart';
import 'package:synergistic_task/service/database.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Details',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CustomTextfield(hinttext: 'Name', controller: nameController),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Age',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CustomTextfield(hinttext: 'Age', controller: ageController),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CustomTextfield(
                hinttext: 'Location...', controller: locationController),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  elevation: 5, // Elevation
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), 
                  ),
                ),
                onPressed: () async {
                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> detailsinfoMap = {
                    "Name": nameController.text,
                    "Age": ageController.text,
                    "Location": locationController.text,
                    "Id": id,
                  };
                  try {
                    await DatabaseMethods().addDetails(detailsinfoMap, id);
                    Fluttertoast.showToast(
                      msg: "Details added Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Failed to add details: $e",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
