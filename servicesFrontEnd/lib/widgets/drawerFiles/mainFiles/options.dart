import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_logout.dart';
import 'package:services/first_screen.dart';
import 'package:services/widgets/drawerFiles/optionsMenuItems/profile_update/profile.dart';
import 'package:services/widgets/drawerFiles/optionsMenuItems/settingsOption/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[150]),
      // child: TextButton(
      //   onPressed: () async {
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return const Center(
      //           child: PopScope(
      //             canPop: false,
      //             child: CircularProgressIndicator(),
      //           ),
      //         );
      //       },
      //     );

      //     await logout();

      //     if (context.mounted) {
      //       Navigator.pop(context);

      //       Navigator.popUntil(
      //           context, (route) => route.settings.name == "/firstScreen");
      //     }
      //   },
      //   child: const Text(
      //     'Logout',
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.optionsProfile),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                  settings: const RouteSettings(name: '/update'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title:  Text(AppLocalizations.of(context)!.optionsChat),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.optionsSettings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Setting(),
                    settings: const RouteSettings(name: '/settings')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title:  Text(
             AppLocalizations.of(context)!.optionsLogout,
            ),
            onTap: () async {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title:  Text(AppLocalizations.of(context)!.optionsLogoutConfirmTitle),
                    content: Text(AppLocalizations.of(context)!.optionsLogoutConfirmContent),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.no),
                      ),
                      TextButton(
                        onPressed: () async {
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

                          await logout();

                          if (context.mounted) {
                            Navigator.pop(context);

                            //Navigator.popUntil(
                            //   context, (route) => route.settings.name == "/firstScreen");

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const FirstScreen(flag: false,),),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.yes),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title:  Text(
             AppLocalizations.of(context)!.optionsClose,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
