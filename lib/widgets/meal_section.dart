import 'package:flutter/material.dart';
import '../models/food.dart';

class MealSection extends StatelessWidget {
  final String mealName;
  final List<LogEntry> entries;
  final void Function(String id) onDelete;

  const MealSection({
    super.key,
    required this.mealName,
    required this.entries,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final mealCal = entries.fold(0, (s, e) => s + e.calories.toInt());

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xFF1A9E6B), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(mealName,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
                Text('$mealCal kcal',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...entries.map((e) => _FoodTile(entry: e, onDelete: onDelete)),
        ],
      ),
    );
  }
}

class _FoodTile extends StatelessWidget {
  final LogEntry entry;
  final void Function(String id) onDelete;

  const _FoodTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade50,
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) => onDelete(entry.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.food.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.quantity.toInt()}${entry.unit}  ·  P:${entry.protein}g  C:${entry.carbs}g  F:${entry.fat}g',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text('${entry.calories.toInt()}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1A9E6B))),
            const SizedBox(width: 4),
            Text('kcal', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
