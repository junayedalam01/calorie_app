import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _goalCtrl;

  @override
  void initState() {
    super.initState();
    _goalCtrl = TextEditingController(
        text: context.read<AppState>().calorieGoal.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A9E6B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Daily Goals',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Calorie Goal (kcal)',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _goalCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF1A9E6B)),
                      ),
                      suffixText: 'kcal',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A9E6B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        final goal = int.tryParse(_goalCtrl.text) ?? 2000;
                        context.read<AppState>().setGoal(goal.clamp(500, 9999));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Goal updated!'),
                            backgroundColor: Color(0xFF1A9E6B),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Save Goal',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Quick Goals',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [1200, 1500, 1800, 2000, 2200, 2500, 3000].map((g) {
              return ActionChip(
                label: Text('$g kcal'),
                backgroundColor: const Color(0xFF1A9E6B).withOpacity(0.1),
                labelStyle: const TextStyle(color: Color(0xFF1A9E6B), fontWeight: FontWeight.w500),
                onPressed: () {
                  setState(() => _goalCtrl.text = g.toString());
                  context.read<AppState>().setGoal(g);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Goal set to $g kcal'),
                      backgroundColor: const Color(0xFF1A9E6B),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          const Text('App Info',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Column(
              children: [
                ListTile(title: Text('Version'), trailing: Text('1.0.0')),
                Divider(height: 1),
                ListTile(title: Text('Food Database'), trailing: Text('40 items')),
                Divider(height: 1),
                ListTile(title: Text('Data Storage'), trailing: Text('Local only')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
