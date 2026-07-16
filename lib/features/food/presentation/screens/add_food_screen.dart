import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/food/presentation/widgets/add_food_quick_actions.dart';
import 'package:flutter/material.dart';

class AddFoodScreen extends StatelessWidget {
  const AddFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    return CaloraPage(
      screenId: 'addfood',
      title: 'Add food',
      child: ListView(
        children: <Widget>[
          CaloraSection(child: AddFoodQuickActions(arguments: arguments)),
        ],
      ),
    );
  }
}
