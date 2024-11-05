import 'package:flutter/material.dart';
import 'package:services/api/dio_profile.dart';

class ShowNUpdate extends StatefulWidget {
  const ShowNUpdate({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  State<ShowNUpdate> createState() {
    return _ShowNUpdateState();
  }
}

class _ShowNUpdateState extends State<ShowNUpdate> {
  ProfileData? pro;

  @override
  void initState() {
    super.initState();
    pro = widget.profileData;
  }

  @override
  Widget build(BuildContext context) {
    return pro == null
        ? Center(
            child: Text(
              'Sorry, no profile data found.',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryTextTheme.displaySmall!.color,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/logos/home_logo.png',
                                image: pro!.profileImage,
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/logos/home_logo.png',
                                    height: 60,
                                    width: 60,
                                  );
                                },
                                placeholderErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const CircularProgressIndicator();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pro!.fullName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall!
                                  .color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${pro!.userName}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildTextFormField(
                      label: 'Email',
                      value: pro!.email,
                      icon: Icons.email,
                      context: context,
                      isReadOnly: true,
                    ),
                    const SizedBox(height: 30),
                    buildTextFormField(
                      label: 'Phone Number',
                      value: pro!.phoneNumber,
                      icon: Icons.phone,
                      context: context,
                      isReadOnly: true,
                    ),
                    const SizedBox(height: 30),
                    buildTextFormField(
                      label: 'Service',
                      value: pro!.service,
                      icon: Icons.build,
                      context: context,
                      isReadOnly: true,
                    ),
                    const SizedBox(height: 30),
                    buildTextFormField(
                      label: 'Experience (years)',
                      value: pro!.experience,
                      icon: Icons.timeline,
                      context: context,
                      isReadOnly: true,
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildTextFormField({
    required String label,
    required String value,
    required IconData icon,
    required BuildContext context,
    bool isReadOnly = false,
  }) {
    return TextFormField(
      controller: TextEditingController(text: value),
      readOnly: isReadOnly,
      style: TextStyle(
        color: Theme.of(context).primaryTextTheme.displaySmall?.color,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
      ),
    );
  }
}
