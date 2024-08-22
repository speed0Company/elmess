class ItemData {
  String name;
  String quantity;
  double price;

  ItemData({required this.name, required this.quantity, required this.price});

  // Factory method to create an instance from JSON
  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  // Method to convert an ItemData instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
