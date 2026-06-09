
import 'package:flutter/material.dart';

class inputField extends StatelessWidget{
  final String label ;
  final String hint ;
  final TextEditingController controller ;
  final TextInputType keyboardType ;
  final bool isPassword ;
  final IconData? icon ;
  final String? Function(String?)? validator ;



  const inputField({
    super.key ,
    required this.label ,
    required this.controller ,
    this.hint = "" ,
    required this.keyboardType,
    this.isPassword = false ,
    this.icon,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller ,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,

      decoration: InputDecoration(
        labelText: label ,
        hintText: hint ,
        prefixIcon: icon!=null?Icon(icon):null ,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black) ,
          borderRadius: BorderRadius.circular(12.0) ,
        ) ,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey) ,
          borderRadius: BorderRadius.circular(12.0)
        ) ,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0) ,
          borderSide: BorderSide(color: Colors.blue)
        )


      ),
    );
  }

}