// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CustomTextFieldWidget extends StatelessWidget {
//   final TextEditingController? editingController;
//   final IconData? iconData;
//   final String? assetRef;
//   final String? labelText;
//   final bool? isObscure;
//    final double borderRadius; // Add this line

//   CustomTextFieldWidget({
//     super.key,
//     this.editingController,
//     this.iconData,
//     this.assetRef,
//     this.labelText,
//     this.isObscure,
//     this.borderRadius = 6.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: editingController,
//       decoration: InputDecoration(
//         labelText: labelText,
//         prefixIcon: iconData != null
//             ? Icon(iconData)
//             : Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Image.asset(assetRef.toString()),
//               ),
//         labelStyle: const TextStyle(
//           fontSize: 18,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CustomTextFieldWidget extends StatelessWidget {
//   final TextEditingController? editingController;
//   final IconData? iconData;
//   final String? assetRef;
//   final String? labelText;
//   final bool? isObscure;
//   final double borderRadius; // Add this line

//   CustomTextFieldWidget({
//     super.key,
//     this.editingController,
//     this.iconData,
//     this.assetRef,
//     this.labelText,
//     this.isObscure,
//     this.borderRadius = 6.0, // Default value for border radius
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: editingController,
//       obscureText: isObscure ?? false, // Use default value if null
//       decoration: InputDecoration(
//         labelText: labelText,
//         prefixIcon: iconData != null
//             ? Icon(iconData)
//             : Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Image.asset(assetRef.toString()),
//               ),
//         labelStyle: const TextStyle(
//           fontSize: 18,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(
//               borderRadius), // Use the borderRadius parameter here
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(
//               borderRadius), // Use the borderRadius parameter here
//           borderSide: const BorderSide(
//               color: Colors.blue), // Change the border color for focused state
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? editingController;
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;

  final bool isObscure; // Change to non-nullable
  final double borderRadius; // Add borderRadius parameter

  CustomTextFieldWidget({
    super.key,
    this.editingController,
    this.iconData,
    this.assetRef,
    this.labelText,
    this.isObscure = false, // Default to false
    this.borderRadius = 6.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      obscureText: isObscure, // Use the isObscure parameter
      decoration: InputDecoration(
        labelText: editingController?.text.isEmpty ?? true ? labelText : null,
        // labelText: labelText,
        prefixIcon: iconData != null
            ? Icon(iconData)
            : Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(assetRef.toString()),
              ),
        labelStyle: const TextStyle(
          fontSize: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
