import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/food/presentation/widgets/add_food_quick_actions.dart';
import 'package:calora/features/food/presentation/widgets/add_food_results.dart';
import 'package:calora/features/food/presentation/widgets/add_food_search_field.dart';
import 'package:calora/features/food/presentation/widgets/add_food_tabs.dart';
import 'package:flutter/material.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  static const _tabs = <String>['Recent', 'Favourites', 'Common'];
  static const _foods = <(String, String, String)>[];

  String _selectedTab = 'Recent';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final normalizedQuery = _query.trim().toLowerCase();
    final visible = _foods.where((food) {
      final matchesQuery = food.$2.toLowerCase().contains(normalizedQuery);
      return normalizedQuery.isNotEmpty
          ? matchesQuery
          : food.$1 == _selectedTab;
    }).toList();
    return CaloraPage(
      screenId: 'addfood',
      title: 'Add food',
      child: ListView(
        children: <Widget>[
          CaloraSection(
            child: AddFoodSearchField(
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          CaloraSection(child: AddFoodQuickActions(arguments: arguments)),
          CaloraSection(
            child: AddFoodTabs(
              tabs: _tabs,
              selected: _selectedTab,
              onSelected: (value) => setState(() => _selectedTab = value),
            ),
          ),
          CaloraSection(child: AddFoodResults(foods: visible)),
        ],
      ),
    );
  }
}
