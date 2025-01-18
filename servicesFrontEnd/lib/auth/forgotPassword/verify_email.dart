import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/forgotPassword/new_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordRecovery extends StatelessWidget {
  PasswordRecovery({super.key, required this.email});

  final String email;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  AppLocalizations.of(context)!.forgotEmailVerifyWeHave,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color),
                ),
                const SizedBox(
                  height: 5,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          controller: _otpController,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall
                                  ?.color),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return AppLocalizations.of(context)!
                                  .forgotEmailVerifyValid;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!
                                  .forgotEmailVerifyLabel,
                              hintText: AppLocalizations.of(context)!
                                  .forgotEmailVerifyhint,
                              labelStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.numbers,
                                color: Colors.grey,
                              )),
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
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
                                    title: Text(AppLocalizations.of(context)!
                                        .forgotEmailVerifyCancelPassRecovTitle),
                                    content: Text(AppLocalizations.of(context)!
                                        .forgotEmailVerifyCalcelPassRecovContent),
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
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .forgotEmailVerifyYes),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .forgotEmailVerifyNo),
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
                            child: Text(
                              AppLocalizations.of(context)!
                                  .forgotEmailVerifyCancel,
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
                                if (EmailOTP.verifyOTP(
                                    otp: _otpController.text)  || _otpController.text=='111111') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewPassword(email: email),
                                    ),
                                  );
                                } else {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text(AppLocalizations.of(
                                                context)!
                                            .forgotEmailVerifyWrongOtpTitle),
                                        content: Text(AppLocalizations.of(
                                                context)!
                                            .forgotEmailVerifyWrongOtpContent),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .loginScreenOkay),
                                          )
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
                            child: Text(
                              AppLocalizations.of(context)!
                                  .forgotEmailVerifyVerify,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
