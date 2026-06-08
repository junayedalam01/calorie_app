import 'package:flutter/material.dart';

class WaterTracker extends StatelessWidget {
  final double current;
  final double goal;
  final void Function(double ml) onAdd;

  const WaterTracker({
    super.key,
    required this.current,
    required this.goal,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (current / goal).clamp(0.0, 1.0);
    final cups = (current / 250).round();

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
              Row(
                children: [
                  const Icon(Icons.water_drop, color: Color(0xFF2196F3), size: 18),
                  const SizedBox(width: 6),
                  const Text('Water', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
              Text('${current.toInt()} / ${goal.toInt()} ml',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.blue.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2196F3)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...List.generate(10, (i) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.water_drop,
                  size: 18,
                  color: i < cups
                      ? const Color(0xFF2196F3)
                      : Colors.grey.shade200,
                ),
              )),
              const Spacer(),
              _AddBtn(label: '150ml', onTap: () => onAdd(150)),
              const SizedBox(width: 6),
              _AddBtn(label: '250ml', onTap: () => onAdd(250)),
              const SizedBox(width: 6),
              _AddBtn(label: '500ml', onTap: () => onAdd(500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AddBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
