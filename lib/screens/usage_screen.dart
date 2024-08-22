import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';
import '../widgets/item_table_widget.dart';
import '../widgets/text_title_widget.dart';

class UsageScreen extends StatefulWidget {
  const UsageScreen({super.key});

  @override
  _UsageScreenState createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  String itemsJson = '''
  [
   
  ]
  ''';

  String namesJson = '''
  {
    "names": [
    ]
  }
  ''';

  String oldData='[]';

  bool haveUsage = true;
  bool namesAvailable = true;

  Future<void> loadItemsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedItemsJson = prefs.getString('itemsJson');
    if (storedItemsJson != null) {
      setState(() {
        itemsJson = storedItemsJson;
        items = parseItemData(itemsJson);
        controllers = List.generate(items.length, (index) => TextEditingController(text: '0'));
      });
    } else {
      setState(() {
        haveUsage = false;
      });
    }
  }

  Future<void> loadNamesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNamesJson = prefs.getString('namesJson');
    if (storedNamesJson != null) {
      setState(() {
        namesJson = storedNamesJson;
        final decodedJson = jsonDecode(namesJson);
        names = List<Map<String, dynamic>>.from(decodedJson['names']);
        selected = List<bool>.filled(names.length, false);
      });
    } else {
      setState(() {
        final decodedJson = jsonDecode(namesJson);
        names = List<Map<String, dynamic>>.from(decodedJson['names']);
        selected = List<bool>.filled(names.length, false);
        namesAvailable = true;

      });
    }
  }

  Future<void> loadOldDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedOldData = prefs.getString('oldData');
    if (storedOldData != null) {
      setState(() {
        oldData = storedOldData;
      });
    }
  }

  Future<void> saveItemsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('itemsJson', itemsJson);
  }

  Future<void> saveOldDataToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('oldData', oldData);
  }

  List<ItemData> items = [];
  List<TextEditingController> controllers = [];
  List<Map<String, dynamic>> names = [];
  List<bool> selected = [];

  List<Map<String, dynamic>> selectedNames = [];
  int selectedDay = DateTime.now().day;

  @override
  void initState() {
    super.initState();
    loadItemsFromPrefs();
    loadNamesFromPrefs();
    loadOldDataFromPrefs();
  }

  double calculateTotalPrice() {
    int selectedCount = selected.where((item) => item == true).length;

    double total = 0.0;
    for (int i = 0; i < items.length; i++) {
      int quantity = int.tryParse(controllers[i].text) ?? 0;
      total += quantity * items[i].price;
    }
    return total / selectedCount;
  }

  void updateSelectedNames() {
    List<Map<String, dynamic>> oldDataList = json.decode(oldData).cast<Map<String, dynamic>>();

    for (int i = 0; i < names.length; i++) {
      if (selected[i]) {
        // Check if the name already exists in oldDataList
        int existingNameIndex = oldDataList.indexWhere((element) => element['name'] == names[i]['name']);

        if (existingNameIndex != -1) {
          // The name exists, check for the day
          List<dynamic> costInDayList = oldDataList[existingNameIndex]['costInDay'];
          int existingDayIndex = costInDayList.indexWhere((element) => element['day'] == selectedDay);

          if (existingDayIndex != -1) {
            // Store original cost before updating
            double originalCost = double.parse(costInDayList[existingDayIndex]['cost'].toString());

            // Add the new cost to the existing cost for the day
            double newCost = calculateTotalPrice();
            costInDayList[existingDayIndex]['cost'] += newCost;

            // Store the added cost for future reference
            names[i]['addedCost'] = newCost;
          } else {
            // Add a new day entry
            double newCost = calculateTotalPrice();
            costInDayList.add({
              'day': selectedDay,
              'cost': newCost,
            });

            // Store the added cost for future reference
            names[i]['addedCost'] = newCost;
          }
        } else {
          // The name doesn't exist, add a new entry
          double newCost = calculateTotalPrice();
          oldDataList.add({
            'name': names[i]['name'],
            'costInDay': [
              {
                'day': selectedDay,
                'cost': newCost,
              }
            ],
          });

          // Store the added cost for future reference
          names[i]['addedCost'] = newCost;
        }
      } else {
        // If the checkbox is unchecked, remove only the added value (not the entire cost)
        int existingNameIndex = oldDataList.indexWhere((element) => element['name'] == names[i]['name']);

        if (existingNameIndex != -1) {
          List<dynamic> costInDayList = oldDataList[existingNameIndex]['costInDay'];
          int existingDayIndex = costInDayList.indexWhere((element) => element['day'] == selectedDay);

          if (existingDayIndex != -1) {
            // Subtract only the added cost, without touching the original cost
            double addedCost = names[i]['addedCost'] ?? 0.0;
            double originalCost = double.parse(costInDayList[existingDayIndex]['cost'].toString());

            // Subtract only the added cost, but ensure that it doesn't make the total cost negative or 0
            if (originalCost - addedCost > 0) {
              costInDayList[existingDayIndex]['cost'] -= addedCost;
            }

            // Do not remove the entire day's entry unless it's only because of the added cost
            if (costInDayList[existingDayIndex]['cost'] <= 0 && addedCost > 0) {
              costInDayList.removeAt(existingDayIndex);
            }
          }

          // Do not remove the entire name unless it was only added during this session
          if (costInDayList.isEmpty && names[i]['addedCost'] != null) {
            oldDataList.removeAt(existingNameIndex);
          }
        }
      }
    }

    // Update the oldData string with the modified list
    oldData = jsonEncode(oldDataList);
    saveOldDataToPrefs();

    print(oldData); // For debugging
  }

  void decreaseItemQuantities() {
    setState(() {
      for (int i = 0; i < items.length; i++) {
        int usedQuantity = int.tryParse(controllers[i].text) ?? 0;
        int currentQuantity = int.tryParse(items[i].quantity) ?? 0;
        if (usedQuantity > currentQuantity) {
          usedQuantity = currentQuantity;
        }
        items[i].quantity = (currentQuantity - usedQuantity).toString();
      }

      // Update the itemsJson with the new list of items, converting each ItemData to JSON
      itemsJson = jsonEncode(items.map((item) => item.toJson()).toList());
      saveItemsToPrefs();
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
      body: haveUsage ? Column(
        children: [
          TextTitle(title: "قائمة الاستهلاك"),

          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    CustomItemTable(
                      items: items,
                      controllers: controllers,
                    ),
                    SizedBox(height: 20,),
                    namesAvailable ? Column(
                      children: [
                        TextTitle(title: "حدد الاسماء"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Wrap(
                              spacing: 20.0,
                              runSpacing: 20.0,
                              children: List.generate(names.length, (index) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: selected[index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selected[index] = value!;
                                        });
                                      },
                                      activeColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    Text(
                                      names[index]['name'],
                                      style: GoogleFonts.getFont('Rubik',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1), // optional
                                lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0), // optional
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.blue, // change the color of the date picker
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                // get the day of the month from the picked date
                                int day = picked.day;
                                // do something with the day, e.g. print it
                                selectedDay = day;
                              }
                            },
                            child: Image.asset('assets/date_button.png', width: 181, height: 50, fit: BoxFit.fill,)),
                        SizedBox(height: 20,),
                        GestureDetector(
                            onTap: () {
                              print(selected);

                              decreaseItemQuantities();
                              updateSelectedNames();
                            },
                            child: Image.asset('assets/add_button.png', width: 181, height: 50, fit: BoxFit.fill,)),
                        SizedBox(height: 20,),
                      ],
                    ) : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextTitle(title: "لا يوجد اسماء مسجلة"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ) : Center(child: TextTitle(title: "لا يوجد منتجات")),
    );
  }

  List<ItemData> parseItemData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ItemData>((json) => ItemData.fromJson(json)).toList();
  }
}