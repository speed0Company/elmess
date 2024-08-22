class CostData {
  String name;
  List<DayCost> costInDay;

  CostData({required this.name, required this.costInDay});

  factory CostData.fromJson(Map<String, dynamic> json) {
    var list = json['costInDay'] as List;
    List<DayCost> costList = list.map((i) => DayCost.fromJson(i)).toList();

    return CostData(
      name: json['name'],
      costInDay: costList,
    );
  }
}

class DayCost {
  int day;
  double cost;

  DayCost({required this.day, required this.cost});

  factory DayCost.fromJson(Map<String, dynamic> json) {
    return DayCost(
      day: json['day'],
      cost: json['cost'],
    );
  }
}
