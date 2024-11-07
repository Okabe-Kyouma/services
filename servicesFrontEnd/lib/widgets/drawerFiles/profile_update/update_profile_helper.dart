import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/api/dio_image_upload.dart';
import 'package:services/api/dio_profile.dart';
import 'package:services/api/dio_update.dart';
import 'package:services/widgets/drawerFiles/profile_update/profile.dart';

class UpdateProfileHelper extends StatefulWidget {
  const UpdateProfileHelper({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  State<UpdateProfileHelper> createState() => _UpdateProfileHelperState();
}

class _UpdateProfileHelperState extends State<UpdateProfileHelper> {
  final ImagePicker picker = ImagePicker();
  ProfileData? profileData;
  String? selectedWork;
  String? exp;
  XFile? pickedImage;
  String? imgurImage = "noimageisavailabletodisplayhere";

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

  @override
  void initState() {
    super.initState();
    profileData = widget.profileData;
    selectedWork = profileData!.service;
    exp = profileData!.experience;
    imgurImage = profileData!.profileImage;
  }

  

  void pickImage() async {
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imgurImage = await imageUploadtoImgur(File(pickedImage!.path));
    }
    setState(() {
      imgurImage;
      pickedImage;
    });
  }

  void updateUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: PopScope(child: CircularProgressIndicator()),
        );
      },
    );

    try {
      print('the image: ${imgurImage}');
      final response = await updateProfile(selectedWork!, exp!, imgurImage!);

      if (response == 200) {
        if (context.mounted) {
          Navigator.pop(context);

          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Profile Updated'),
                content: const Text('Your Profile has been Updated!!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, (route) => route.settings.name == "/update");
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        Navigator.pop(context);

        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Some Error Occurred'),
              content: const Text('Please try again Later!!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          },
        );
        //failure;
      }
    } catch (e) {
      print('Exception : $e');
      //error;
      Navigator.pop(context);

      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Server Error'),
            content: const Text('Please try again Later!!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile Update',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(profileData!.fullName),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: pickedImage == null
                          ? ClipOval(
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/logos/home_logo.png',
                                  image: profileData!.profileImage,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/logos/home_logo.png',
                                      height: 40,
                                      width: 40,
                                    );
                                  },
                                  placeholderErrorBuilder:
                                      (context, error, stackTrace) {
                                    return const CircularProgressIndicator();
                                  },
                                ),
                              ),
                            )
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
                      child: const Text('Upload Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 75,
              ),
              Text(
                'What can you do?',
                style: TextStyle(
                    fontSize: 28,
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
              ),
              const SizedBox(height: 10),
              DropdownButton(
                value: selectedWork,
                style: TextStyle(
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
                items: listOfWork.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    enabled: true,
                    child: Text(
                      e,
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .displaySmall
                              ?.color),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedWork = value!;
                  });
                },
              ),
              const SizedBox(height: 60),
              if (selectedWork != listOfWork[0])
                Column(
                  children: [
                    Text(
                      'Your Experience Level',
                      style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .displaySmall
                              ?.color),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton(
                      value: exp,
                      items: listOfExp.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          enabled: true,
                          child: Text(
                            e,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                    ?.color),
                          ),
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
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text('Cancel Update'),
                            content: const Text(
                                'Do you want to cancel Profile update?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.popUntil(
                                      context,
                                      (route) =>
                                          route.settings.name == "/update");
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    child: const Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                    onPressed: updateUser,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    child: const Text(
                      'Update',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
