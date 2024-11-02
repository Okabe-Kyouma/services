// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class ShowProfile extends StatefulWidget {
//   const ShowProfile({super.key});

//   @override
//   State<ShowProfile> createState() => _ShowProfileState();
// }

// class _ShowProfileState extends State<ShowProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.onPrimary,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Signup',
//           style: TextStyle(color: Colors.white),
//         ),
//         foregroundColor: Colors.white,
//         backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
//       ),
//       body: PopScope(
//         canPop: false,
//         child: SingleChildScrollView(
//           child: Container(
//             decoration: const BoxDecoration(
//               border: Border(top: BorderSide(color: Colors.black)),
//             ),
//             child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.all(20),
//                     child: const Text(
//                       'Please Fill up your details',
//                       style: TextStyle(fontSize: 28),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 20),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           height: 100,
//                           width: 100,
//                           child: pickedImage == null
//                               ? Image.asset('assets/logos/user_image.png')
//                               : FutureBuilder(
//                                   future: pickedImage!.readAsBytes(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.done) {
//                                       return ClipOval(
//                                         child: Image.memory(
//                                           snapshot.data as Uint8List,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       );
//                                     } else {
//                                       return const CircularProgressIndicator();
//                                     }
//                                   },
//                                 ),
//                         ),
//                         const SizedBox(width: 30),
//                         OutlinedButton(
//                           onPressed: pickImage,
//                           child: const Text('Upload Image'),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     height: 350, // Fixed height for the form fields
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     child: SingleChildScrollView(
//                       // Make this scrollable
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             TextFormField(
//                               controller: _userNameController,
//                               autovalidateMode: AutovalidateMode.always,
//                               onChanged: (name) {
//                                 _checkUsername();
//                               },
//                               validator: (value) {
//                                 if (value == null ||
//                                     value.isEmpty ||
//                                     value.length < 6) {
//                                   return "Username must be of more than 5 letters";
//                                 } else if (value.contains(' ')) {
//                                   return "Username cannot contain space";
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 label: const Text('Create Your username'),
//                                 hintText: 'Your Username',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 prefixIcon: const Icon(Icons.person,
//                                     color: Colors.grey),
//                               ),
//                               keyboardType: TextInputType.name,
//                             ),
//                             if (checkUsername &&
//                                 _userNameController.text.length > 5)
//                               Text(
//                                 _statusMessage,
//                                 style: TextStyle(
//                                     color: _statusMessage ==
//                                             'Username is available'
//                                         ? Colors.green
//                                         : Colors.red),
//                               ),
//                             const SizedBox(height: 25),
//                             TextFormField(
//                               controller: _nameController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty)
//                                   return "Please enter your name";
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                   label: const Text('Enter Your full name'),
//                                   hintText: 'Your Full Name',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   prefixIcon: const Icon(
//                                     Icons.person_pin_rounded,
//                                     color: Colors.grey,
//                                   )),
//                               keyboardType: TextInputType.name,
//                             ),
//                             const SizedBox(height: 25),
//                             TextFormField(
//                               controller: _passwordController,
//                               validator: (value) {
//                                 if (value == null || value.length < 8) {
//                                   return "Please enter a correct password";
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 label: const Text('Create Your password'),
//                                 hintText: 'Your password',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.password,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               keyboardType: TextInputType.visiblePassword,
//                             ),
//                             const SizedBox(height: 25),
//                             TextFormField(
//                               controller:
//                                   TextEditingController(text: phoneNumber),
//                               decoration: InputDecoration(
//                                 label: const Text('Your Number'),
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.numbers,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               keyboardType: TextInputType.phone,
//                               readOnly: true,
//                             ),
//                             const SizedBox(height: 25),
//                             TextFormField(
//                               controller: TextEditingController(text: email),
//                               decoration: InputDecoration(
//                                 label: const Text('Your Email'),
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.email,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               keyboardType: TextInputType.emailAddress,
//                               readOnly: true,
//                             ),
//                             const SizedBox(height: 25),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   const Text(
//                     'What can you do?',
//                     style: TextStyle(fontSize: 28),
//                   ),
//                   const SizedBox(height: 10),
//                   DropdownButton(
//                     value: selectedWork,
//                     items: listOfWork.map((e) {
//                       return DropdownMenuItem(
//                         value: e,
//                         enabled: true,
//                         child: Text(e),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedWork = value!;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                   if (selectedWork != listOfWork[0])
//                     Column(
//                       children: [
//                         const Text(
//                           'Your Experience Level',
//                           style: TextStyle(fontSize: 28),
//                         ),
//                         DropdownButton(
//                           value: exp,
//                           items: listOfExp.map((e) {
//                             return DropdownMenuItem(
//                               value: e,
//                               enabled: true,
//                               child: Text(e),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               exp = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       OutlinedButton(
//                         onPressed: () {
//                           showCupertinoDialog(
//                             context: context,
//                             builder: (context) {
//                               return CupertinoAlertDialog(
//                                 title: const Text('CANCEL SIGNUP?'),
//                                 content: const Text(
//                                     'Click Yes to Cancel\n Click No to continue;'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       Navigator.popUntil(
//                                           context,
//                                           (route) =>
//                                               route.settings.name ==
//                                               "/firstScreen");
//                                     },
//                                     child: const Text('Yes'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text('No'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 14, horizontal: 24),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(
//                               color: Theme.of(context).primaryColor, width: 2),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       OutlinedButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return const Center(
//                                 child: PopScope(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               );
//                             },
//                           );
//                          // createUser();
//                         },
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 14, horizontal: 24),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           side: BorderSide(
//                               color: Theme.of(context).primaryColor, width: 2),
//                         ),
//                         child: const Text(
//                           'Submit',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
