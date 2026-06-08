import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food.dart';
import '../models/app_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  List<Food> _results = [];

  void _search(String q) {
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _results = foodDatabase
          .where((f) => f.name.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  void _showAddSheet(Food food) {
    final qtyCtrl = TextEditingController(text: food.per.contains('ml') ? '200' : '100');
    String unit = food.per.contains('ml') ? 'ml' : 'g';
    String meal = context.read<AppState>().getMealSlot();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final qty = double.tryParse(qtyCtrl.text) ?? 100;
          final cal = (food.calories * qty / 100).round();
          final p = (food.protein * qty / 100).toStringAsFixed(1);
          final c = (food.carbs * qty / 100).toStringAsFixed(1);
          final f = (food.fat * qty / 100).toStringAsFixed(1);

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20, right: 20, top: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(food.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          Text('${food.calories.round()} kcal per ${food.per}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          color: const Color(0xFF1A9E6B).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('$cal kcal',
                          style: const TextStyle(
                              color: Color(0xFF1A9E6B),
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    _MacroChip('P: ${p}g', Colors.orange),
                    const SizedBox(width: 8),
                    _MacroChip('C: ${c}g', Colors.blue),
                    const SizedBox(width: 8),
                    _MacroChip('F: ${f}g', Colors.pink),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyCtrl,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setS(() {}),
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF1A9E6B)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: unit,
                      items: ['g', 'ml', 'serving']
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (v) => setS(() => unit = v!),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: meal,
                  decoration: InputDecoration(
                    labelText: 'Meal',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF1A9E6B)),
                    ),
                  ),
                  items: ['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setS(() => meal = v!),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A9E6B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final q = double.tryParse(qtyCtrl.text) ?? 100;
                      final entry = LogEntry(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        food: food,
                        quantity: q,
                        unit: unit,
                        meal: meal,
                        time: DateTime.now(),
                      );
                      context.read<AppState>().addEntry(entry);
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${food.name} added to $meal'),
                          backgroundColor: const Color(0xFF1A9E6B),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    child: const Text('Add to Log',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A9E6B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: _search,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search food...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_ctrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _ctrl.clear();
                _search('');
              },
            ),
        ],
      ),
      body: _results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    _ctrl.text.isEmpty ? 'Search for food above' : 'No results found',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final food = _results[i];
                return ListTile(
                  title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    'P: ${food.protein}g  C: ${food.carbs}g  F: ${food.fat}g',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${food.calories.round()} kcal',
                          style: const TextStyle(
                              color: Color(0xFF1A9E6B),
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      Text('per ${food.per}',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    ],
                  ),
                  onTap: () => _showAddSheet(food),
                );
              },
            ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MacroChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(color: color.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}
