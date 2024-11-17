import 'dart:io';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:services/api/dio_check_existingUser.dart';
import 'package:services/api/dio_image_upload.dart';
import 'package:services/api/dio_signup.dart';
import 'package:services/widgets/providerModels/aadhar_model.dart';
import 'package:services/widgets/providerModels/email_model.dart';
import 'package:services/widgets/providerModels/location_model.dart';
import 'package:services/widgets/work_profile_created.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? phoneNumber;
  String? imgurImage = "noimageisavailabletodisplayhere";
  String _statusMessage = 'Username is available';
  bool checkUsername = false;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _houseController = TextEditingController();
  // final TextEditingController _adressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWork = listOfWork[0];
    exp = listOfExp[0];
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    position = Provider.of<LocationModel>(context).currentPosition;
    email = Provider.of<EmailModel>(context).email;
    phoneNumber = Provider.of<AadharModel>(context).aadhar;
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
    if (pickedImage != null) {
      imgurImage = await imageUploadtoImgur(File(pickedImage!.path));
    }
    setState(() {
      imgurImage;
      pickedImage;
    });
  }

  void _checkUsername() async {
    bool usernameExists = await checkIfUsernameExists(_userNameController.text);

    setState(() {
      if (usernameExists) {
        _statusMessage = AppLocalizations.of(context)!.signupUsernameIsUp;
      } else {
        _statusMessage = AppLocalizations.of(context)!.signupUsernameIsDown;
      }
      checkUsername = true;
    });
  }

  void createUser() async {
    if (_formKey.currentState!.validate()) {
      //create user.

      if ((selectedWork != listOfWork[0] && exp == listOfExp[0]) ||
          (position == null)) {
        Navigator.of(context).pop();
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(
              AppLocalizations.of(context)!.signupPleaseFill,
            ),
            content: Text(
              AppLocalizations.of(context)!.signupPleaseSelect,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.okay),
              )
            ],
          ),
        );
        return;
      }

      // String address = await getAddressFromCoordinates(
      //     position!.latitude, position!.longitude);

      // print(
      //     'so i got the Locationaddress: $address and homeaddres: ${_houseController.text}${_adressController.text} and username: ${_userNameController.text} and fullname: ${_nameController.text} and password: ${_passwordController.text} and $email and service:  ${selectedWork} and exp: ${exp} and aadhar: $aadhar and the iamgeLink: ${pickedImage!.path}');
      // String homeAdd =
      //   "H.NO.- ${_houseController.text} , ${_adressController.text}";
      final response = await signupUser(
        username: _userNameController.text,
        fullname: _nameController.text,
        phoneNumber: phoneNumber!,
        email: email!,
        password: _passwordController.text,
        service: selectedWork!,
        exp: exp!,
        profilePictureUrl: imgurImage!,
        latitude: position!.latitude,
        longitude: position!.longitude,
      );

      if (response == 404) {
        // print('error in value and ${response}');

        if (mounted) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    AppLocalizations.of(context)!.forgotPassResetServerError),
                content:
                    Text(AppLocalizations.of(context)!.loginScreenErrorContent),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.okay),
                  )
                ],
              );
            },
          );
        }
      } else if (response == 200) {
        if (mounted) {
          Navigator.of(context).pop();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => WorkProfileCreated(
                isWorkProfile: selectedWork != listOfWork[0],
              ),
            ),
            (route) {
              return route.settings.name == '/firstScreen';
            },
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return CupertinoAlertDialog(
                title:
                    Text(AppLocalizations.of(context)!.loginScreenErrorTitle),
                content:
                    Text(AppLocalizations.of(context)!.signupWeAlreadyFound),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkProfileCreated(
                            isWorkProfile: false,
                          ),
                        ),
                        (route) {
                          return route.settings.name == "/login";
                        },
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.okay),
                  )
                ],
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.signupAppBar,
          style: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black)),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      AppLocalizations.of(context)!.signupPleaseFillUp,
                      style: TextStyle(
                          fontSize: 28,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .displaySmall
                              ?.color),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
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
                          child: Text(AppLocalizations.of(context)!
                              .profileUpdateUploadImage),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 350, // Fixed height for the form fields
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                              autovalidateMode: AutovalidateMode.always,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      ?.color),
                              onChanged: (name) {
                                _checkUsername();
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return AppLocalizations.of(context)!
                                      .signupValidA;
                                } else if (value.contains(' ')) {
                                  AppLocalizations.of(context)!.signupValidB;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text(
                                    AppLocalizations.of(context)!.signupLabelA),
                                hintText:
                                    AppLocalizations.of(context)!.signupHintA,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.grey),
                              ),
                              keyboardType: TextInputType.name,
                            ),
                            if (checkUsername &&
                                _userNameController.text.length > 5)
                              Text(
                                _statusMessage,
                                style: TextStyle(
                                    color: (_statusMessage ==
                                                'Username is available') ||
                                            (_statusMessage ==
                                                'यूज़रनेम उपलब्ध है।')
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: _nameController,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      ?.color),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return AppLocalizations.of(context)!
                                      .singupValidC;
                                return null;
                              },
                              decoration: InputDecoration(
                                  label: Text(AppLocalizations.of(context)!
                                      .signupValidEnterFullnameLabel),
                                  hintText: AppLocalizations.of(context)!
                                      .signupValidEnterFullnameContent,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person_pin_rounded,
                                    color: Colors.grey,
                                  )),
                              keyboardType: TextInputType.name,
                            ),
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      ?.color),
                              validator: (value) {
                                if (value == null || value.length < 8) {
                                  return AppLocalizations.of(context)!
                                      .signupValidD;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text(AppLocalizations.of(context)!
                                    .signupPassLabel),
                                hintText: AppLocalizations.of(context)!
                                    .signupPassContent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.grey,
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 25),
                            TextFormField(
                              controller:
                                  TextEditingController(text: phoneNumber),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      ?.color),
                              decoration: InputDecoration(
                                label: Text(AppLocalizations.of(context)!
                                    .signupYourNum),
                                filled: true,
                                fillColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[1000]
                                    : Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                prefixIcon: const Icon(
                                  Icons.numbers,
                                  color: Colors.grey,
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              readOnly: true,
                            ),
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: TextEditingController(text: email),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      ?.color),
                              decoration: InputDecoration(
                                label: Text(AppLocalizations.of(context)!
                                    .signupYourEmail),
                                filled: true,
                                fillColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[1000]
                                    : Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    AppLocalizations.of(context)!.signupWhatCan,
                    style: TextStyle(
                        fontSize: 28,
                        color: Theme.of(context)
                            .primaryTextTheme
                            .displaySmall
                            ?.color),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton(
                    value: selectedWork,
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .displaySmall
                            ?.color),
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
                  const SizedBox(height: 30),
                  if (selectedWork != listOfWork[0])
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.signupYourExp,
                          style: TextStyle(
                              fontSize: 28,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall
                                  ?.color),
                        ),
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text(AppLocalizations.of(context)!
                                    .signupCancelSignup),
                                content: Text(AppLocalizations.of(context)!
                                    .signupCancelSignupContent),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.popUntil(
                                          context,
                                          (route) =>
                                              route.settings.name ==
                                              "/firstScreen");
                                    },
                                    child:
                                        Text(AppLocalizations.of(context)!.yes),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Text(AppLocalizations.of(context)!.no),
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
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: PopScope(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          );
                          createUser();
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
                        child: Text(
                          AppLocalizations.of(context)!.signupsubmit,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
