import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:services/api/dio_login.dart';
import 'package:services/auth/forgotPassword/email.dart';
import 'package:services/widgets/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  void checkIdAndPassword() async {
    if (_formKey.currentState!.validate()) {
      final response = await signIn(
          username: _usernameController.text,
          password: _passwordController.text);

      // await Future.delayed(
      //   const Duration(seconds: 10),
      // );

      if (mounted) {
        Navigator.of(context).pop();
      }

      print('RESPONSE: $response');

      if (response == 200) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else if (response == 202) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Wrong Username or password'),
              content: const Text('Please enter correct username and password'),
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
      } else {
        if (mounted) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).colorScheme.onPrimary,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 120),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/logos/login.png'),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            focusNode: _focusNode,
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              label:
                                  Text('Please enter your registered username'),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.length < 5) {
                                return "Please enter correct username";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            controller: _passwordController,
                            focusNode: _focusNode2,
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text('Please enter your password'),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.length < 8) {
                                return "Please enter correct password";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[400],
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: PopScope(
                                      canPop: false,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              );

                              // showCupertinoDialog(
                              //   context: context,
                              //   builder: (context) {

                              //     return const CupertinoAlertDialog(
                              //       title: Text('PLEASE WAIT'),
                              //       content: SizedBox(
                              //         height: 40,
                              //         width: 40,
                              //         child: Center(
                              //           child: CircularProgressIndicator(),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );

                              checkIdAndPassword();
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Don't remember password?",
                          style: GoogleFonts.montserrat(),
                        ),
                        TextButton(
                          onPressed: () {
                            _focusNode.unfocus();
                            _focusNode2.unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnterEmail(),
                              ),
                            );
                          },
                          child: const Text('Click Here!'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
