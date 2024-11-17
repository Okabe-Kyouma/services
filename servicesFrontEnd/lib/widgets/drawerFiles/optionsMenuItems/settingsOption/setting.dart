import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_delete_account.dart';
import 'package:services/main.dart';
import 'package:services/widgets/drawerFiles/optionsMenuItems/settingsOption/email_update/email_update_enter_email.dart';
import 'package:services/widgets/drawerFiles/optionsMenuItems/settingsOption/password_update/password_update.dart';
import 'package:services/widgets/drawerFiles/optionsMenuItems/settingsOption/phone_update/phone_update_enter_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void _changeLang() async {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Select Language',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     myAppKey.currentState?.toggleLang('en');
                  //     Navigator.pop(context);
                  //   },
                  //   child: Text(
                  //     'English',
                  //     style: TextStyle(
                  //         color: Theme.of(context).brightness == Brightness.dark
                  //             ? Colors.white
                  //             : Colors.black),
                  //   ),
                  // ),
                  Container(
                    decoration: BoxDecoration(color: Colors.black),
                    margin: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                    child: TextButton.icon(
                      onPressed: () {
                        myAppKey.currentState?.toggleLang('en');
                        Navigator.pop(context);
                      },
                      label: const Text(
                        'English',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/logos/uk.png',
                          fit: BoxFit.cover,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.black),
                    margin: const EdgeInsets.fromLTRB(0, 20, 40, 0),
                    child: TextButton.icon(
                      onPressed: () {
                        myAppKey.currentState?.toggleLang('hi');
                        Navigator.pop(context);
                      },
                      label: const Text(
                        'हिन्दी',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/logos/hi.png',
                          fit: BoxFit.cover,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      },
    );
  }

  void _changePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewPassword(),
      ),
    );
  }

  void _changeEmail() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Email(),
        ));
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
            title: Text(AppLocalizations.of(context)!.settingSomeError),
            content: Text(AppLocalizations.of(context)!.settingPleaseTry),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.okay),
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
            title: Text(AppLocalizations.of(context)!.settingServerErrorTitle),
            content:
                Text(AppLocalizations.of(context)!.settingServerErrorContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.okay),
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
          title: Text(AppLocalizations.of(context)!.settingDeleteAccountTitle),
          content:
              Text(AppLocalizations.of(context)!.settingDeleteAccountContent),
          actions: [
            TextButton(
              onPressed: () {
                _confirmDeleteAccount();
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.no),
            )
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
        title: Text(AppLocalizations.of(context)!.settingAppBar,
            style: const TextStyle(color: Colors.white)),
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
                  AppLocalizations.of(context)!.settingAppear,
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
                            AppLocalizations.of(context)!.settingLightMode,
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
                            AppLocalizations.of(context)!.settingDarkMode,
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
                  AppLocalizations.of(context)!.settingGeneral,
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
                          title: Text(AppLocalizations.of(context)!
                              .settingChangeLangTitle),
                          content: Text(AppLocalizations.of(context)!
                              .settingChangeLangContent),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _changeLang();
                              },
                              child: Text(AppLocalizations.of(context)!.yes),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.no))
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
                          Icons.language,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.settingChangeLang,
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
                const SizedBox(
                  height: 30,
                ),
                Text(
                  AppLocalizations.of(context)!.settingChangeSensitive,
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
                          title: Text(AppLocalizations.of(context)!
                              .settingChangeNumberTitle),
                          content: Text(AppLocalizations.of(context)!
                              .settingChangeNumberContent),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _changeNumber();
                              },
                              child: Text(AppLocalizations.of(context)!.yes),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.no))
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
                          AppLocalizations.of(context)!.settingChangeNumber,
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
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .settingChangeEmailTitle),
                          content: Text(AppLocalizations.of(context)!
                              .settingChangeEmailContent),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _changeEmail();
                              },
                              child: Text(AppLocalizations.of(context)!.yes),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.no),
                            )
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
                          Icons.email,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.settingChangeEmail,
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
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .settingChangePassTitle),
                          content: Text(AppLocalizations.of(context)!
                              .settingChangePassContent),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _changePassword();
                              },
                              child: Text(AppLocalizations.of(context)!.yes),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.no),
                            )
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
                          Icons.password,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.settingChangePass,
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
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.settingAccount,
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          // color: Theme.of(context).colorScheme.primary
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.settingDeleteAccount,
                          style: const TextStyle(
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
