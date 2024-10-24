import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:services/auth/signup/addharVerfication/verify_aadhar_number.dart';

class Number extends StatefulWidget {
  const Number({super.key});

  @override
  State<Number> createState() => _NumberState();
}

class _NumberState extends State<Number> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _aadharController = TextEditingController();

  void checkAadharNumber() {
    if (_formkey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NumberVerification(
            aadharNumber: _aadharController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Aadhar Number',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 180),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/logos/aadhar_logo.png',
                        fit: BoxFit.cover)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Please enter your Aadhar number:",
                  style: GoogleFonts.akatab(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _aadharController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null ||
                                value.length < 12 ||
                                !RegExp(r'^\d{12}$').hasMatch(value)) {
                              return 'Aadhar number must be of 12 numbers';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Aadhar Number'),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          maxLength: 12,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: checkAadharNumber,
                        child: const Text('SEND OTP'),
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
