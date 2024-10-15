import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/api/dio_logout.dart';
import 'package:services/first_screen.dart';
import 'package:services/widgets/category_class.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Dashboard'),
        actions: [
          TextButton(
              onPressed: () async {

                await logout();
              
              

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: PopScope(
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
        child: Center(
          child: ListView.builder(
            itemCount: listOfWork.length,
            itemBuilder: (context, index) {
              String imagePath = listOfWork[index].values.first;
              String text = listOfWork[index].keys.first;
              return InkWell(
                onTap: () {
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
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.6)),
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
    );
  }
}
