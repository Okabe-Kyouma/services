import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:services/api/dio_login.dart';
import 'package:services/auth/forgotPassword/email.dart';
import 'package:services/widgets/dashboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        _scrollController.animateTo(5,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic);
      },);
    }
  }

//  void _scrollToTop() {
//   if (_focusNode.hasFocus || _focusNode2.hasFocus) {
//     // Start scrolling
//     Timer.periodic(const Duration(milliseconds: 16), (timer) {
//       if (_scrollController.offset > 0) {
//         double newOffset = (_scrollController.offset - 20).clamp(0.0, _scrollController.position.maxScrollExtent);
//         _scrollController.jumpTo(newOffset); // Adjust this step size for smoother scroll
//       } else {
//         timer.cancel(); // Stop scrolling when at the top
//       }
//     });
//   }
// }


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
      _focusNode.unfocus();

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
              title: Text(
                  AppLocalizations.of(context)!.loginScreenInvalidCredTitle),
              content: Text(
                  AppLocalizations.of(context)!.loginScreenInvalidCredTitle),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.loginScreenOkay),
                ),
              ],
            ),
          );
        }
      } else if (response == 500) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context)!
                  .loginScreenUsernameAlreadyLoggedInTitle),
              content: Text(AppLocalizations.of(context)!
                  .loginScreenUsernameAlreadyLoggedContent),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.loginScreenOkay),
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
              title: Text(AppLocalizations.of(context)!.loginScreenErrorTitle),
              content:
                  Text(AppLocalizations.of(context)!.loginScreenErrorContent),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.loginScreenOkay),
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
        title: Text(
          AppLocalizations.of(context)!.appBarLoginScreen,
          style: const TextStyle(color: Colors.white),
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
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                    ?.color),
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .loginScreenUsernamelabelText,
                                hintText: AppLocalizations.of(context)!
                                    .loginScreenUsernamehintText,
                                hintStyle: const TextStyle(color: Colors.grey),
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                )),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.length < 5) {
                                return AppLocalizations.of(context)!
                                    .loginScreenUsernameValidation;
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
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall
                                    ?.color),
                            decoration: InputDecoration(
                                label: Text(AppLocalizations.of(context)!
                                    .loginScreenPasswordlabelText),
                                labelStyle: const TextStyle(color: Colors.grey),
                                hintText: AppLocalizations.of(context)!
                                    .loginScreenPasswordhintText,
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
                                return AppLocalizations.of(context)!
                                    .loginScreenPasswordValidation;
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
                              AppLocalizations.of(context)!
                                  .loginScreenLoginButton,
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
                          AppLocalizations.of(context)!
                              .loginScreenDontRememberPass,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall
                                  ?.color),
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
                          child: Text(AppLocalizations.of(context)!
                              .loginScreenClickHere),
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
