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
import 'package:redline/authenticationScreen/birthdaycal.dart';

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

  // static buildTextField(TextEditingController controller, String label) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.8), // Shadow color
  //             spreadRadius: 1, // Spread radius
  //             blurRadius: 6, // Blur radius
  //             offset: const Offset(6, 6), // Shadow position (x, y)
  //           ),
  //         ],
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(34),
  //           topRight: Radius.circular(18),
  //           bottomLeft: Radius.circular(18),
  //           bottomRight: Radius.circular(18),
  //         ),
  //       ),
  //       child: TextField(
  //         controller: controller,
  //         style: const TextStyle(
  //           color: Color.fromARGB(255, 80, 80, 80), // Text color
  //           fontSize: 16, // Font size for input text
  //           fontWeight: FontWeight.w500, // Font weight
  //         ),
  //         decoration: InputDecoration(
  //           labelText: label,
  //           labelStyle: TextStyle(
  //             color: Color.fromARGB(255, 255, 140, 140), // Label text color
  //             fontSize: 14, // Font size for label
  //           ),
  //           hintText: "Enter $label", // Placeholder text
  //           hintStyle: TextStyle(
  //             color: Colors.grey[600], // Placeholder text color
  //             fontSize: 14, // Font size for placeholder
  //           ),
  //           fillColor:
  //               Colors.grey[300], // Background color inside the TextField
  //           filled: true, // Enables the fillColor property
  //           border: OutlineInputBorder(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(34),
  //               topRight: Radius.circular(18),
  //               bottomLeft: Radius.circular(18),
  //               bottomRight: Radius.circular(18),
  //             ),
  //             borderSide: const BorderSide(
  //               color: Colors.grey, // Outline border color
  //               width: 2, // Outline border width
  //             ),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(34),
  //               topRight: Radius.circular(18),
  //               bottomLeft: Radius.circular(18),
  //               bottomRight: Radius.circular(18),
  //             ),
  //             borderSide: const BorderSide(
  //               color: Colors.grey, // Outline border color
  //               width: 2, // Outline border width
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(34),
  //               topRight: Radius.circular(34),
  //               bottomLeft: Radius.circular(34),
  //               bottomRight: Radius.circular(34),
  //             ),
  //             borderSide: const BorderSide(
  //               color: Color.fromARGB(
  //                   255, 238, 80, 159), // Border color when focused
  //               width: 2, // Border width when focused
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  static buildTextField(TextEditingController controller, String label,
      {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 6, // Blur radius
              offset: const Offset(6, 6), // Shadow position (x, y)
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            color: Color.fromARGB(255, 80, 80, 80), // Text color
            fontSize: 16, // Font size for input text
            fontWeight: FontWeight.w500, // Font weight
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: const Color.fromARGB(255, 169, 180, 9), // Label text color
              fontSize: 14, // Font size for label
            ),
            hintText: "Enter $label", // Placeholder text
            hintStyle: TextStyle(
              color: Colors.grey[600], // Placeholder text color
              fontSize: 14, // Font size for placeholder
            ),
            fillColor:
                Colors.grey[300], // Background color inside the TextField
            filled: true, // Enables the fillColor property
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color:
                        const Color.fromARGB(255, 192, 12, 102), // Icon color
                  )
                : null, // If icon is not provided, no prefix icon will be displayed
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              borderSide: const BorderSide(
                color: Colors.grey, // Outline border color
                width: 2, // Outline border width
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              borderSide: const BorderSide(
                color: Colors.grey, // Outline border color
                width: 2, // Outline border width
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
              borderSide: const BorderSide(
                color: Color.fromARGB(
                    255, 238, 80, 159), // Border color when focused
                width: 2, // Border width when focused
              ),
            ),
          ),
        ),
      ),
    );
  }

  static buildbdField(BuildContext context,
      TextEditingController dateController, String label) {
    final FocusNode focusNode = FocusNode();

    return GestureDetector(
      onTap: () async {
        // Trigger focus for visual feedback
        focusNode.requestFocus();

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900), // Earliest selectable date
          lastDate: DateTime(2100), // Latest selectable date
        );

        // Remove focus after date selection
        focusNode.unfocus();

        if (pickedDate != null) {
          final String formattedDate =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          dateController.text = formattedDate;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AbsorbPointer(
          child: TextField(
            controller: dateController,
            focusNode: focusNode,
            style: const TextStyle(
              color: Color.fromARGB(255, 80, 80, 80), // Text color
              fontSize: 16, // Font size for input text
              fontWeight: FontWeight.w500, // Font weight
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.grey[800], // Label text color
                fontSize: 14, // Font size for label
              ),
              hintText: "Enter $label", // Placeholder text
              hintStyle: TextStyle(
                color: Colors.grey[600], // Placeholder text color
                fontSize: 14, // Font size for placeholder
              ),
              fillColor:
                  Colors.grey[300], // Background color inside the TextField
              filled: true, // Enables the fillColor property
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ), // Apply custom border radius
                borderSide: const BorderSide(
                  color: Colors.grey, // Outline border color
                  width: 2, // Outline border width
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ), // Border radius for enabled state
                borderSide: const BorderSide(
                  color: Colors.grey, // Outline border color
                  width: 2, // Outline border
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ), // Border radius for focused state
                borderSide: const BorderSide(
                  color: Color.fromARGB(
                      255, 238, 80, 159), // Border color when focused
                  width: 2, // Border width when focused
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
