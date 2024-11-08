import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_update.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String username = 'User';
  final FocusNode _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _passFocus.dispose();
  }

  void changePassword() async {
    String title = "Password Changed";
    String content = "Your password has been Changed Successfully!";

    try {
      final response = await updateExistingPassword(_passwordController.text);

      if (mounted) {
        Navigator.of(context).pop();
      }
      if (response == 200) {
      } else if (response == 202) {
        title = "Password Changed Failed";
        content =
            "We couldn't change your password right now\n Please try again later!";
      } else {
        title = "Server Error";
        content =
            "Our Servers are not working right now\n Please try again later!";
      }
    } catch (e) {
      title = "Server Error";
      content =
          "Our Servers are not working right now\n Please try again later!";
      print('Exception: $e');
    }

    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.popUntil(
                        context, (route) => route.settings.name == "/settings");
                  }
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
        title: const Text('Password Recovery'),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   child: TextFormField(
                      //     controller: TextEditingController(text: username),
                      //     style: TextStyle(
                      //         color: Theme.of(context)
                      //             .primaryTextTheme
                      //             .displaySmall
                      //             ?.color),
                      //     readOnly: true,
                      //     decoration: InputDecoration(
                      //         labelText: 'Your Username',
                      //         labelStyle: TextStyle(
                      //             color: Theme.of(context)
                      //                 .primaryTextTheme
                      //                 .displaySmall
                      //                 ?.color),
                      //         border: const OutlineInputBorder(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(12)),
                      //         ),
                      //         fillColor: Theme.of(context).brightness ==
                      //                 Brightness.dark
                      //             ? Colors.grey[1000]
                      //             : Colors.grey[100],
                      //         filled: true,
                      //         prefixIcon: const Icon(
                      //           Icons.person,
                      //           color: Colors.grey,
                      //         )),
                      //     keyboardType: TextInputType.visiblePassword,
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: _passFocus,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall
                                  ?.color),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null ||
                                value.length < 6 ||
                                !value.contains(RegExp(r'[A-Z]')) ||
                                !value.contains(RegExp(r'[a-z]')) ||
                                !value.contains(RegExp(r'[0-9]')) ||
                                !value.contains(
                                  RegExp(r'[@#\$%]'),
                                )) {
                              return 'Password Must satisfy below conditions';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              value;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Please enter new password',
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: 'New Password',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.grey,
                              )),
                          maxLength: 12,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Cancel Password Change'),
                                    content: const Text(
                                        'Do you want to cancel password change process?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.popUntil(
                                              context,
                                              (route) =>
                                                  route.settings.name ==
                                                  "/settings");
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
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _passFocus.unfocus();
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
                                changePassword();
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
                              'Change Password',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*Password must be longer then 6 letters',
                    style: TextStyle(
                        color: _passwordController.text.length > 6
                            ? Colors.green
                            : Colors.red),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*Must Include at least one Uppercase Letter (A-Z)',
                    style: TextStyle(
                      color: _passwordController.text.contains(RegExp(r'[A-Z]'))
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*Must include at least one lowercase letter (a-z)',
                    style: TextStyle(
                      color: _passwordController.text.contains(RegExp(r'[a-z]'))
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*Must include at least one number (0-9)',
                    style: TextStyle(
                      color: _passwordController.text.contains(RegExp(r'[0-9]'))
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*Must inlude a special Character (@,#,\$,%)',
                    style: TextStyle(
                      color: _passwordController.text.contains(
                        RegExp(r'[@#\$%]'),
                      )
                          ? Colors.green
                          : Colors.red,
                    ),
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
