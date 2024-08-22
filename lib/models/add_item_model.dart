import 'dart:convert';

class AddItemModel {
  String name;
  int pieces;
  double price;

  AddItemModel({
    required this.name,
    this.pieces = 0, // Default to 0
    this.price = 0.0, // Default to 0.0
  });

  factory AddItemModel.fromJson(Map<String, dynamic> json) {
    return AddItemModel(
      name: json['name'],
      pieces: json['pieces'] ?? 0,
      price: json['price'] ?? 0.0,
    );
  }
}

List<AddItemModel> parseItemData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<AddItemModel>((json) => AddItemModel.fromJson(json)).toList();
}
