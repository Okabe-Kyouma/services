import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:services/auth/signup/email.dart';

class NumberVerification extends StatelessWidget {
  NumberVerification({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Aadhar number',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                  "We have sent an Otp to the number registered to Your aadhar card!",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Email()),
                          );
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
