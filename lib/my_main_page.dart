import 'package:flutter/material.dart';
import 'package:present_planner/birthday_add_person.dart';
import 'package:present_planner/add_Birthday_Present.dart';
import 'package:present_planner/edit_Birthday_Present.dart';
import 'package:present_planner/edit_Birthday_Person.dart';
import 'package:intl/intl.dart';
import 'dart:core';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _MyMainPageState extends State<MyMainPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  var arrayPersonCardValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Present Planner'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.card_giftcard_sharp),
              text: ("Birthdays"),
            ),
            Tab(
              icon: Icon(Icons.park_sharp),
              text: ("Christmas"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                arrayPersonCardValues.length,
                    (index) => buildAllPersonCards(index),
                ),
                addNewBirthdayCard()
              ]
            ),
          ),
          const Center(
            child: Text("It's rainy here"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "0",
        onPressed: _addBirthdayPerson,
        tooltip: 'Add a Person',
        child: const Icon(Icons.person_add),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double calcTotalPresentValue(int personIndex) {
    double totalAmount = 0;
    for (var i = 0; i < arrayPersonCardValues[personIndex].presents.length; i++) {
      totalAmount += arrayPersonCardValues[personIndex].presents[i].presentAmount;
    }
    return totalAmount;
  }

  double calcBudgetLeft(personIndex) {
    double budgetLeft = 0;
    budgetLeft = (arrayPersonCardValues[personIndex].budget) - (calcTotalPresentValue(personIndex));
    return budgetLeft;
  }

  void _addBirthdayPerson() async {
    // Use the Future returned by Navigator.push
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBirthdayPersonPage(
          arrayPersonCardValues: arrayPersonCardValues,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        build;
      });
    }
  }

  void _editBirthdayPerson(personIndex) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBirthdayPersonPage(
          arrayPersonCardValues: arrayPersonCardValues,
          personIndex: personIndex,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        build;
      });
    }
  }

  void _addBirthdayPresent(int personIndex) async {
    // Use the Future returned by Navigator.push
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBirthdayPresentPage(
          arrayPresentCardValues: arrayPersonCardValues[personIndex].presents,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        build;
      });
    }
  }
  void _editBirthdayPresent(personIndex, presentIndex) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBirthdayPresentPage(
          presentToEdit: arrayPersonCardValues[personIndex].presents[presentIndex],
          arrayPresentCardValues: arrayPersonCardValues[personIndex].presents,
          presentIndex: presentIndex,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        build;
      });
    }
  }

  int daysUntilDate(int index) {
      // Assuming the input date is in the format "MM/dd"
      DateTime currentDate = DateTime.now();
      DateTime targetDate = DateTime(
        currentDate.year,
        arrayPersonCardValues[index].birthDate.month,
        arrayPersonCardValues[index].birthDate.day,
      );

      // If the target date is in the past, add a year to it
      if (targetDate.isBefore(currentDate)) {
        targetDate = DateTime(currentDate.year + 1, targetDate.month, targetDate.day);
      }

      // Calculate the difference in days
      Duration difference = targetDate.difference(currentDate);
      return difference.inDays;
  }

  Widget addNewBirthdayCard() {
    return Card(
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.green,
        onTap: () {
          _addBirthdayPerson();
        },
        child: SizedBox(
          width: 350,
          height: 75,
          child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                    children: <Widget>[
                      Icon(Icons.person_add),
                      Center(child: Text(' Add a New Birthday ')),
                    ]
                ),
              )
          ),
        ),
      ),
    );
  }

  Widget buildAllPresentCards(int personIndex, int presentIndex) {

    Color _presentCardColor;
    if (arrayPersonCardValues[personIndex].presents[presentIndex].bought) {
      _presentCardColor = Colors.lightGreen;
    }
    else {
      _presentCardColor = Colors.red;
    }
    return Card(
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      color: _presentCardColor,
      child: InkWell(
        splashColor: Colors.lightGreenAccent,
        onTap: () {
          _editBirthdayPresent(personIndex, presentIndex);
        },
        child: SizedBox(
          width: 300,
          height: 50,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(arrayPersonCardValues[personIndex].presents[presentIndex].presentName + ': '),
                Text('\$' + arrayPersonCardValues[personIndex].presents[presentIndex].amount.toString()),
                Text('Mark as Bought?'),
                Checkbox(
                    value: arrayPersonCardValues[personIndex].presents[presentIndex].bought,
                    onChanged: (bool? value) {
                      setState(() {
                        arrayPersonCardValues[personIndex].presents[presentIndex].bought = value;
                      });
                    },
                ),
                Icon(Icons.more_vert_sharp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAllPersonCards(int personIndex) {
    // Convert your date string to DateTime
    DateTime dateTime = arrayPersonCardValues[personIndex].birthDate;
    // Format the date in the desired format (MM/dd/yyyy)
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);


    return Card(
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.green,
        onTap: () {
          _editBirthdayPerson(personIndex);
        },
        child: SizedBox(
          width: 350,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(arrayPersonCardValues[personIndex].name),
                            Text(formattedDate),
                            Text('Presents: '),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Max Budget: \$' + arrayPersonCardValues[personIndex].budget.toString()),
                            Text('Present Total: ' + calcTotalPresentValue(personIndex).toString()),
                            Text('Budget Left: ' + calcBudgetLeft(personIndex).toString()),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.more_vert_sharp),
                            Text('Days Left: ' + daysUntilDate(personIndex).toString()),
                          ],
                        ),
                      ],
                    ),
                    ...List.generate(
                      arrayPersonCardValues[personIndex].presents.length,
                          (presentIndex) => buildAllPresentCards(personIndex, presentIndex),
                    ),
                    Card(
                      elevation: 5,
                      clipBehavior: Clip.hardEdge,
                      color: Colors.lightGreen,
                      child: InkWell(
                        splashColor: Colors.lightGreenAccent,
                        onTap: () {
                          _addBirthdayPresent(personIndex);
                        },
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                Text(' Add another Present'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
              ]

              )


            ),
          ),
        ),
      ),
    );
  }
}

class PersonCardValues{
  String name = '';
  String get personName {
    return name;
  }
  void set personName(String name) {
    this.name = name;
  }

  double budget= 0;
  double get personBudget {
    return budget;
  }
  void set personBudget(double budget) {
    this.budget = budget;
  }

  DateTime birthDate = DateTime.now();
  DateTime get personBirthDate {
    return birthDate;
  }
  void set personBirthDate(DateTime birthDate) {
    this.birthDate = birthDate;
  }

  var presents = [];
  List get personPresents {
    return presents;
  }
  void set personPresents(List presents) {
    this.presents = presents;
  }
  PersonCardValues({required this.name, required this.budget, required this.birthDate, required this.presents});

}

class PresentCardValues{
  String presentName = '';
  String get presentNameGetter {
    return presentName;
  }
  void set presentNameGetter(String presentName) {
    this.presentName = presentName;
  }

  String comments = '';
  String get presentComments {
    return comments;
  }
  void set presentComments(String comments) {
    this.comments = comments;
  }

  double amount= 0;
  double get presentAmount {
    return amount;
  }
  void set presentAmount(double amount) {
    this.amount = amount;
  }

  bool? bought;
  bool? get presentBought {
    return bought;
  }
  void set presentBought(bool? bought) {
    this.bought = bought;
  }

  PresentCardValues({required this.presentName, required this.amount, required this.bought, required this.comments});

}