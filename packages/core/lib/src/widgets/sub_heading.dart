import 'package:flutter/material.dart';

import '../common/constants.dart';

/// Judul sebuah bagian pada halaman utama beserta tautan "See More".
class SubHeading extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SubHeading({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
