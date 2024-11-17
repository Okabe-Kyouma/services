import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/auth/login/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:services/first_screen.dart';

class WorkProfileCreated extends StatelessWidget {
  const WorkProfileCreated({super.key, required this.isWorkProfile});

  final bool isWorkProfile;

  @override
  Widget build(BuildContext context) {
    if (isWorkProfile) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title:  Text(AppLocalizations.of(context)!.workProfileAppBar),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          automaticallyImplyLeading: false,
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            await showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text(AppLocalizations.of(context)!.workProfileExit),
                actions: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child:  Text(AppLocalizations.of(context)!.yes),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child:  Text(AppLocalizations.of(context)!.no),
                  ),
                ],
              ),
            );
          },
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset('assets/logos/tick.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
               AppLocalizations.of(context)!.workProfileWeHave,
                style: TextStyle(
                    fontSize: 28,
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.workProfileInThe,
                style: TextStyle(
                    fontSize: 20,
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () {

                  // Navigator.popUntil(context,
                  //     (route) => route.settings.name == "/firstScreen");

                   Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const FirstScreen(),),
                              (Route<dynamic> route) => false,
                            );

                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                child: Text(
                   AppLocalizations.of(context)!.workProfileLogin,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
        ),
      );
    } else {
      return const Login();
    }
  }
}
