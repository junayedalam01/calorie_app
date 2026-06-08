import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/food.dart';
import '../widgets/calorie_ring.dart';
import '../widgets/macro_bar.dart';
import '../widgets/meal_section.dart';
import '../widgets/water_tracker.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final now = DateTime.now();
    final dateStr = '${_weekday(now.weekday)}, ${now.day} ${_month(now.month)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF1A9E6B),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A9E6B), Color(0xFF0D7A52)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateStr,
                                style: const TextStyle(color: Colors.white70, fontSize: 14)),
                            Text('Goal: ${state.calorieGoal} kcal',
                                style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      CalorieRing(
                        consumed: state.totalCalories,
                        goal: state.calorieGoal,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            _MacroPill('Protein', '${state.totalProtein}g', Colors.orange.shade200),
                            const SizedBox(width: 8),
                            _MacroPill('Carbs', '${state.totalCarbs}g', Colors.blue.shade200),
                            const SizedBox(width: 8),
                            _MacroPill('Fat', '${state.totalFat}g', Colors.pink.shade200),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MacroBar(
                protein: state.totalProtein,
                carbs: state.totalCarbs,
                fat: state.totalFat,
                calories: state.totalCalories,
                goal: state.calorieGoal,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WaterTracker(
                current: state.waterMl,
                goal: state.waterGoal,
                onAdd: (ml) => state.addWater(ml),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          if (state.log.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.restaurant_menu, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text('No food logged yet',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Tap + to add your first meal',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final meals = state.groupedByMeal.entries.toList();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: MealSection(
                      mealName: meals[i].key,
                      entries: meals[i].value,
                      onDelete: (id) => state.removeEntry(id),
                    ),
                  );
                },
                childCount: state.groupedByMeal.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1A9E6B),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Food', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  String _weekday(int d) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1];
  String _month(int m) => ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}

class _MacroPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MacroPill(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
