import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:services/api/dio_signup.dart';
import 'package:services/widgets/aadhar_model.dart';
import 'package:services/widgets/email_model.dart';
import 'package:services/widgets/location_model.dart';
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
  Position? position;
  String? email;
  String? aadhar;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(text: 'example');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWork = listOfWork[0];
    exp = listOfExp[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    position = Provider.of<LocationModel>(context).currentPosition;
    email = Provider.of<EmailModel>(context).email;
    aadhar = Provider.of<AadharModel>(context).aadhar;
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return '${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } catch (e) {
      return 'Error: $e';
    }
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

  void createUser() async {
    if (_formKey.currentState!.validate()) {
      //create user.

      if (selectedWork != listOfWork[0] &&
          exp == listOfExp[0] &&
          position == null) {
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

      String address = await getAddressFromCoordinates(
          position!.latitude, position!.longitude);

      int value = await signupUser(
          username: _userNameController.text,
          fullname: _nameController.text,
          phoneNumber: '1234567899',
          email: _emailController.text,
          aadhar: aadhar!,
          password: _passwordController.text,
          service: selectedWork!,
          exp: exp!,
          profilePictureUrl: pickedImage!.path,
          latitude: position!.latitude,
          longitude: position!.longitude,
          homeLocation: address);

      print(
          'so i got the Locationaddress: $address and homeaddres: ${_houseController.text}${_adressController.text} and username: ${_userNameController.text} and fullname: ${_nameController.text} and password: ${_passwordController.text} and ${_emailController.text} and service:  ${selectedWork} and exp: ${exp} and aadhar: $aadhar and the iamgeLink: ${pickedImage!.path}');

      if (value == 404 || value == 405) {
        print('error in value and ${value}');
      }

      if (mounted && value == 201) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => WorkProfileCreated(
                  isWorkProfile: selectedWork != listOfWork[0]),
            ), (route) {
          return route.settings.name == '/firstScreen';
        });
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Theme.of(context).colorScheme.onPrimary,
  //     appBar: AppBar(
  //       title: const Text(
  //         'Signup',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       foregroundColor: Colors.white,
  //       backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
  //     ),
  //     body: SingleChildScrollView(
  //       child: Container(
  //         decoration: const BoxDecoration(
  //             border: Border(top: BorderSide(color: Colors.black))),
  //         child: Center(
  //             child: Form(
  //           child: Column(
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.all(20),
  //                 child: const Text(
  //                   'Please Fill up your details',
  //                   style: TextStyle(fontSize: 28),
  //                 ),
  //               ),
  //               Container(
  //                 margin:
  //                     const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
  //                 child: Row(
  //                   children: [
  //                     SizedBox(
  //                       height: 100,
  //                       width: 100,
  //                       child: pickedImage == null
  //                           ? Image.asset('assets/logos/user_image.png')
  //                           : FutureBuilder(
  //                               future: pickedImage!.readAsBytes(),
  //                               builder: (context, snapshot) {
  //                                 if (snapshot.connectionState ==
  //                                     ConnectionState.done) {
  //                                   return ClipOval(
  //                                     child: Image.memory(
  //                                       snapshot.data as Uint8List,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                   );
  //                                 } else {
  //                                   // While the image is loading, show a loading indicator
  //                                   return const CircularProgressIndicator();
  //                                 }
  //                               },
  //                             ),
  //                     ),
  //                     const SizedBox(
  //                       width: 30,
  //                     ),
  //                     OutlinedButton(
  //                       onPressed: pickImage,
  //                       child: Text('Upload Image'),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Form(
  //                 key: _formKey,
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       child: TextFormField(
  //                         controller: _userNameController,
  //                         validator: (value) {
  //                           if (value == null ||
  //                               value.isEmpty ||
  //                               value.length < 6)
  //                             return "Username must be of more then 5 letters";
  //                           return null;
  //                         },
  //                         decoration: InputDecoration(
  //                           label: Text('Create Your username'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.name,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       child: TextFormField(
  //                         controller: _nameController,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty)
  //                             return "Please enter you name";
  //                           return null;
  //                         },
  //                         decoration: InputDecoration(
  //                           label: Text('Enter Your full name'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.name,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       color: Colors.brown[50],
  //                       child: TextFormField(
  //                         controller: TextEditingController(text: '8433211426'),
  //                         decoration: InputDecoration(
  //                           label: Text('Your Number'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.name,
  //                         readOnly: true,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       color: Colors.brown[50],
  //                       child: TextFormField(
  //                         controller: TextEditingController(
  //                             text: 'ayushpal5432@gmail.com'),
  //                         decoration: InputDecoration(
  //                           label: Text('Your Email'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.name,
  //                         readOnly: true,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       color: Colors.brown[50],
  //                       child: TextFormField(
  //                         controller: TextEditingController(text: '43434343'),
  //                         decoration: InputDecoration(
  //                           label: Text('Your Aadhar Number'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.name,
  //                         readOnly: true,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       child: TextFormField(
  //                         controller: _passwordController,
  //                         validator: (value) {
  //                           if (value == null || value.length < 8) {
  //                             return "Please enter correct password";
  //                           }
  //                           return null;
  //                         },
  //                         decoration: InputDecoration(
  //                           label: const Text('Create Your password'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.visiblePassword,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       child: TextFormField(
  //                         controller: _houseController,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return "Please enter your house number/flat number";
  //                           }
  //                           return null;
  //                         },
  //                         decoration: InputDecoration(
  //                           label: const Text('House No./Flat No.'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.number,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.all(15),
  //                       child: TextFormField(
  //                         controller: _adressController,
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return "adress/area is required!";
  //                           }
  //                           return null;
  //                         },
  //                         decoration: InputDecoration(
  //                           label: const Text('street adress/area'),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.text,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     const Text(
  //                       'What can you do?',
  //                       style: TextStyle(fontSize: 28),
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     DropdownButton(
  //                       value: selectedWork,
  //                       items: listOfWork
  //                           .map(
  //                             (e) => DropdownMenuItem(
  //                               value: e,
  //                               enabled: true,
  //                               child: Text(e),
  //                             ),
  //                           )
  //                           .toList(),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           selectedWork = value!;
  //                         });
  //                       },
  //                     ),
  //                     const SizedBox(
  //                       height: 30,
  //                     ),
  //                     if (selectedWork != listOfWork[0])
  //                       Column(
  //                         children: [
  //                           Text(
  //                             'Your Experience level',
  //                             style: TextStyle(fontSize: 28),
  //                           ),
  //                           DropdownButton(
  //                             value: exp,
  //                             items: listOfExp
  //                                 .map(
  //                                   (e) => DropdownMenuItem(
  //                                     value: e,
  //                                     enabled: true,
  //                                     child: Text(e),
  //                                   ),
  //                                 )
  //                                 .toList(),
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 exp = value;
  //                               });
  //                             },
  //                           ),
  //                         ],
  //                       )
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   createUser();
  //                 },
  //                 child: const Text('Submit'),
  //               ),
  //               const SizedBox(
  //                 height: 50,
  //               ),
  //             ],
  //           ),
  //         )),
  //       ),
  //     ),
  //   );
  // }

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
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black)),
          ),
          child: Center(
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
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                      ),
                      const SizedBox(width: 30),
                      OutlinedButton(
                        onPressed: pickImage,
                        child: Text('Upload Image'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 350, // Fixed height for the form fields
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    // Make this scrollable
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _userNameController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 6)
                                return "Username must be of more than 5 letters";
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text('Create Your username'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Please enter your name";
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
                          const SizedBox(height: 25),
                          TextFormField(
                            controller:
                                TextEditingController(text: '1234567899'),
                            decoration: InputDecoration(
                              label: Text('Your Number'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            readOnly: true,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: TextEditingController(text: email),
                            decoration: InputDecoration(
                              label: Text('Your Email'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: TextEditingController(text: aadhar),
                            decoration: InputDecoration(
                              label: Text('Your Aadhar Number'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            readOnly: true,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.length < 8) {
                                return "Please enter a correct password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Create Your password'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _houseController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your house number/flat number";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('House No./Flat No.'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _adressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Address/area is required!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Street Address/Area'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'What can you do?',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 10),
                DropdownButton(
                  value: selectedWork,
                  items: listOfWork.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      enabled: true,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWork = value!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                if (selectedWork != listOfWork[0])
                  Column(
                    children: [
                      const Text(
                        'Your Experience Level',
                        style: TextStyle(fontSize: 28),
                      ),
                      DropdownButton(
                        value: exp,
                        items: listOfExp.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            enabled: true,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            exp = value;
                          });
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    createUser();
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
