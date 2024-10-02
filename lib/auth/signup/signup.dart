import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/widgets/work_profile_created.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final ImagePicker picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? pickedImage;
  String? selectedWork;
  String? exp;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWork = listOfWork[0];
    exp = listOfExp[0];
  }

  final listOfExp = [
    "Your Experience level",
    "0-1 years",
    "1-2 years",
    "3-4 years",
    "4-5 years",
    "5+ years"
  ];

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
    "Computer Technician",
    "Digital Artist",
    "Driver",
    "Electrician",
    "Gardener",
    "Handyman",
    "Home Tutor",
    "House Cleaner",
    "Laundry Service",
    "Mechanic",
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

  void createUser() {
    if (_formKey.currentState!.validate()) {
      //create user.

      if (selectedWork != listOfWork[0] && exp == listOfExp[0]) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text(
              'PLEASE FILL ALL DETAILS',
            ),
            content: const Text(
              'Please select your experience level',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'))
            ],
          ),
        );
        return;
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WorkProfileCreated(isWorkProfile: selectedWork!=listOfWork[0]),
          ), (route) {
        return route.settings.name == '/firstScreen';
      });
    }
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
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black))),
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
                      SizedBox(
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
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Please enter you name";
                            return null;
                          },
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
                          controller: _emailController,
                          validator: (value) {
                            if (value == null ||
                                !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                              return "Please enter correct mail id";
                            }

                            return null;
                          },
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
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return "Please enter correct password";
                            }
                            return null;
                          },
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
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (selectedWork != listOfWork[0])
                        Column(
                          children: [
                            Text(
                              'Your Experience level',
                              style: TextStyle(fontSize: 28),
                            ),
                            DropdownButton(
                              value: exp,
                              items: listOfExp
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
                                  exp = value;
                                });
                              },
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    createUser();
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
