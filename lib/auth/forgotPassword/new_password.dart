import 'package:flutter/material.dart';
import 'package:services/auth/login/login.dart';

class NewPassword extends StatelessWidget {
  NewPassword({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Recovery'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.asset('assets/logos/reset_password.png',
                      fit: BoxFit.cover),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Password Must satisfy below conditions';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Please enter new password'),
                            hintText: 'New Password',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          maxLength: 12,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Password Must satisfy below conditions';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Please re-enter new Password'),
                            hintText: 'Re-enter new Password',
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
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Login(),
                            //   ),
                            //   (Route<dynamic> route) {
                            //     return route is MaterialPageRoute &&
                            //         route.settings.name == "/login";
                            //   },
                            // );
                            Navigator.popUntil(context,
                                (route) => route.settings.name == "/login");
                          }
                        },
                        child: const Text('Change Password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*Password must be of at least 6 characters long',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child:
                      Text('*Must Include at least one Uppercase Letter (A-Z)'),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child:
                      Text('*Must include at least one lowercase letter (a-z)'),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text('*Must include at least one number (0-9)'),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text('*Must inlude a special Character (@,#,\$,%)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
