import 'package:flutter/material.dart';

class EmptyDataCard extends StatelessWidget {
  final String title;
  const EmptyDataCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
         SizedBox(height: 20),
        Center(
          child: Image.asset(
            'assets/icons/empty.png',
            width:   MediaQuery.of(context).size.width * 0.3,
          ),
        ),
      ],
    );
  }
}
