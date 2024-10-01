import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/widgets/dashboard.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final ImagePicker picker = ImagePicker();

  XFile? pickedImage;
  String? selectedWork;
  @override
  void initState() {
    super.initState();
    selectedWork = listOfWork[0];
  }

  final listOfWork = [
    "Not looking for work",
    "AC Technician",
    "Babysitter/Nanny",
    "Barber",
    "Beautician",
    "Carpenter",
    "Chef",
    "Cleaner",
    "Construction Worker",
    "Cook",
    "Computer Technician",
    "Digital Artist",
    "Driver",
    "Electrician",
    "Gardener",
    "Gardener Helper",
    "Handyman",
    "Home Tutor",
    "House Cleaner",
    "Laundry Service",
    "Mason",
    "Mechanic",
    "Mobile Repair",
    "Mover",
    "Painter",
    "Pest Control",
    "Personal Trainer",
    "Photographer",
    "Plumber",
    "Security Guard",
    "Tailor",
    "Vehicle Repair",
    "Welder",
    "Yoga Instructor"
  ];

  void pickImage() async {
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: const Text(
          'Signup',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              border: const Border(top: BorderSide(color: Colors.black))),
          child: Center(
              child: Form(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                    'Please Fill up your details',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: pickedImage == null
                            ? Image.asset('assets/logos/user_image.png')
                            : FutureBuilder(
                                future: pickedImage!.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ClipOval(
                                      child: Image.memory(
                                        snapshot.data as Uint8List,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    // While the image is loading, show a loading indicator
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      OutlinedButton(
                          onPressed: pickImage, child: Text('Upload Image'))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('Enter Your full name'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('Enter Your Email-id'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('Create Your password'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'What can you do?',
                        style: TextStyle(fontSize: 28),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                          value: selectedWork,
                          items: listOfWork
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  enabled: true,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedWork = value!;
                            });
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboard(),
                        ), (route) {
                      return route.settings.name == '/firstScreen';
                    });
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
