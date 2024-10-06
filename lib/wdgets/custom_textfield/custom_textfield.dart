import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String hinttext;
  final TextEditingController controller;
  final String? Function(String?)? validator; 
  final Icon? icon;

  const CustomTextfield({
    super.key,
    required this.hinttext,
    required this.controller,
    this.validator, 
     this.icon
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField( 
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            
            
          ),
          hintText: widget.hinttext,
          errorStyle: const TextStyle(color: Colors.red), 
        ),
        validator: widget.validator,
      ),
    );
  }
}
