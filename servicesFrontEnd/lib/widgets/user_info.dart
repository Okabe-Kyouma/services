import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:services/widgets/chat/chat_main.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.username,
    required this.profilePhotoLink,
    required this.phoneNumber,
    required this.fullname,
    required this.service,
    required this.exp,
  });

  final String username;
  final String profilePhotoLink;
  final String phoneNumber;
  final String fullname;
  final String service;
  final String exp;

  @override
  Widget build(BuildContext context) {
    String phn = phoneNumber.substring(0, 4);

    return SizedBox(
      height: 240,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FadeInImage.assetNetwork(
                        key: UniqueKey(),
                        placeholder: 'assets/logos/home_logo.png',
                        image: profilePhotoLink,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/logos/home_logo.png',
                            // fit: BoxFit.contain,
                            height: 60,
                            width: 60,
                          );
                        },
                        placeholderErrorBuilder: (context, error, stackTrace) {
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullname.toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .displaySmall
                                ?.color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Cell +91${phn}XXXXXX",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.userInfoExp} $exp',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
              ),
              const SizedBox(height: 4),
              ListTile(
                title: Text(AppLocalizations.of(context)!.userInfoMssgThis),
                leading: const Icon(Icons.message),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatMain(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
