import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_findUser.dart';
import 'package:services/api/dio_update.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.email});

  final String email;

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
    getUsersUsername();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _passFocus.dispose();
  }

  void getUsersUsername() async {
    try {
      final response = await fetchUsername(widget.email);

      if (response != null) {
        print("Username: $response");
        setState(() {
          username = response;
        });
      } else {
        print("Username not found or other error");
        setState(() {
          username = "User";
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        username = "User";
      });
    }
  }

  void changePassword() async {
    String title = AppLocalizations.of(context)!.forgotPassResetSucessTitle;
    String content = AppLocalizations.of(context)!.forgotPassResetSucessContent;

    try {
      final response =
          await updatePassword(widget.email, _passwordController.text);

      if (mounted) {
        Navigator.of(context).pop();
      }
      if (response == 200) {
      } else if (response == 202) {
        title = AppLocalizations.of(context)!.forgotPassResetFailedTitle;
        content =
            AppLocalizations.of(context)!.forgotPassResetFailedContent;
      } else {
        title = AppLocalizations.of(context)!.loginScreenErrorTitle;
        content =
            AppLocalizations.of(context)!.loginScreenErrorContent;
      }
    } catch (e) {
      title =AppLocalizations.of(context)!.loginScreenErrorTitle;
      content =
         AppLocalizations.of(context)!.loginScreenErrorContent;
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
                        context, (route) => route.settings.name == "/login");
                  }
                },
                child: Text(AppLocalizations.of(context)!.loginScreenOkay),
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
        title: Text(AppLocalizations.of(context)!.forgotEmailVerifyAppBar),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: TextEditingController(text: username),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall
                                  ?.color),
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.forgotPassResetYourUsername,
                              labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .displaySmall
                                      ?.color),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              fillColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[1000]
                                  : Colors.grey[100],
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              )),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
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
                              return AppLocalizations.of(context)!.forgotPassResetMustSatisfy;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              value;
                            });
                          },
                          decoration:  InputDecoration(
                              labelText: AppLocalizations.of(context)!.forgotPassResetEnterNew,
                              labelStyle: const TextStyle(color: Colors.grey),
                              hintText: AppLocalizations.of(context)!.forgotPassResetNewPass,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              prefixIcon: const Icon(
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
                                    title:
                                        Text( AppLocalizations.of(context)!.forgotEmailVerifyCancelPassRecovTitle),
                                    content:  Text(
                                        AppLocalizations.of(context)!.forgotEmailVerifyCalcelPassRecovContent),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.popUntil(
                                              context,
                                              (route) =>
                                                  route.settings.name ==
                                                  "/login");
                                        },
                                        child: Text( AppLocalizations.of(context)!.forgotEmailVerifyYes),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text( AppLocalizations.of(context)!.forgotEmailVerifyNo),
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
                            child:  Text(
                               AppLocalizations.of(context)!.forgotEmailVerifyCancel,
                              style: const TextStyle(
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
                            child:  Text(
                              AppLocalizations.of(context)!.forgotPassResetChangePass,
                              style: const TextStyle(
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
                     AppLocalizations.of(context)!.forgotPassResetCondiA,
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
                     AppLocalizations.of(context)!.forgotPassResetCondiB,
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
                     AppLocalizations.of(context)!.forgotPassResetCondiC,
                    style: TextStyle(
                      color: _passwordController.text.contains(RegExp(r'[a-z]'))
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin:const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                     AppLocalizations.of(context)!.forgotPassResetCondiD,
                    style: TextStyle(
                      color: _passwordController.text.contains(RegExp(r'[0-9]'))
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                     AppLocalizations.of(context)!.forgotPassResetCondiE,
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
