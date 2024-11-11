import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:services/widgets/category_class.dart';

class DashboardHelper extends StatefulWidget {
  const DashboardHelper({super.key});

  @override
  State<DashboardHelper> createState() => _DashboardHelperState();
}

class _DashboardHelperState extends State<DashboardHelper> {
  List<Map<String, String>> listOfWork = [
    {"AC Technician": "assets/images/ac.jpeg"},
    {"Babysitter/Nanny": "assets/images/nanny.jpeg"},
    {"Barber": "assets/images/barber.jpeg"},
    {"Beautician": "assets/images/beauty.jpeg"},
    {"Carpenter": "assets/images/carpentar.jpeg"},
    {"Chef": "assets/images/chef.jpeg"},
    {"Cleaner": "assets/images/cleaner.jpeg"},
    {"Construction Worker": "assets/images/construction.jpeg"},
    {"Computer Technician": "assets/images/computer.jpeg"},
    {"Digital Artist": "assets/images/digital.jpeg"},
    {"Driver": "assets/images/driver.jpeg"},
    {"Electrician": "assets/images/electrician.jpeg"},
    {"Gardener": "assets/images/gardener.jpeg"},
    {"Handyman": "assets/images/handyman.jpeg"},
    {"Home Tutor": "assets/images/homeTutor.jpeg"},
    {"House Cleaner": "assets/images/houseCleaner.jpeg"},
    {"Laundry Service": "assets/images/laundry.jpeg"},
    {"Mechanic": "assets/images/mechanic.jpeg"},
    {"Mover": "assets/images/movers.jpeg"},
    {"Painter": "assets/images/painter.jpeg"},
    {"Pest Control": "assets/images/pest.jpeg"},
    {"Personal Trainer": "assets/images/fitness.jpeg"},
    {"Photographer": "assets/images/photo.jpeg"},
    {"Plumber": "assets/images/plumber.jpeg"},
    {"Security Guard": "assets/images/security.jpeg"},
    {"Tailor": "assets/images/tailor.jpeg"},
    {"Welder": "assets/images/welder.jpeg"},
    {"Yoga Instructor": "assets/images/yoga.jpeg"}
  ];

  List<Map<String, String>> _filteredList = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _filteredList = listOfWork;
  }

  void changeList(String value) {
    List<Map<String, String>> results = [];

    if (value.isEmpty) {
      results = listOfWork;
      _focusNode.unfocus();
    } else {
      results = listOfWork.where(
        (element) {
          return element.keys.first
              .toLowerCase()
              .trim()
              .contains(value.toLowerCase().trim());
        },
      ).toList();
    }
    setState(() {
      _filteredList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Do you want to exit?'),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
            ],
          ),
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: SearchBar(
              focusNode: _focusNode,
              leading: const Icon(Icons.search_rounded),
              hintText: 'Electrician , plumber....',
              autoFocus: false,
              keyboardType: TextInputType.name,
              onTapOutside: (event) {
                _focusNode.unfocus();
              },
              onChanged: (value) {
                changeList(value);
              },
            ),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  String imagePath = _filteredList[index].values.first;
                  String text = _filteredList[index].keys.first;
                  return InkWell(
                    onTap: () {
                      _focusNode.unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryClass(text: text, imageLink: imagePath),
                        ),
                      );
                    },
                    child: Card(
                      child: Stack(
                        children: [
                          Hero(
                            tag: text,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            height: 55,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 170),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6)),
                            child: Text(
                              text,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 25),
                            ),
                          )
                          // Positioned(
                          //   top: 190,
                          //   left: 115,
                          //   child: Text(
                          //     text,
                          //     style: TextStyle(fontSize: 25),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
