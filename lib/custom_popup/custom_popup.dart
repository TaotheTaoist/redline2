// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CustomPopup extends StatefulWidget {
//   @override
//   _CustomPopupState createState() => _CustomPopupState();
// }

// class _CustomPopupState extends State<CustomPopup> {
//   // Slider values
//   double maxDistance = 23.0; // Default value
//   RangeValues ageRange = RangeValues(18, 28); // Default age range

//   // Save the values to Firebase
//   Future<void> _savePreferencesToFirebase() async {
//     try {
//       // Replace 'your_collection' and 'your_document' with your Firebase paths
//       await FirebaseFirestore.instance
//           .collection('userPreferences')
//           .doc('userID')
//           .set({
//         'maxDistance': maxDistance,
//         'ageRange': {'min': ageRange.start, 'max': ageRange.end},
//       });
//       print('Preferences saved successfully!');
//     } catch (e) {
//       print('Error saving preferences: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(20.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.0),
//           color: const Color.fromARGB(
//               255, 131, 131, 131), // Background remains black
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             Text(
//               'Preference',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black, // Set text color to black
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             // Subtitle
//             Text(
//               'Privacy Setting',
//               style: TextStyle(
//                 fontSize: 14.0,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black, // Set text color to black
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             // Filters
//             _buildSliderOption(
//               title: 'Maximum Distance',
//               value: maxDistance,
//               onChanged: (newValue) {
//                 setState(() {
//                   maxDistance = newValue;
//                 });
//               },
//               label: '${maxDistance.round()} km',
//             ),
//             const SizedBox(height: 10.0),
//             _buildAgeRangeSlider(),
//             const SizedBox(height: 20.0),
//             // Back button
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await _savePreferencesToFirebase();
//                   Navigator.of(context).pop(); // Close the popup
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                 ),
//                 child: const Text('Back'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSliderOption({
//     required String title,
//     required double value,
//     required void Function(double) onChanged,
//     required String label,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 16.0),
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Slider(
//                 value: value,
//                 min: 0,
//                 max: 100,
//                 onChanged: onChanged,
//               ),
//             ),
//             Text(label),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAgeRangeSlider() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Age Range',
//           style: TextStyle(fontSize: 16.0),
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: RangeSlider(
//                 values: ageRange,
//                 min: 18,
//                 max: 100,
//                 onChanged: (RangeValues newRange) {
//                   setState(() {
//                     ageRange = newRange;
//                   });
//                 },
//               ),
//             ),
//             Text('${ageRange.start.round()} - ${ageRange.end.round()}'),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:redline/controller/profile-controller.dart';
import 'package:redline/global.dart';

class CustomPopup extends StatefulWidget {
  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  late double maxDistance;
  late RangeValues ageRange;

  final Profilecontroller profileController = Get.find<Profilecontroller>();

  @override
  void initState() {
    super.initState();

    // Initialize values from ProfileController
    maxDistance = profileController.maxDistance?.value?.toDouble() ?? 23.0;
    ageRange = RangeValues(
      profileController.minAge?.value?.toDouble() ?? 18,
      profileController.maxAge?.value?.toDouble() ?? 28,
    );
  }

  // Save the values to Firebase and update ProfileController
  Future<void> _savePreferencesToFirebase() async {
    try {
      // Save preferences to Firestore using update() instead of set()
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID) // Use the current user's ID
          .update({
        'maxDistance': maxDistance,
        'ageRange': {'minAge': ageRange.start, 'maxAge': ageRange.end},
      });

      // Update the controller values
      profileController.maxDistance?.value = maxDistance.toInt();
      profileController.minAge?.value = ageRange.start.toInt();
      profileController.maxAge?.value = ageRange.end.toInt();

      print('Preferences saved successfully!');
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromARGB(
              255, 131, 131, 131), // Background remains black
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Preference',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set text color to black
              ),
            ),
            const SizedBox(height: 10.0),
            // Subtitle
            Text(
              'Privacy Setting',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black, // Set text color to black
              ),
            ),
            const SizedBox(height: 10.0),
            // Filters
            _buildSliderOption(
              title: 'Maximum Distance',
              value: maxDistance,
              onChanged: (newValue) {
                setState(() {
                  maxDistance = newValue;
                });
              },
              label: '${maxDistance.round()} km',
            ),
            const SizedBox(height: 10.0),
            _buildAgeRangeSlider(),
            const SizedBox(height: 20.0),
            // Back button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  await _savePreferencesToFirebase();
                  Navigator.of(context).pop(); // Close the popup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderOption({
    required String title,
    required double value,
    required void Function(double) onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: 100,
                onChanged: onChanged,
              ),
            ),
            Text(label),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Age Range',
          style: TextStyle(fontSize: 16.0),
        ),
        Row(
          children: [
            Expanded(
              child: RangeSlider(
                values: ageRange,
                min: 18,
                max: 100,
                onChanged: (RangeValues newRange) {
                  setState(() {
                    ageRange = newRange;
                  });
                },
              ),
            ),
            Text('${ageRange.start.round()} - ${ageRange.end.round()}'),
          ],
        ),
      ],
    );
  }
}
