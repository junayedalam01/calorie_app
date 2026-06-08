class Food {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String per;

  const Food({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.per,
  });
}

class LogEntry {
  final String id;
  final Food food;
  final double quantity;
  final String unit;
  final String meal;
  final DateTime time;

  LogEntry({
    required this.id,
    required this.food,
    required this.quantity,
    required this.unit,
    required this.meal,
    required this.time,
  });

  double get calories => (food.calories * quantity / 100).roundToDouble();
  double get protein => double.parse((food.protein * quantity / 100).toStringAsFixed(1));
  double get carbs => double.parse((food.carbs * quantity / 100).toStringAsFixed(1));
  double get fat => double.parse((food.fat * quantity / 100).toStringAsFixed(1));

  Map<String, dynamic> toJson() => {
    'id': id,
    'foodName': food.name,
    'foodCal': food.calories,
    'foodProtein': food.protein,
    'foodCarbs': food.carbs,
    'foodFat': food.fat,
    'foodPer': food.per,
    'quantity': quantity,
    'unit': unit,
    'meal': meal,
    'time': time.toIso8601String(),
  };

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      id: json['id'],
      food: Food(
        name: json['foodName'],
        calories: json['foodCal'],
        protein: json['foodProtein'],
        carbs: json['foodCarbs'],
        fat: json['foodFat'],
        per: json['foodPer'],
      ),
      quantity: json['quantity'],
      unit: json['unit'],
      meal: json['meal'],
      time: DateTime.parse(json['time']),
    );
  }
}

const List<Food> foodDatabase = [
  Food(name: 'Rice (cooked)', calories: 130, protein: 2.7, carbs: 28, fat: 0.3, per: '100g'),
  Food(name: 'Roti / Chapati', calories: 297, protein: 9.5, carbs: 54, fat: 3.7, per: '100g'),
  Food(name: 'Dal (cooked)', calories: 116, protein: 9, carbs: 20, fat: 0.4, per: '100g'),
  Food(name: 'Chicken breast', calories: 165, protein: 31, carbs: 0, fat: 3.6, per: '100g'),
  Food(name: 'Egg (boiled)', calories: 155, protein: 13, carbs: 1.1, fat: 11, per: '100g'),
  Food(name: 'Paneer', calories: 265, protein: 18, carbs: 3.4, fat: 20, per: '100g'),
  Food(name: 'Milk (full fat)', calories: 61, protein: 3.2, carbs: 4.8, fat: 3.3, per: '100ml'),
  Food(name: 'Banana', calories: 89, protein: 1.1, carbs: 23, fat: 0.3, per: '100g'),
  Food(name: 'Apple', calories: 52, protein: 0.3, carbs: 14, fat: 0.2, per: '100g'),
  Food(name: 'Potato (boiled)', calories: 87, protein: 1.9, carbs: 20, fat: 0.1, per: '100g'),
  Food(name: 'Bread (white)', calories: 265, protein: 9, carbs: 49, fat: 3.2, per: '100g'),
  Food(name: 'Oats', calories: 389, protein: 17, carbs: 66, fat: 7, per: '100g'),
  Food(name: 'Almonds', calories: 579, protein: 21, carbs: 22, fat: 50, per: '100g'),
  Food(name: 'Curd / Yogurt', calories: 61, protein: 3.5, carbs: 4.7, fat: 3.3, per: '100g'),
  Food(name: 'Idli', calories: 58, protein: 1.8, carbs: 11, fat: 0.5, per: '100g'),
  Food(name: 'Dosa', calories: 168, protein: 3.5, carbs: 23, fat: 6.5, per: '100g'),
  Food(name: 'Sambar', calories: 56, protein: 3.5, carbs: 9, fat: 0.8, per: '100g'),
  Food(name: 'Aloo Sabzi', calories: 110, protein: 2, carbs: 18, fat: 3.5, per: '100g'),
  Food(name: 'Rajma (cooked)', calories: 127, protein: 8.7, carbs: 22, fat: 0.5, per: '100g'),
  Food(name: 'Orange', calories: 47, protein: 0.9, carbs: 12, fat: 0.1, per: '100g'),
  Food(name: 'Mango', calories: 60, protein: 0.8, carbs: 15, fat: 0.4, per: '100g'),
  Food(name: 'Peanuts', calories: 567, protein: 26, carbs: 16, fat: 49, per: '100g'),
  Food(name: 'Tea with Milk', calories: 11, protein: 0.6, carbs: 1.2, fat: 0.4, per: '100ml'),
  Food(name: 'Biryani (Chicken)', calories: 200, protein: 11, carbs: 25, fat: 5.8, per: '100g'),
  Food(name: 'Poha', calories: 180, protein: 3.5, carbs: 35, fat: 4, per: '100g'),
  Food(name: 'Upma', calories: 150, protein: 4, carbs: 26, fat: 4.5, per: '100g'),
  Food(name: 'Puri', calories: 330, protein: 7, carbs: 44, fat: 14, per: '100g'),
  Food(name: 'Chana Dal', calories: 164, protein: 9, carbs: 27, fat: 2.6, per: '100g'),
  Food(name: 'Moong Dal', calories: 105, protein: 7.6, carbs: 19, fat: 0.4, per: '100g'),
  Food(name: 'Palak Paneer', calories: 180, protein: 8, carbs: 8, fat: 13, per: '100g'),
  Food(name: 'Butter', calories: 717, protein: 0.9, carbs: 0.1, fat: 81, per: '100g'),
  Food(name: 'Ghee', calories: 900, protein: 0, carbs: 0, fat: 100, per: '100g'),
  Food(name: 'Watermelon', calories: 30, protein: 0.6, carbs: 8, fat: 0.2, per: '100g'),
  Food(name: 'Grapes', calories: 69, protein: 0.7, carbs: 18, fat: 0.2, per: '100g'),
  Food(name: 'Sweet Potato', calories: 86, protein: 1.6, carbs: 20, fat: 0.1, per: '100g'),
  Food(name: 'Fish (Rohu)', calories: 97, protein: 16, carbs: 0, fat: 3.5, per: '100g'),
  Food(name: 'Mutton', calories: 294, protein: 25, carbs: 0, fat: 21, per: '100g'),
  Food(name: 'Coconut (fresh)', calories: 354, protein: 3.3, carbs: 15, fat: 33, per: '100g'),
  Food(name: 'Peas (cooked)', calories: 84, protein: 5.4, carbs: 15, fat: 0.2, per: '100g'),
  Food(name: 'Cauliflower', calories: 25, protein: 1.9, carbs: 5, fat: 0.3, per: '100g'),
];
