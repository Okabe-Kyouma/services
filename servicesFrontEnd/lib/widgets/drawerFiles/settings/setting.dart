import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_delete_account.dart';
import 'package:services/main.dart';
import 'package:services/widgets/drawerFiles/profile_update/phone_update/phone_update_enter_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  void _changeNumber() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Number(),
      ),
    );
  }

  void _confirmDeleteAccount() async {
    Navigator.pop(context);

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

    final response = await deleteAccount();

    Navigator.pop(context);

    if (response == 200) {
      Navigator.popUntil(
          context, (route) => route.settings.name == "/firstScreen");
    } else if (response == 404) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Some Error Occurred'),
            content: const Text('Please try again Later!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Server Error'),
            content: const Text('Please try again Later!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteAccount() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Do you want to Delete Your Account?'),
          actions: [
            TextButton(
              onPressed: () {
                _confirmDeleteAccount();
              },
              child: const Text('Yes'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'))
          ],
        );
      },
    );
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      // backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.light_mode,
                            color: isDarkMode
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Light Mode",
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.grey : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: isDarkMode,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });

                          myAppKey.currentState?.toggleTheme(isDarkMode);
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            "Dark Mode",
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.dark_mode,
                            color: isDarkMode
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Change Sensitive Info',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('Change Number'),
                          content:
                              const Text('Do you want to Change Your Number?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _changeNumber();
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'))
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Change Number',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall
                                  ?.color,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Change Email',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .displaySmall
                                ?.color,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.password,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Change Password',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .displaySmall
                                ?.color,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Account',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: _deleteAccount,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete,
                          // color: Theme.of(context).colorScheme.primary
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Delete Account',
                          style: TextStyle(
                              // color: Theme.of(context)
                              //     .primaryTextTheme
                              //     .displaySmall
                              //     ?.color,
                              color: Colors.red,
                              fontSize: 18),
                        ),
                      ],
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
