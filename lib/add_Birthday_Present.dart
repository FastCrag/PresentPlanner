import 'package:flutter/material.dart';
import 'package:present_planner/my_main_page.dart';

class AddBirthdayPresentPage extends StatefulWidget {
  final List arrayPresentCardValues;

  const AddBirthdayPresentPage({
    Key? key,
    required this.arrayPresentCardValues,
  }) : super(key: key);

  @override
  State<AddBirthdayPresentPage> createState() => _AddBirthdayPresentPageState();
}

class _AddBirthdayPresentPageState extends State<AddBirthdayPresentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add a New Present'),
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
                    labelText: 'Present Name',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                  controller: _amountController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Present Amount',
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                  controller: _commentController,
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Comments/Add a lik',
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
    double newAmount = double.parse(_amountController.text);
    String newComment = _commentController.text;

    // Update the arrays in the specific person
    widget.arrayPresentCardValues.add(PresentCardValues(presentName: newName, amount: newAmount, bought: true, comments: newComment));

    // Pass back the updated lists
    Navigator.pop(context, true);
  }
}