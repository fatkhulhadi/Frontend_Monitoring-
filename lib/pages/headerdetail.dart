import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';


class HeaderScreenDetail extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 25.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildProfile(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Image.asset(
        'assets/monitoring.png',
        width: double.infinity,
        height: 28.0,
        fit: BoxFit.contain,
      ),
    );
  }

   Widget _buildProfile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
              radius: 20,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${box.read('user')}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${box.read('occupation')}'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}