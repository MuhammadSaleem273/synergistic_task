import 'package:flutter/material.dart';
import 'package:synergistic_task/wdgets/custom_textfield/custom_textfield.dart';

class EditForm extends StatefulWidget {
   const EditForm({super.key});

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          CustomTextfield(hinttext: 'Name', controller:nameController),
          const SizedBox(height: 10,),
          CustomTextfield(hinttext: 'age', controller:ageController),
          const SizedBox(height: 10,),

          CustomTextfield(hinttext: 'Location...', controller:locationController),
          const SizedBox(height: 10,),
ElevatedButton(
  
  onPressed: (){},
  style: ElevatedButton.styleFrom(
    
    // shape: RoundedRectangleBorder(
      
    //   borderRadius: BorderRadius.circular(20.0),
    // ),
  ), child: const Text('Add'),
  )
  
        ],),
      ),
    );
  }
}
