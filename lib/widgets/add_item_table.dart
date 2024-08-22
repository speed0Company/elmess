import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_model.dart';  // Assuming ItemData is in item_model.dart

class AddItemTable extends StatelessWidget {
  final List<ItemData> items;

  AddItemTable({required this.items});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'عدد القطع',
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
            'سعر القطعة',
            style: GoogleFonts.rubik(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      rows: items.map((item) {
        return DataRow(
          cells: [
            DataCell(
              Text(
                item.quantity.toString(),
                style: GoogleFonts.getFont('Rubik',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ),
            DataCell(
              Text(
                item.name,
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataCell(
              Text(
                item.price.toString(),
                style: GoogleFonts.getFont('Rubik',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  height: 1.2,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
