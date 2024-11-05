import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_logout.dart';
import 'package:services/first_screen.dart';
import 'package:services/widgets/drawerFiles/profile_update/profile.dart';
import 'package:services/widgets/drawerFiles/settings/setting.dart';

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
            title: const Text('Profile'),
            onTap: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => const Profile(),));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Setting(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
            ),
            onTap: () async {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('Logout?'),
                    content: const Text('Do you want to Logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
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
                                  builder: (context) => const FirstScreen()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text(
              'Close',
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
