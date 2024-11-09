import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:services/api/dio_check_existingUser.dart';
import 'package:services/widgets/drawerFiles/optionsMenuItems/settingsOption/email_update/email_update_verify_email.dart';

class Email extends StatelessWidget {
  Email({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final FocusNode _focusNode = FocusNode();

    void main() {
      EmailOTP.config(
          appName: 'Services',
          otpType: OTPType.numeric,
          expiry: 30000,
          emailTheme: EmailTheme.v3,
          otpLength: 6,
          appEmail: 'ayushpal5432@gmail.com');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verification'),
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: PopScope(
        canPop: true,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Image.asset('assets/logos/email.png', fit: BoxFit.cover),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Please enter your Email-id",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _focusNode,
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .displaySmall
                                ?.color),
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                            return "Please enter correct mail id";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Email-id',
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: 'company12@gmail.com',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            )),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              _focusNode.unfocus();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: PopScope(
                                        canPop: false,
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  });

                              final response = await checkIfEmailExistsInDb(
                                  _emailController.text);

                              if (response == 202) {
                                Navigator.of(context).pop();

                                showCupertinoDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title:
                                          const Text('Email already exists!'),
                                      content: const Text(
                                          'The Email-id you have provided already exists,please go to main page to login or enter different email-id!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Okay'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (response == 200) {
                                if (await EmailOTP.sendOTP(
                                    email: _emailController.text)) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyEmail(
                                          email: _emailController.text),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Otp failed send")),
                                  );
                                }
                              } else if (response == 500 || response == 404) {
                                Navigator.of(context).pop();

                                showCupertinoDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Server is Down!'),
                                      content: const Text(
                                          'Our server are down!Please try again later!'),
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
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                          ),
                          child: const Text(
                            'Send Otp',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
