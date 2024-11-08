import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_findUser.dart';
import 'package:services/widgets/drawerFiles/profile_update/phone_update/phone_update_verify_number.dart';

class Number extends StatelessWidget {
  Number({super.key});

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    void checkNumber(String phone) async {
      if (phone.length == 10) {
        final phoneNumber =
            '+91 ${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';

        try {
          await Future.delayed(
            const Duration(microseconds: 1000),
          );
          FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              verificationCompleted: (phoneAuthCredential) {},
              verificationFailed: (error) {
                print(error);
                Navigator.of(context).pop();

                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Server Error!'),
                      content: const Text(
                          'We are having Some Problem!\n Please try again later!'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Okay'))
                      ],
                    );
                  },
                );
              },
              codeSent: (verificationId, forceResendingToken) {
                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberVerification(
                      verificationId: verificationId,
                      phoneNumber: phone,
                    ),
                  ),
                );
              },
              codeAutoRetrievalTimeout: (verificationId) {
                print('auto timeout');
              });
        } catch (e) {
          print('Exception: $e');
          if (context.mounted) {
            Navigator.of(context).pop();

            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('Server Error!'),
                  content: const Text(
                      'We are having Some Problem!\n Please try again later!'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Okay'))
                  ],
                );
              },
            );
          }
        }
      }
    }

    void checkInDb(String phone) async {
      try {
        final response = await checkIfNumberExists(phone);

        if (response == 200) {
          checkNumber(phone);
        } else if (response == 202) {
          if (context.mounted) {
            Navigator.pop(context);

            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('Number already exists'),
                  content: const Text(
                      'This number already exists please change the number'),
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
        } else {
          if (context.mounted) {
            Navigator.pop(context);
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Oops somethings wrong'),
                content: const Text('Server Error ! please try again later!!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Oops somethings wrong'),
              content: const Text('Server Error ! please try again later!!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        }
        print('Exception: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Phone Number',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  'assets/logos/aadhar_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Enter new phone number",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryTextTheme.displaySmall?.color,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _phoneController,
                  focusNode: _focusNode,
                  style: TextStyle(
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Enter your phone number",
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintText: "10-digit phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                  ),
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    } else if (value.length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _focusNode.unfocus();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: PopScope(child: CircularProgressIndicator()),
                        );
                      },
                    );

                    checkInDb(_phoneController.text);

                    //checkNumber(_phoneController.text);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                child: const Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
