import 'package:flutter/material.dart';
import 'package:present_planner/my_main_page.dart';

class AddChristmasPersonPage extends StatefulWidget {
  final List arrayPersonCardValues;

  const AddChristmasPersonPage({
    Key? key,
    required this.arrayPersonCardValues,
  }) : super(key: key);

  @override
  State<AddChristmasPersonPage> createState() => _AddChristmasPersonPageState();
}

class _AddChristmasPersonPageState extends State<AddChristmasPersonPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add a New Person'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Please Fill Out All the Information',
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                  controller: _nameController,
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add a Name',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                  controller: _budgetController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add a Budget',
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "1",
                child: Text('Save'),
                onPressed: () => saveClicked(),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                heroTag: "2",
                child: Text('Cancel'),
                onPressed: () => cancelClicked(),
              )
            ]
        )
    );
  }

  void cancelClicked() {
    Navigator.pop(context);
  }

  void saveClicked() {
    String newName = _nameController.text;
    double newBudget = double.parse(_budgetController.text);
    List newList = [];

    widget.arrayPersonCardValues.add(new ChristmasPersonCardValues(name: newName, budget: newBudget, presents: newList));

    // Pass back the updated lists
    Navigator.pop(context, true);
  }
}