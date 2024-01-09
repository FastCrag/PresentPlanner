import 'package:flutter/material.dart';
import 'package:present_planner/my_main_page.dart';

class EditBirthdayPersonPage extends StatefulWidget {
  final List arrayPersonCardValues;
  final int personIndex;

  const EditBirthdayPersonPage({
    Key? key,
    required this.arrayPersonCardValues,
    required this.personIndex,
  }) : super(key: key);

  @override
  State<EditBirthdayPersonPage> createState() => _EditBirthdayPersonPageState();
}

class _EditBirthdayPersonPageState extends State<EditBirthdayPersonPage> {
  late TextEditingController _nameController = TextEditingController(text: widget.arrayPersonCardValues[widget.personIndex].name);
  late TextEditingController _budgetController = TextEditingController(text: widget.arrayPersonCardValues[widget.personIndex].budget.toString());
  late TextEditingController _dateController = TextEditingController(text: widget.arrayPersonCardValues[widget.personIndex].birthDate.toString().split(" ")[0]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Birthday'),
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

  void deleteClicked() {
    widget.arrayPersonCardValues.removeAt(widget.personIndex);
    Navigator.pop(context, true);
  }

  void saveClicked() {
    String newName = _nameController.text;
    double newBudget = double.parse(_budgetController.text);
    DateTime selectedDate = DateTime.parse(_dateController.text);

    // update the values for the present
    widget.arrayPersonCardValues[widget.personIndex].name = newName;
    widget.arrayPersonCardValues[widget.personIndex].budget = newBudget;
    widget.arrayPersonCardValues[widget.personIndex].birthDate = selectedDate;

    // Pass back the updated lists
    Navigator.pop(context, true);
  }
}