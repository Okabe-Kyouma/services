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
  final ScrollController _scrollController = ScrollController();
  bool obsPassword = true;
  Icon obsIcon = const Icon(
    Icons.lock_outline_rounded,
    color: Colors.blueAccent,
    size: 20,
  );

  void _scrollToTop() {
    if (_focusNode.hasFocus || _focusNode2.hasFocus) {
      setState(() {
        _scrollController.animateTo(1.1,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_scrollToTop);
    _focusNode2.addListener(_scrollToTop);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_scrollToTop);
    _focusNode2.removeListener(_scrollToTop);
    _focusNode.dispose();
    _focusNode2.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
  }

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

      _focusNode2.unfocus();

      print('RESPONSE: $response');

      if (response == 200) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
            // (Route<dynamic> route) => false,
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

  void seePass() {
    obsPassword = !obsPassword;

    obsIcon = obsPassword
        ? const Icon(
            Icons.lock_outline_rounded,
            color: Colors.blueAccent,
            size: 20,
          )
        : const Icon(
            Icons.lock_open_rounded,
            color: Colors.blueAccent,
            size: 20,
          );

    setState(() {
      obsPassword;
      obsIcon;
    });
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
          controller: _scrollController,
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
                             style: TextStyle(color: Theme.of(context).primaryTextTheme.displaySmall?.color),
                            decoration: const InputDecoration(
                                labelText: 'Please enter your username',
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                )),
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
                            obscureText: obsPassword,
                            style: TextStyle(color: Theme.of(context).primaryTextTheme.displaySmall?.color),
                            decoration: InputDecoration(
                                label: const Text('Please enter your password'),
                                labelStyle: const TextStyle(color: Colors.grey),
                                hintText: 'Password',
                                suffix: InkWell(
                                  child: obsIcon,
                                  onTap: () {
                                    seePass();
                                  },
                                ),
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.grey,
                                )),
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
                              if (_formKey.currentState!.validate()) {
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
                              }
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
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme.displaySmall?.color),
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
