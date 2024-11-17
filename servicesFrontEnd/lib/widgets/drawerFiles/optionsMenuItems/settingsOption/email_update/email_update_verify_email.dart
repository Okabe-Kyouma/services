import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:services/api/dio_update.dart';
import 'package:services/widgets/providerModels/email_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmail extends StatelessWidget {
  VerifyEmail({super.key, required this.email});

  final String email;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _otpController = TextEditingController();
    final FocusNode _focusNode = FocusNode();

    void updateTheNumber() async {
      try {
        final response = await updateEmailId(email);

        if (response == 200) {
          if (context.mounted) {
            Provider.of<EmailModel>(context, listen: false).updateEmail(email);
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.changeEmailVerifyToastA,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                fontSize: 16.0);

            Navigator.popUntil(
                context, (route) => route.settings.name == "/settings");
          }
        } else if (response == 202) {
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.changeEmailVerifyToastB,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              fontSize: 16.0);
          Navigator.popUntil(
              context, (route) => route.settings.name == "/settings");
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.changeEmailVerifyToastB,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            textColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            fontSize: 16.0);
        Navigator.popUntil(
            context, (route) => route.settings.name == "/settings");
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text(
         AppLocalizations.of(context)!.changeEmailVerifyAppBar,
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
                  height: 30,
                ),
                Text(
                  AppLocalizations.of(context)!.changeEmailVerifyWeHave,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _otpController,
                          focusNode: _focusNode,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall
                                  ?.color),
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) {
                            if (value == null ||
                                value.length < 12 ||
                                !RegExp(r'^\d{12}$').hasMatch(value)) {
                              return AppLocalizations.of(context)!.changeEmailVerifyValid;
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            labelText: AppLocalizations.of(context)!.changeEmailVerifyLabel,
                            labelStyle: const  TextStyle(color: Colors.grey),
                            hintText: AppLocalizations.of(context)!.changeEmailVerifyContent,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.numbers,
                              color: Colors.grey,
                            ),
                          ),
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                        ),
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
                                    title: Text(AppLocalizations.of(context)!.changeEmailVerifyCancelTitle),
                                    content: Text(
                                        AppLocalizations.of(context)!.changeEmailVerifyCancelContent),
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
                                        child: Text(AppLocalizations.of(context)!.yes),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.no),
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
                              AppLocalizations.of(context)!.cancel,
                              style:const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          OutlinedButton(
                            onPressed: () {
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

                              _focusNode.unfocus();
                              if (EmailOTP.verifyOTP(
                                  otp: _otpController.text)) {
                                updateTheNumber();
                              } else {
                                Navigator.pop(context);
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(AppLocalizations.of(context)!.changeNumVerifyWrongOpt),
                                      content:  Text(
                                          AppLocalizations.of(context)!.changeNumVerifyPleaseEnter),
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
                              AppLocalizations.of(context)!.forgotEmailVerifyVerify,
                              style:const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
