import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';
import '../widgets/add_item_table.dart';
import '../widgets/text_title_widget.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String itemsJson = '''
  [
  ]
  ''';

  List<ItemData> items = [];
  String? selectedItem;
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItemsFromPrefs();
  }

  Future<void> loadItemsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedItemsJson = prefs.getString('itemsJson');
    if (storedItemsJson != null) {
      setState(() {
        itemsJson = storedItemsJson;
        items = parseItemData(itemsJson);
      });
    } else {
      loadItems();
    }
  }

  Future<void> saveItemsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('itemsJson', itemsJson);
  }

  void loadItems() {
    setState(() {
      items = parseItemData(itemsJson);
    });
  }

  void updateItem() {
    if (selectedItem == null) return; // Return if no item is selected

    // Find the selected item and update it
    setState(() {
      items = items.map((item) {
        if (item.name == selectedItem) {
          double oldQuantity = double.parse(item.quantity.toString());
          double oldPrice = item.price;
          double newQuantity = quantityController.text.isEmpty ? oldQuantity : double.parse(quantityController.text);
          double newPrice = priceController.text.isEmpty ? oldPrice : double.parse(priceController.text);
          double totalNewQuantity=oldQuantity+newQuantity;
          // Update quantity
          item.quantity = totalNewQuantity.toString();

          // Calculate the new price based on the given formula
          if (newPrice != oldPrice) {
            item.price = ((oldPrice * oldQuantity + newPrice) / (oldQuantity + newQuantity));
            item.price = double.parse(item.price.toStringAsFixed(1)); // Fix the price to one decimal place
          }
        }
        return item;
      }).toList();

      // Update the itemsJson with the new list of items, converting each ItemData to JSON
      itemsJson = jsonEncode(items.map((item) => item.toJson()).toList());
      saveItemsToPrefs(); // Save updated data to SharedPreferences
    });
  }
  void showAddItemDialog(BuildContext context) {
    TextEditingController newItemNameController = TextEditingController();
    TextEditingController newQuantityController = TextEditingController();
    TextEditingController newPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: newItemNameController,
                          decoration: InputDecoration(
                            labelText: 'أدخل صنف جديد',
                            labelStyle: GoogleFonts.getFont('Rubik',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: newQuantityController,
                          decoration: InputDecoration(
                            labelText: 'أدخل العدد',
                            labelStyle: GoogleFonts.getFont('Rubik',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: newPriceController,
                          decoration: InputDecoration(
                            labelText: 'أدخل السعر',
                            labelStyle: GoogleFonts.getFont('Rubik',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (newItemNameController.text.isNotEmpty &&
                        newQuantityController.text.isNotEmpty &&
                        newPriceController.text.isNotEmpty) {
                      setState(() {
                        items.add(ItemData(
                          name: newItemNameController.text,
                          quantity: newQuantityController.text,
                          price: double.parse(newPriceController.text),
                        ));
                        itemsJson = jsonEncode(items.map((item) => item.toJson()).toList());
                        saveItemsToPrefs(); // Save new item to SharedPreferences
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Image.asset('assets/add_button.png', width: 181, height: 50, fit: BoxFit.fill),
                ),
              ],
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Image.asset('assets/cansel_icon.png', width: 23, height: 23,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            children: [
              TextTitle(title: 'قائمة الأصناف'),
              const SizedBox(height: 20),

              AddItemTable(items: items),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Price Input
                      Expanded(
                        child: TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(
                            labelText: 'أدخل السعر',
                            labelStyle: GoogleFonts.getFont('Rubik',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedItem,
                          hint: Text(
                            'اختر الصنف',
                            style: GoogleFonts.getFont('Rubik',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 1.2),
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          items: items.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(
                                item.name,
                                style: GoogleFonts.getFont(
                                  'Rubik',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  height: 1.2,
                                  color: const Color(0xff004251),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedItem = value;
                            });
                          },
                        ),
                      ),

                      // Quantity Input
                      const SizedBox(width: 10),

                      // Dropdown for items
                      Expanded(
                        child: TextFormField(
                          controller: quantityController,
                          decoration: InputDecoration(
                            labelText: 'أدخل العدد',
                            labelStyle: GoogleFonts.getFont('Rubik',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                  onTap: () {
                    updateItem();
                  },
                  child: Image.asset('assets/add_button.png', width: 181, height: 50, fit: BoxFit.fill,)),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => showAddItemDialog(context),
                child: Image.asset('assets/add_new_button.png', width: 181, height: 50, fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to parse the JSON string and return List<ItemData>
  List<ItemData> parseItemData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ItemData>((json) => ItemData.fromJson(json)).toList();
  }
}