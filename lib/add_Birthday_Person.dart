import 'package:flutter/material.dart';
import 'package:present_planner/my_main_page.dart';

class AddBirthdayPersonPage extends StatefulWidget {
  final List arrayPersonCardValues;

  const AddBirthdayPersonPage({
    Key? key,
    required this.arrayPersonCardValues,
  }) : super(key: key);

  @override
  State<AddBirthdayPersonPage> createState() => _AddBirthdayPersonPageState();
}

class _AddBirthdayPersonPageState extends State<AddBirthdayPersonPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add a New Birthday'),
      ),
      body: Center(
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

                Container(
                  margin: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _dateController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Add a Birthdate',
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                      ),
                    ),
                    readOnly: true,
                    onTap: (){
                      _selectDate();
                    },
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now()
    );

    if (picked != null){
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
        print(_dateController.text);
      });
    }
  }
  void cancelClicked() {
    Navigator.pop(context);
  }

  void saveClicked() {
    String newName = _nameController.text;
    double newBudget = double.parse(_budgetController.text);
    List<PresentCardValues> newList = [];
    DateTime selectedDate = DateTime.parse(_dateController.text);

    widget.arrayPersonCardValues.add(new BirthdayPersonCardValues(name: newName, budget: newBudget, birthDate: selectedDate, presents: newList));

    // Pass back the updated lists
    Navigator.pop(context, true);
  }
}