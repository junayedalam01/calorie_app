import 'package:flutter/material.dart';

class MacroBar extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;
  final int calories;
  final int goal;

  const MacroBar({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.calories,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final pPct = (protein * 4 / (calories == 0 ? 1 : calories)).clamp(0.0, 1.0);
    final cPct = (carbs * 4 / (calories == 0 ? 1 : calories)).clamp(0.0, 1.0);
    final fPct = (fat * 9 / (calories == 0 ? 1 : calories)).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Macros', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              Text('$calories / $goal kcal',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 14),
          _MacroRow('Protein', protein, pPct, Colors.orange),
          const SizedBox(height: 10),
          _MacroRow('Carbs', carbs, cPct, Colors.blue),
          const SizedBox(height: 10),
          _MacroRow('Fat', fat, fPct, Colors.pink),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final String name;
  final double value;
  final double pct;
  final Color color;

  const _MacroRow(this.name, this.value, this.pct, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(name, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 42,
          child: Text('${value}g',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
