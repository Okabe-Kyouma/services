import 'package:flutter/material.dart';

class CurrentUserInfo extends StatefulWidget {
  const CurrentUserInfo(
      {super.key,
      required this.fullName,
      required this.email,
      required this.image});

  final String fullName;
  final String email;
  final String image;

  @override
  State<StatefulWidget> createState() {
    return _CurrentUserInfoState();
  }
}

class _CurrentUserInfoState extends State<CurrentUserInfo> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String imageProvider = widget.image;
    DecorationImage decoImage;

    if (imageProvider == 'assets/logos/services_logo.png' ||
        imageProvider == 'noimageisavailabletodisplayhere') {
      decoImage = const DecorationImage(
        image: AssetImage('assets/logos/services_logo.png'),
      );
    } else {
      decoImage = DecorationImage(
        image: NetworkImage(imageProvider),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(shape: BoxShape.circle, image: decoImage),
          ),
          Text(
            widget.fullName,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            widget.email,
            style: TextStyle(color: Colors.grey[200], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
