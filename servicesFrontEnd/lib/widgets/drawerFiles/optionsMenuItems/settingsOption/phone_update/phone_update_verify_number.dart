import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:services/api/dio_update.dart';
import 'package:services/widgets/providerModels/aadhar_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NumberVerification extends StatelessWidget {
  NumberVerification(
      {super.key, required this.phoneNumber, required this.verificationId});

  final String phoneNumber;
  final String verificationId;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text(
         AppLocalizations.of(context)!.changeNumVerifyAppBar,
          style: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
                  height: 24,
                ),
                Text(
                  AppLocalizations.of(context)!.changeNumVerifyEnterOtp,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formkey,
                  child: TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .displaySmall
                            ?.color),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.changeNumVerifyLabel,
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText:AppLocalizations.of(context)!.changeNumVerifyHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.numbers, color: Colors.grey),
                    ),
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.changeNumVerifyA;
                      } else if (value.length != 6) {
                        return AppLocalizations.of(context)!.changeNumVerifyB;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title:  Text(AppLocalizations.of(context)!.changeNumVerifyCancelTitle),
                              content: Text(
                                  AppLocalizations.of(context)!.changeNumVerifyCancelContent),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.popUntil(
                                        context,
                                        (route) =>
                                            route.settings.name == "/settings");
                                  },
                                  child: Text(AppLocalizations.of(context)!.yes),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:  Text(AppLocalizations.of(context)!.no),
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
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (_formkey.currentState?.validate() ?? false) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: PopScope(
                                    child: CircularProgressIndicator()),
                              );
                            },
                          );

                          try {
                            final cred = PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: _otpController.text);

                            await FirebaseAuth.instance
                                .signInWithCredential(cred);

                            final response =
                                await updatePhoneNumber(phoneNumber);

                            if (response == 200) {
                              if (context.mounted) {
                                Provider.of<AadharModel>(context, listen: false)
                                    .updateAadhar(phoneNumber);
                                Fluttertoast.showToast(
                                    msg:
                                       AppLocalizations.of(context)!.changeNumVerifyToastA,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                    textColor: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 16.0);

                                Navigator.popUntil(
                                    context,
                                    (route) =>
                                        route.settings.name == "/settings");
                              }
                            } else if (response == 202) {
                              Fluttertoast.showToast(
                                  msg:
                                      AppLocalizations.of(context)!.changeNumVerifyToastB,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                  textColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 16.0);
                              Navigator.popUntil(
                                  context,
                                  (route) =>
                                      route.settings.name == "/settings");
                            }
                          } catch (err) {
                            print('Error in flutterfbase: $err');
                            Navigator.pop(context);

                            String tit = AppLocalizations.of(context)!.profileDisplayServerError;
                            String con =
                               AppLocalizations.of(context)!.profileUpdateTryLater;

                            if (err.toString().contains(
                                '[firebase_auth/invalid-verification-code]')) {
                              tit = AppLocalizations.of(context)!.changeNumVerifyWrongOpt;
                              con = AppLocalizations.of(context)!.changeNumVerifyPleaseEnter;
                            }

                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(tit),
                                  content: Text(con),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.okay),)
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
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child:  Text(
                        AppLocalizations.of(context)!.forgotEmailVerifyVerify,
                        style:const  TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
