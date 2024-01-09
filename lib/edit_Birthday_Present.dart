import 'package:flutter/material.dart';
import 'package:present_planner/my_main_page.dart';

class EditBirthdayPresentPage extends StatefulWidget {
  final PresentCardValues presentToEdit;
  final List arrayPresentCardValues;
  final int presentIndex;

  const EditBirthdayPresentPage({
    Key? key,
    required this.presentToEdit,
    required this.arrayPresentCardValues,
    required this.presentIndex,
  }) : super(key: key);

  @override
  State<EditBirthdayPresentPage> createState() => _EditBirthdayPresentPageState();
}

class _EditBirthdayPresentPageState extends State<EditBirthdayPresentPage> {
  late TextEditingController _nameController = TextEditingController(text: widget.presentToEdit.presentName);
  late TextEditingController _amountController = TextEditingController(text: widget.presentToEdit.amount.toString());
  late TextEditingController _commentController = TextEditingController(text: widget.presentToEdit.comments);
  late bool? isChecked = widget.presentToEdit.bought;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Edit Present'),
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
                  child: TextFormField(
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
        floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),

          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "1",
                backgroundColor: Colors.red[200],
                child: Text('Delete'),
                onPressed: () => deleteClicked(),
              ),
              Container(
                child: Row(
                  children:[
                    FloatingActionButton(
                      heroTag: "3",
                      backgroundColor: Colors.white12,
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
    widget.arrayPresentCardValues.removeAt(widget.presentIndex);
    Navigator.pop(context, true);
  }

  void saveClicked() {
    String newName = _nameController.text;
    double newAmount = double.parse(_amountController.text);
    String newComment = _commentController.text;
    bool? newBought = isChecked;

    // update the values for the present
    widget.presentToEdit.presentName = newName;
    widget.presentToEdit.amount = newAmount;
    widget.presentToEdit.comments = newComment;
    widget.presentToEdit.bought = newBought;

    // Pass back the updated lists
    Navigator.pop(context, true);
  }
}