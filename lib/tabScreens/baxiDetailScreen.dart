import 'package:flutter/material.dart';

class BaxiDetailsScreen extends StatelessWidget {
  final String birthday;
  final String time;

  const BaxiDetailsScreen({
    Key? key,
    required this.birthday,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baxi Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Birthday: $birthday',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Time: $time',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
