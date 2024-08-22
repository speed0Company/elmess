import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTitle extends StatelessWidget {
  TextTitle({
    required this.title,
  });
  String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: GoogleFonts.getFont('Rubik',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          height: 1.2,
          color:Color(0xff004251)
      ),
    );
  }
}
