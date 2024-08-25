import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/text_title_widget.dart';

class AddNewName extends StatefulWidget {
  const AddNewName({super.key});

  @override
  _AddNewNameState createState() => _AddNewNameState();
}

class _AddNewNameState extends State<AddNewName> {
  List<Map<String, dynamic>> names = [];
  List<dynamic> oldData = [];
  bool namesAvailable = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadNamesFromPrefs();
    loadOldDataFromPrefs();
  }

  Future<void> loadNamesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNamesJson = prefs.getString('namesJson');

    if (storedNamesJson != null) {
      setState(() {
        final decodedJson = jsonDecode(storedNamesJson);
        names = List<Map<String, dynamic>>.from(decodedJson['names']);
        namesAvailable = names.isNotEmpty;
      });
    } else {
      setState(() {
        namesAvailable = false;
      });
    }
  }

  Future<void> loadOldDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedOldDataJson = prefs.getString('oldData');

    if (storedOldDataJson != null) {
      setState(() {
        oldData = jsonDecode(storedOldDataJson);
      });
    }
  }

  Future<void> saveNamesToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('namesJson', jsonEncode({'names': names}));
  }

  Future<void> saveOldDataToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('oldData', jsonEncode(oldData));
  }

  void showAddNameDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset("assets/cansel_icon.png", width: 23, height: 23)),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'برجاء ادخال الاسم';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'أدخل الاسم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        final newName = {'name': nameController.text, 'costInDay': []};
                        names.add(newName);
                        oldData.add(newName);
                        namesAvailable = true;
                        saveNamesToPrefs();
                        saveOldDataToPrefs();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Image.asset('assets/add_button.png', width: 181, height: 50, fit: BoxFit.fill),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditNameDialog(int index) {
    TextEditingController nameController = TextEditingController(text: names[index]['name']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset("assets/cansel_icon.png", width: 23, height: 23),
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'برجاء ادخال الاسم';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'أدخل الاسم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        names[index]['name'] = nameController.text;
                        oldData[index]['name'] = nameController.text;
                        saveNamesToPrefs();
                        saveOldDataToPrefs();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Image.asset('assets/add_button.png', width: 181, height: 50, fit: BoxFit.fill),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  void deleteName(int index) {
    setState(() {
      names.removeAt(index);
      oldData.removeAt(index);
      saveNamesToPrefs();
      saveOldDataToPrefs();
      namesAvailable = names.isNotEmpty;
    });
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
            TextTitle(title: "قائمة الظباط"),
            SizedBox(height: 30),
            namesAvailable
                ? Expanded(
              child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            names[index]['name'],
                            style: GoogleFonts.rubik(
                              color: Color(0xff004251),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right, // Align text to the right
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Image.asset('assets/edit_icon.png', width: 27, height: 27),
                              onPressed: () {
                                showEditNameDialog(index);
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Image.asset("assets/cansel_icon.png", width: 27, height: 27),
                              onPressed: () {
                                deleteName(index);
                              },
                            )
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey, thickness: 0.9),
                    ],
                  );
                },
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "لا يوجد اسماء مسجلة",
                style: GoogleFonts.rubik(
                  color: Color(0xff004251),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: showAddNameDialog,
              child: Image.asset('assets/add_icon.png', width: 50, height: 50),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}