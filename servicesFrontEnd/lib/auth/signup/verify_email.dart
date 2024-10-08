import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:services/auth/signup/signup.dart';
import 'package:services/widgets/email_model.dart';

class VerifyEmail extends StatelessWidget {
  VerifyEmail({super.key,required this.email});

  String email;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Email-id',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 170),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/logos/otp.png', fit: BoxFit.cover),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "We have sent an Otp to your registered email id",
                  style: GoogleFonts.akatab(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _otpController,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) {
                            if (value == null ||
                                value.length < 12 ||
                                !RegExp(r'^\d{12}$').hasMatch(value)) {
                              return 'Otp Must be of 6 letters';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('OTP'),
                            hintText: 'Enter Otp',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          if (EmailOTP.verifyOTP(otp: _otpController.text)) {
                            
                            Provider.of<EmailModel>(context, listen: false)
                                .updateEmail(email);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()),
                            );
                          } else {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Wront OTP'),
                                  content: const Text(
                                      'Please enter the correct otp which is send to your email!'),
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
                        },
                        child: const Text('Verify'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
