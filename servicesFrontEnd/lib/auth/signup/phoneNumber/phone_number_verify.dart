import 'package:flutter/material.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

class PhoneNumberVerify extends StatefulWidget {
  const PhoneNumberVerify({super.key});

  @override
  State<PhoneNumberVerify> createState() => _PhoneNumberVerifyState();
}

class _PhoneNumberVerifyState extends State<PhoneNumberVerify> {
  bool hasUserLogin = false;
  String useraccessToken = "";
  String jwtUserToken = "";

  @override
  void initState() {
    super.initState();
    hasUserLogin = false;
  }

  @override
  Widget build(BuildContext context) {
    PhoneEmail.initializeApp(clientId: '18691379438484868881');

    Widget currentWidget = Align(
      alignment: Alignment.center,
      child: PhoneLoginButton(
        borderRadius: 10,
        buttonColor: Colors.teal,
        label: 'Login with Phone',
        onSuccess: (String accessToken, String jwtToken) {
          if (accessToken.isNotEmpty) {
            setState(() {
              useraccessToken = accessToken;
              jwtUserToken = jwtToken;
              hasUserLogin = true;
            });
          }
        },
      ),
    );

    return hasUserLogin
        ? currentWidget
        : PhoneEmail.getUserInfo(
            accessToken: useraccessToken,
            clientId: '18691379438484868881',
            onSuccess: (userData) {
              setState(() {
                // phoneEmailUserModel = userData;
                // var countryCode = phoneEmailUserModel?.countryCode;
                // var phoneNumber = phoneEmailUserModel?.phoneNumber;
                // var firstName = phoneEmailUserModel?.firstName;
                // var lastName = phoneEmailUserModel?.lastName;
                // Use this verified phone number to register user and create your session

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('done'),),
                );
              });
            },
          );
  }
}
