import 'package:flutter/material.dart';

class LineWithText extends StatelessWidget {
  final String text;

  const LineWithText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // First horizontal line with small gap at the start
        const SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: Divider(
            color: Colors.black.withOpacity(0.3),
            thickness: 1,
            endIndent: 10,
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.3)),
        ),
        // Second horizontal line with small gap at the end
        Expanded(
          flex: 4,
          child: Divider(
            color: Colors.black.withOpacity(0.3),
            thickness: 1,
            indent: 10,
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
