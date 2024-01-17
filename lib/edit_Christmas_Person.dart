import 'package:flutter/material.dart';
import 'package:present_planner/my_main_page.dart';

class EditChristmasPersonPage extends StatefulWidget {
  final List arrayPersonCardValues;
  final int personIndex;

  const EditChristmasPersonPage({
    Key? key,
    required this.arrayPersonCardValues,
    required this.personIndex,
  }) : super(key: key);

  @override
  State<EditChristmasPersonPage> createState() => _EditChristmasPersonPageState();
}

class _EditChristmasPersonPageState extends State<EditChristmasPersonPage> {
  late TextEditingController _nameController = TextEditingController(text: widget.arrayPersonCardValues[widget.personIndex].name);
  late TextEditingController _budgetController = TextEditingController(text: widget.arrayPersonCardValues[widget.personIndex].budget.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Person'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Please Change Any Necessary Information',
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
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),

        child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "1",
                backgroundColor: Colors.red,
                child: Text('Delete'),
                onPressed: () => deleteClicked(),
              ),
              Container(
                child: Row(
                    children:[
                      FloatingActionButton(
                        heroTag: "3",
                        backgroundColor: Colors.white30,
                        child: Text('Cancel'),
                        onPressed: () => cancelClicked(),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FloatingActionButton(
                        heroTag: "2",
                        child: Text('Save'),
                        onPressed: () => saveClicked(),
                      ),
                    ]
                ),
              ),
            ]
        ),
      ),
    );
  }

  void cancelClicked() {
    Navigator.pop(context);
  }

  void deleteClicked() {
    widget.arrayPersonCardValues.removeAt(widget.personIndex);
    Navigator.pop(context, true);
  }

  void saveClicked() {
    String newName = _nameController.text;
    double newBudget = double.parse(_budgetController.text);

    // update the values for the present
    widget.arrayPersonCardValues[widget.personIndex].name = newName;
    widget.arrayPersonCardValues[widget.personIndex].budget = newBudget;

    // Pass back the updated lists
    Navigator.pop(context, true);
  }
}