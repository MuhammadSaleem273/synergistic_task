import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergistic_task/wdgets/custom_textfield/custom_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController=TextEditingController();
  void resetPassword(String email) {
  if (email.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Please write an email to reset the password.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
  FirebaseAuth.instance
      .sendPasswordResetEmail(email: email)
      .then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email successfully sent'),
      ),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send email: ${error.toString()}'),
      ),
    );
  });
}

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextfield(hinttext: 'Enter email address', controller: emailController),
          const SizedBox(height: 10,),
          ElevatedButton(
                    onPressed: ()  {
                      resetPassword(emailController.text.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Update',style: TextStyle(color: Colors.black),),
                  ),
        ],
      ),
    );
  }
}
