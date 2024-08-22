import 'package:almes/screens/usage_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/text_title_widget.dart';
import 'add_item_screen.dart';
import 'add_new_name.dart';
import 'day_check.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextTitle(
                title: "يرجى اختيار القائمة",
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  shrinkWrap: true, // Shrinks the grid to fit the content
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  children: [
                    _buildMenuItem(
                      imagePath: 'assets/add_item.png',
                      title: 'إضافة السلع',
                      context: context,
                       page: AddItemScreen()
                    ),
                    _buildMenuItem(
                      imagePath: 'assets/usage.png',
                      title: 'الاستهلاك',
                      context: context,
                      page: UsageScreen()
                    ),
                    _buildMenuItem(
                      imagePath: 'assets/edit_data.png',
                      title: 'تعديل أسماء الظباط',
                      context: context,
                      page: AddNewName()
                    ),
          
                    _buildMenuItem(
                      imagePath: 'assets/review.png',
                      title: 'المراجعة اليومية',
                      context: context,
                      page: DayCheckScreen()
                    ),
          
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildMenuItem({required String imagePath, required String title, required BuildContext context, Widget? page}) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => page??HomeScreen(),));
      },
      child: Center(
        child: Container(
          width: 700,
          height: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xffC3DFE5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              LayoutBuilder(
                builder: (context, constraints) {
                  double imageSize = constraints.maxWidth /1.4; // adjust this value to change the image size
                  return Image.asset(
                    imagePath,
                    height: imageSize+5,
                    width: imageSize,
                    fit: BoxFit.cover,
                  );
                },
              ),
              Spacer(),
              SizedBox(
                width: 200,
                child: Text(
                  title,
                  style: GoogleFonts.getFont('Rubik',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 1.2,
                      color:Color(0xff004251)
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

