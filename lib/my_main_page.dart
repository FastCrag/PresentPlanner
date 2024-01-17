import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:present_planner/add_Birthday_Person.dart';
import 'package:present_planner/add_Present.dart';
import 'package:present_planner/edit_Present.dart';
import 'package:present_planner/edit_Birthday_Person.dart';
import 'package:present_planner/add_Christmas_Person.dart';
import 'package:present_planner/edit_Christmas_Person.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

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
  late AllValues allValues = AllValues(arrayBirthdayPersonCardValues: [], arrayChristmasPersonCardValues: []);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    AllValues loadedValues = await _loadValues();

    // Check if loadedValues is not null, then assign it to allValues
    if (loadedValues != null) {
      setState(() {
        allValues = loadedValues;
      });
    }

    // Now you can build everything using the loaded data
    build(context);
  }

  void _saveValues(AllValues allValues) async {

    String json = jsonEncode(allValues);

    print(json);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', json);
  }

  Future<AllValues> _loadValues() async {
    //String json = '{"name":"ed2","blah":42,"blah2":4.22222}';

    final prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('data');

    if (json != null && json.isNotEmpty) {
      Map<String, dynamic> jsonMap = jsonDecode(json);
      AllValues loadedValues = AllValues.fromJson(jsonMap);
      print(loadedValues);
      return loadedValues;
    } else {
      // If no data is stored, return a default instance of AllValues
      print('No data has been stored');
      return AllValues(arrayBirthdayPersonCardValues: [], arrayChristmasPersonCardValues: []);
    }
  }

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
                  allValues.arrayBirthdayPersonCardValues.length,
                    (index) => buildAllBirthdayPersonCards(index),
                ),
                addNewBirthdayCard(),
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
                    allValues.arrayChristmasPersonCardValues.length,
                        (index) => buildAllChristmasPersonCards(index),
                  ),
                  addNewChristmasCard(),

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double calcTotalPresentValue(List<PresentCardValues> presents) {
    double totalAmount = 0;
    for (var i = 0; i < presents.length; i++) {
      totalAmount += presents[i].presentAmount;
    }
    return totalAmount;
  }

  double calcBudgetLeftBirthday(List<BirthdayPersonCardValues> arrayCardValues, personIndex) {
    double budgetLeft = 0;
    budgetLeft = (arrayCardValues[personIndex].budget) - (calcTotalPresentValue(arrayCardValues[personIndex].presents));
    return budgetLeft;
  }
  double calcBudgetLeftChristmas(List<ChristmasPersonCardValues> arrayCardValues, personIndex) {
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
    if (allValues.arrayBirthdayPersonCardValues[personIndex].presents == presents) {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPresentPage(
            presentToEdit: allValues.arrayBirthdayPersonCardValues[personIndex].presents[presentIndex],
            arrayPresentCardValues: allValues.arrayBirthdayPersonCardValues[personIndex].presents,
            presentIndex: presentIndex,
          ),
        ),
      );
      if (result != null) {
        _saveValues(allValues);
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
            presentToEdit: allValues.arrayChristmasPersonCardValues[personIndex].presents[presentIndex],
            arrayPresentCardValues: allValues.arrayChristmasPersonCardValues[personIndex].presents,
            presentIndex: presentIndex,
          ),
        ),
      );
      if (result != null) {
        _saveValues(allValues);
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
          arrayPersonCardValues: allValues.arrayBirthdayPersonCardValues,
        ),
      ),
    );
    if (result != null) {
      _saveValues(allValues);
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
          arrayPersonCardValues: allValues.arrayBirthdayPersonCardValues,
          personIndex: personIndex,
        ),
      ),
    );
    if (result != null) {
      _saveValues(allValues);
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
          arrayPresentCardValues: allValues.arrayBirthdayPersonCardValues[personIndex].presents,
        ),
      ),
    );
    if (result != null) {
      _saveValues(allValues);
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
          arrayPersonCardValues: allValues.arrayChristmasPersonCardValues,
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
          arrayPersonCardValues: allValues.arrayChristmasPersonCardValues,
          personIndex: personIndex,
        ),
      ),
    );
    if (result != null) {
      _saveValues(allValues);
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
          arrayPresentCardValues: allValues.arrayChristmasPersonCardValues[personIndex].presents,
        ),
      ),
    );
    if (result != null) {
      _saveValues(allValues);
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

  Widget buildAllPresentCards(int personIndex, int presentIndex, List<PresentCardValues> presents) {

    Color _presentCardColor;
    bool? bought = presents[presentIndex].bought;
    if (bought != null && bought) {
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
                                  _saveValues(allValues);
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
    DateTime dateTime = allValues.arrayBirthdayPersonCardValues[personIndex].birthDate;
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
                            allValues.arrayBirthdayPersonCardValues[personIndex].name.toUpperCase(),
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
                            'Days Left: ' + daysUntilDate(allValues.arrayBirthdayPersonCardValues[personIndex].birthDate).toString(),
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
                            Text('Max Budget: \$' + allValues.arrayBirthdayPersonCardValues[personIndex].budget.toStringAsFixed(2)),
                            Text('Present Total: ' + calcTotalPresentValue(allValues.arrayBirthdayPersonCardValues[personIndex].presents).toStringAsFixed(2)),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            returnBudgetLeft(calcBudgetLeftBirthday(allValues.arrayBirthdayPersonCardValues, personIndex)),
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
                      allValues.arrayBirthdayPersonCardValues[personIndex].presents.length,
                          (presentIndex) => buildAllPresentCards(personIndex, presentIndex, allValues.arrayBirthdayPersonCardValues[personIndex].presents),
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
                              allValues.arrayChristmasPersonCardValues[personIndex].name.toUpperCase(),
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
                              Text('Max Budget: \$' + allValues.arrayChristmasPersonCardValues[personIndex].budget.toString()),
                              Text('Present Total: ' + calcTotalPresentValue(allValues.arrayChristmasPersonCardValues[personIndex].presents).toString()),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              returnBudgetLeft(calcBudgetLeftChristmas(allValues.arrayChristmasPersonCardValues, personIndex)),
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
                        allValues.arrayChristmasPersonCardValues[personIndex].presents.length,
                            (presentIndex) => buildAllPresentCards(personIndex, presentIndex, allValues.arrayChristmasPersonCardValues[personIndex].presents),
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

class TestingValues{
  String name = 'THIS IS THE TEST NAME';
  int blah = 42;
  double blah2 = 4.22222;
  TestingValues({required this.name});


  TestingValues.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        blah = json['blah'] as int,
        blah2 = json['blah2'] as double;

  Map<String, dynamic> toJson() => {
    'name': name,
    'blah': blah,
    'blah2': blah2
  };
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

  List<PresentCardValues> presents = [];
  List<PresentCardValues> get personPresents {
    return presents;
  }
  void set personPresents(List<PresentCardValues> presents) {
    this.presents = presents;
  }
  BirthdayPersonCardValues({required this.name, required this.budget, required this.birthDate, required this.presents});

  BirthdayPersonCardValues.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        budget = json['budget'] as double,
        birthDate = json['birthDate'] != null
            ? DateTime.parse(json['birthDate'] as String)
            : DateTime.now(),
        presents = List<PresentCardValues>.from((json['presents'] as List).map((value) => PresentCardValues.fromJson(value)));

  Map<String, dynamic> toJson() => {
    'name': name,
    'budget': budget,
    'birthDate': birthDate.toIso8601String(),
    'presents': presents
  };
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

  List<PresentCardValues> presents = [];
  List<PresentCardValues> get personPresents {
    return presents;
  }
  void set personPresents(List<PresentCardValues> presents) {
    this.presents = presents;
  }
  ChristmasPersonCardValues({required this.name, required this.budget, required this.presents});

  ChristmasPersonCardValues.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        budget = json['budget'] as double,
        presents = List<PresentCardValues>.from((json['presents'] as List).map((value) => PresentCardValues.fromJson(value)));

  Map<String, dynamic> toJson() => {
    'name': name,
    'budget': budget,
    'presents': presents
  };
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

  PresentCardValues.fromJson(Map<String, dynamic> json)
      : presentName = json['presentName'] as String,
        amount = json['amount'] as double,
        bought = json['bought'] as bool,
        comments = json['comments'] as String;

  Map<String, dynamic> toJson() => {
    'presentName': presentName,
    'amount': amount,
    'bought': bought,
    'comments': comments
  };
}

class AllValues{
  List<BirthdayPersonCardValues> arrayBirthdayPersonCardValues = [];
  List<ChristmasPersonCardValues> arrayChristmasPersonCardValues = [];

  AllValues({required this.arrayBirthdayPersonCardValues, required this.arrayChristmasPersonCardValues});

  AllValues.fromJson(Map<String, dynamic> json)
      : arrayBirthdayPersonCardValues = List<BirthdayPersonCardValues>.from((json['arrayBirthdayPersonCardValues'] as List).map((value) => BirthdayPersonCardValues.fromJson(value))),
        arrayChristmasPersonCardValues = List<ChristmasPersonCardValues>.from((json['arrayChristmasPersonCardValues'] as List).map((value) => ChristmasPersonCardValues.fromJson(value)));

  Map<String, dynamic> toJson() => {
    'arrayBirthdayPersonCardValues': arrayBirthdayPersonCardValues.map((value) => value.toJson()).toList(),
    'arrayChristmasPersonCardValues': arrayChristmasPersonCardValues.map((value) => value.toJson()).toList()

  };
}