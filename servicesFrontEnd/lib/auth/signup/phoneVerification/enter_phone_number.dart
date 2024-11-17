import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_findUser.dart';
import 'package:services/auth/signup/phoneVerification/verify_phone_number.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                      title:  Text(AppLocalizations.of(context)!.loginScreenErrorTitle),
                      content:  Text(
                         AppLocalizations.of(context)!.loginScreenErrorContent),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.okay),)
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
                  title: Text(AppLocalizations.of(context)!.loginScreenErrorTitle),
                  content: Text(
                     AppLocalizations.of(context)!.loginScreenErrorContent),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.okay),)
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
                  title: Text(AppLocalizations.of(context)!.signupEnterPhoneAlreadyExTitle),
                  content:  Text(
                      AppLocalizations.of(context)!.signupEnterPhoneAleadyExContent),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.singupEnterPhoneLogin),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:  Text(AppLocalizations.of(context)!.signupEnterPhoneConti),
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
                title: Text(AppLocalizations.of(context)!.loginScreenErrorTitle),
                content:  Text(AppLocalizations.of(context)!.loginScreenErrorContent),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:  Text(AppLocalizations.of(context)!.okay),
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
              title: Text(AppLocalizations.of(context)!.loginScreenErrorTitle),
              content:  Text(AppLocalizations.of(context)!.loginScreenErrorContent),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.okay),
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
        title:  Text(
         AppLocalizations.of(context)!.changeNumberAppBar,
          style: const TextStyle(color: Colors.white),
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
               AppLocalizations.of(context)!.changeNumVerifyAppBar,
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
                    labelText:  AppLocalizations.of(context)!.changeNumberLabel,
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintText: AppLocalizations.of(context)!.changeNumberHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                  ),
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.changeNumberValidA;
                    } else if (value.length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return AppLocalizations.of(context)!.changeNumberValidB;
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
                child: Text(
                  AppLocalizations.of(context)!.changeNumberSendOtp,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
