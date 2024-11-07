import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/main.dart';
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
      body: Center(
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
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
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
              // const SizedBox(height: 20),
              // Text(
              //   'Change Number',
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //       color:
              //           Theme.of(context).primaryTextTheme.displaySmall?.color),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
