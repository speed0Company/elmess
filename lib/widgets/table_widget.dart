import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/helper.dart';
import '../models/data_model.dart';

class CostTable extends StatelessWidget {
  final List<CostData> costData;
  final int year = DateTime.now().year;
  final int month = DateTime.now().month;

  CostTable({required this.costData});

  @override
  Widget build(BuildContext context) {
    int daysInMonth = Helper().getDaysInMonth(year, month);

    return Row(
      children: [
        // Fixed first column
        Container(
          width: 100, // adjust the width as needed
          child: DataTable(
            columns: [
              DataColumn(label: Text('اليوم',style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),)),
            ],
            rows: costData.map((data) {
              return DataRow(cells: [
                DataCell(Text(data.name,style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),)),
              ]);
            }).toList(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                for (int i = 1; i <= daysInMonth; i++)
                  DataColumn(label: Text(i.toString(),style: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),)),
              ],
              rows: costData.map((data) {
                return DataRow(cells: [
                  for (int i = 1; i <= daysInMonth; i++)
                    DataCell(Text(getCostForDay(data.costInDay, i).toString(),style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),)),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  double getCostForDay(List<DayCost> costInDay, int day) {
    try {
      return costInDay.firstWhere((cost) => cost.day == day).cost;
    } catch (e) {
      return 0; // or any default value if no cost is found for the day
    }
  }
}