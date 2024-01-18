import 'package:flutter/material.dart';
import 'package:present_planner/my_main_page.dart';

class AddPresentPage extends StatefulWidget {
  final List arrayPresentCardValues;

  const AddPresentPage({
    Key? key,
    required this.arrayPresentCardValues,
  }) : super(key: key);

  @override
  State<AddPresentPage> createState() => _AddPresentPageState();
}

class _AddPresentPageState extends State<AddPresentPage> {
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _amountController = TextEditingController(text: "");
  final TextEditingController _commentController = TextEditingController(text: "");
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add a New Present'),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      labelText: 'Comments/Add a link',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Have you bought this item already?'),
                        Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value;
                              });
                            },
                        )
                      ]
                  ),
                ),
              ],
            ),
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
    double newAmount;
    if (_amountController.text == ''){
      newAmount = 0;
    }
    else {
      newAmount = double.parse(_amountController.text);
    };
    String newComment = _commentController.text;
    bool? newBought = isChecked;

    // Update the arrays in the specific person
    widget.arrayPresentCardValues.add(PresentCardValues(presentName: newName, amount: newAmount, bought: newBought, comments: newComment));

    // Pass back the updated lists
    Navigator.pop(context, true);
  }
}