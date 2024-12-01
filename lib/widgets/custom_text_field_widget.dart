import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// workingversion
// class CustomTextFieldWidget extends StatelessWidget {
//   final TextEditingController? editingController;
//   final IconData? iconData;
//   final String? assetRef;
//   final String? labelText;

//   final bool isObscure; // Change to non-nullable
//   final double borderRadius; // Add borderRadius parameter

//   CustomTextFieldWidget({
//     super.key,
//     this.editingController,
//     this.iconData,
//     this.assetRef,
//     this.labelText,
//     this.isObscure = false, // Default to false
//     this.borderRadius = 6.0, // Default border radius
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: editingController,
//       obscureText: isObscure, // Use the isObscure parameter
//       style: const TextStyle(color: Colors.white), // Set text color to black
//       decoration: InputDecoration(
//         labelText: editingController?.text.isEmpty ?? true ? labelText : null,
//         prefixIcon: iconData != null
//             ? Icon(iconData, color: Colors.black) // Set icon color to black
//             : Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Image.asset(
//                   assetRef.toString(),
//                   color: Colors
//                       .black, // Set asset image color to black if it's a colorable image
//                 ),
//               ),
//         labelStyle: const TextStyle(
//           fontSize: 18,
//           color: Color.fromARGB(
//               255, 255, 255, 255), // Set label text color to black
//         ),
//         filled: true, // Enable fill color
//         fillColor: Colors.grey[800], // Set background color to gray
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           borderSide: const BorderSide(color: Colors.blue),
//         ),
//       ),
//     );
//   }
// }
import 'package:gradient_borders/gradient_borders.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? editingController;
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;
  final bool isObscure;
  final double borderRadius;

  CustomTextFieldWidget({
    super.key,
    this.editingController,
    this.iconData,
    this.assetRef,
    this.labelText,
    this.isObscure = false,
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: editingController?.text.isEmpty ?? true ? labelText : null,
        prefixIcon: iconData != null
            ? Icon(iconData, color: Colors.black)
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  assetRef.toString(),
                  color: Colors.black,
                ),
              ),
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        filled: true,
        fillColor: Colors.grey[800],
        enabledBorder: GradientOutlineInputBorder(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: GradientOutlineInputBorder(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          width: 2, // Optional, set border width for focused state
        ),
      ),
    );
  }
}
