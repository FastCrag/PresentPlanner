import 'package:flutter/material.dart';
import 'package:present_planner/add_Birthday_Person.dart';
import 'package:present_planner/add_Present.dart';
import 'package:present_planner/edit_Present.dart';
import 'package:present_planner/edit_Birthday_Person.dart';
import 'package:present_planner/add_Christmas_Person.dart';
import 'package:present_planner/edit_Christmas_Person.dart';
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
  var arrayBirthdayPersonCardValues = [];
  var arrayChristmasPersonCardValues = [];
  late AllValues allValues = AllValues(birthdayValues: arrayBirthdayPersonCardValues, christmasValues: arrayChristmasPersonCardValues);

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
                arrayBirthdayPersonCardValues.length,
                    (index) => buildAllBirthdayPersonCards(index),
                ),
                addNewBirthdayCard()
              ]
            ),
          ),
          SingleChildScrollView(
            child: Column(
                children: [
                  Text(
                      'Days Until Christmas: ' + daysUntilDate(DateTime(2000, 12, 25)).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  ...List.generate(
                    arrayChristmasPersonCardValues.length,
                        (index) => buildAllChristmasPersonCards(index),
                  ),
                  addNewChristmasCard()
                ]
            ),
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

  double calcTotalPresentValue(List presents) {
    double totalAmount = 0;
    for (var i = 0; i < presents.length; i++) {
      totalAmount += presents[i].presentAmount;
    }
    return totalAmount;
  }

  double calcBudgetLeft(List arrayCardValues, personIndex) {
    double budgetLeft = 0;
    budgetLeft = (arrayCardValues[personIndex].budget) - (calcTotalPresentValue(arrayCardValues[personIndex].presents));
    return budgetLeft;
  }

  Text returnBudgetLeft(double budgetLeft) {
    Color textColor = Colors.black;
    if (budgetLeft < 0) {
      textColor = Colors.red;
    }
    return Text(
        'Budget Left: ' + budgetLeft.toStringAsFixed(2),
        style: TextStyle(
        color: textColor,
        )
    );
  }

  Future<void> _editPresent(personIndex, presentIndex, presents) async {
    if (arrayBirthdayPersonCardValues[personIndex].presents == presents) {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPresentPage(
            presentToEdit: arrayBirthdayPersonCardValues[personIndex].presents[presentIndex],
            arrayPresentCardValues: arrayBirthdayPersonCardValues[personIndex].presents,
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
    else {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPresentPage(
            presentToEdit: arrayChristmasPersonCardValues[personIndex].presents[presentIndex],
            arrayPresentCardValues: arrayChristmasPersonCardValues[personIndex].presents,
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
  }

  void _addBirthdayPerson() async {
    // Use the Future returned by Navigator.push
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBirthdayPersonPage(
          arrayPersonCardValues: arrayBirthdayPersonCardValues,
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
          arrayPersonCardValues: arrayBirthdayPersonCardValues,
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
        builder: (context) => AddPresentPage(
          arrayPresentCardValues: arrayBirthdayPersonCardValues[personIndex].presents,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        build;
      });
    }
  }

  void _addChristmasPerson() async {
    // Use the Future returned by Navigator.push
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddChristmasPersonPage(
          arrayPersonCardValues: arrayChristmasPersonCardValues,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        build;
      });
    }
  }

  void _editChristmasPerson(personIndex) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChristmasPersonPage(
          arrayPersonCardValues: arrayChristmasPersonCardValues,
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

  void _addChristmasPresent(int personIndex) async {
    // Use the Future returned by Navigator.push
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPresentPage(
          arrayPresentCardValues: arrayChristmasPersonCardValues[personIndex].presents,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        build;
      });
    }
  }

  int daysUntilDate(DateTime inputDate) {
      // Assuming the input date is in the format "MM/dd"
      DateTime currentDate = DateTime.now();
      DateTime targetDate = DateTime(
        currentDate.year,
        inputDate.month,
        inputDate.day,
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

  Widget addNewChristmasCard() {
    return Card(
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.green,
        onTap: () {
          _addChristmasPerson();
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
                      Center(child: Text(' Add a New Person ')),
                    ]
                ),
              )
          ),
        ),
      ),
    );
  }

  Widget buildAllPresentCards(int personIndex, int presentIndex, List presents) {

    Color _presentCardColor;
    if (presents[presentIndex].bought) {
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
          _editPresent(personIndex, presentIndex, presents);
        },
        child: SizedBox(
          width: 300,
            child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          presents[presentIndex].presentName.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Icon(Icons.more_vert_sharp),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '\$' + presents[presentIndex].amount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 18,
                            )
                        ),
                        Row(
                            children: [
                              Text('Mark as Bought?'),
                              Checkbox(
                                value: presents[presentIndex].bought,
                                onChanged: (bool? value) {
                                  setState(() {
                                    presents[presentIndex].bought = value;
                                  });
                                },
                              ),
                            ],
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ),
        ),
      ),
    );
  }

  Widget buildAllBirthdayPersonCards(int personIndex) {
    // Convert your date string to DateTime
    DateTime dateTime = arrayBirthdayPersonCardValues[personIndex].birthDate;
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            arrayBirthdayPersonCardValues[personIndex].name.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Icon(Icons.more_vert_sharp),
                        ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Birthday: ' + formattedDate,
                        ),
                        Text(
                            'Days Left: ' + daysUntilDate(arrayBirthdayPersonCardValues[personIndex].birthDate).toString(),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Max Budget: \$' + arrayBirthdayPersonCardValues[personIndex].budget.toStringAsFixed(2)),
                            Text('Present Total: ' + calcTotalPresentValue(arrayBirthdayPersonCardValues[personIndex].presents).toStringAsFixed(2)),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            returnBudgetLeft(calcBudgetLeft(arrayBirthdayPersonCardValues, personIndex)),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Presents: '),
                      ],
                    ),
                    ...List.generate(
                      arrayBirthdayPersonCardValues[personIndex].presents.length,
                          (presentIndex) => buildAllPresentCards(personIndex, presentIndex, arrayBirthdayPersonCardValues[personIndex].presents),
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
                                Text(' Add A Present'),
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

  Widget buildAllChristmasPersonCards(int personIndex) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.green,
        onTap: () {
          _editChristmasPerson(personIndex);
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              arrayChristmasPersonCardValues[personIndex].name.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Icon(Icons.more_vert_sharp),
                          ]
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Max Budget: \$' + arrayChristmasPersonCardValues[personIndex].budget.toString()),
                              Text('Present Total: ' + calcTotalPresentValue(arrayChristmasPersonCardValues[personIndex].presents).toString()),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              returnBudgetLeft(calcBudgetLeft(arrayChristmasPersonCardValues, personIndex)),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Presents: '),
                        ],
                      ),
                      ...List.generate(
                        arrayChristmasPersonCardValues[personIndex].presents.length,
                            (presentIndex) => buildAllPresentCards(personIndex, presentIndex, arrayChristmasPersonCardValues[personIndex].presents),
                      ),
                      Card(
                        elevation: 5,
                        clipBehavior: Clip.hardEdge,
                        color: Colors.lightGreen,
                        child: InkWell(
                          splashColor: Colors.lightGreenAccent,
                          onTap: () {
                            _addChristmasPresent(personIndex);
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

class BirthdayPersonCardValues{
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
  BirthdayPersonCardValues({required this.name, required this.budget, required this.birthDate, required this.presents});

}

class ChristmasPersonCardValues{
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

  var presents = [];
  List get personPresents {
    return presents;
  }
  void set personPresents(List presents) {
    this.presents = presents;
  }
  ChristmasPersonCardValues({required this.name, required this.budget, required this.presents});

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

class AllValues{
  List birthdayValues = [];
  List christmasValues = [];

  AllValues({required this.birthdayValues, required this.christmasValues});
}