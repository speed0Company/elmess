import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_model.dart';

class CustomItemTable extends StatefulWidget {
  final List<ItemData> items;
  final List<TextEditingController> controllers;

  CustomItemTable({required this.items, required this.controllers});

  @override
  State<CustomItemTable> createState() => _CustomItemTableState();
}


class _CustomItemTableState extends State<CustomItemTable> {
  @override
  void initState() {
    widget.controllers.forEach((controller){
      controller.text="0";
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DataTable(
          columnSpacing: 25,
          columns: [
            DataColumn(
              label: Text(
                '         عدد المستهلك',
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'سعر القطعة',
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'اسم الصنف',
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'الكمية',
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            widget.items.length,
                (index) => DataRow(
              cells: [
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 140, // Adjust width if needed
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_drop_up),
                            onPressed: () {
                              int currentValue = int.tryParse(widget.controllers[index].text) ?? 0;
                              currentValue++;
                              widget.controllers[index].text = currentValue.toString();
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: widget.controllers[index], // Bind to specific controller
                              decoration: InputDecoration(

                                hintText: 'أدخل العدد',
                                hintStyle: GoogleFonts.rubik(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                // Handle changes if needed
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              int currentValue = int.tryParse(widget.controllers[index].text) ?? 0;
                              if (currentValue > 0) {
                                currentValue--;
                                widget.controllers[index].text = currentValue.toString();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.items[index].price.toString(),
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.items[index].name,
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.items[index].quantity,
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
