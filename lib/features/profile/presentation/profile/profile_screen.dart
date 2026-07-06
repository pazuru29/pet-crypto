import 'package:flutter/material.dart';
import 'package:pet_crypto/widgets/app_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [AppTitle(title: 'Profile')],
        ),
      ),
    );
  }
}
