import 'package:almes/helper/helper.dart';
import 'package:almes/models/data_model.dart';
import 'package:almes/widgets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DayCheckScreen extends StatefulWidget {
  DayCheckScreen({super.key});

  @override
  State<DayCheckScreen> createState() => _DayCheckScreenState();
}

class _DayCheckScreenState extends State<DayCheckScreen> {
  String jsonData = '[]'; // Default to empty array

  List<CostData>? costData;

  @override
  void initState() {
    super.initState();
    loadCostDataFromPrefs();
  }

  Future<void> loadCostDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedJsonData = prefs.getString('oldData');
    print(storedJsonData);
    if (storedJsonData != null) {
      setState(() {
        jsonData = storedJsonData;
        costData = Helper().parseCostData(jsonData);
      });
    } else {
      setState(() {
        costData = Helper().parseCostData(jsonData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (_) => false,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Transform.rotate(
            angle: 3.14, // 180 degrees in radians
            child: Image.asset('assets/back_icon.png'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "المراجعة اليومة",
              style: GoogleFonts.rubik(
                color: Color(0xff004251),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "شهر ${Helper().formatArabicDate(DateTime.now())}",
              style: GoogleFonts.rubik(
                color: Color(0xff2C4C53),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: costData != null
                    ? CostTable(costData: costData!)
                    : CircularProgressIndicator(), // Show a loading indicator while data is loading
              ),
            ),
          ],
        ),
      ),
    );
  }
}