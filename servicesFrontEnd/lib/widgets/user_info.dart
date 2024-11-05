// import 'package:flutter/material.dart';

// class UserInfo extends StatelessWidget {
//   const UserInfo({
//     super.key,
//     required this.username,
//     required this.profilePhotoLink,
//     required this.phoneNumber,
//     required this.fullname,
//     required this.service,
//     required this.exp,
//   });

//   final String username;
//   final String profilePhotoLink;
//   final String phoneNumber;
//   final String fullname;
//   final String service;
//   final String exp;

//   @override
//   Widget build(BuildContext context) {
//     print('The image that imgonna display: ${profilePhotoLink.substring(8)}');
//     String phn = phoneNumber.substring(0, 4);
//     return SizedBox(
//       height: 260,
//       child: Card(
//         elevation: 5,
//         margin: const EdgeInsets.all(12.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   ClipOval(
//                     child: SizedBox(
//                       height: 80,
//                       width: 80,
//                       child: Image.network(
//                         profilePhotoLink,
//                         key: UniqueKey(),
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: CircularProgressIndicator(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onPrimaryContainer,
//                               ),
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, error, stackTrace) {
//                           return Image.asset(
//                             'assets/logos/services_logo.png',
//                             width: 80,
//                             height: 80,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         fullname,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "Cell +91${phn}XXXXXX",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       // Text(
//                       //   username,
//                       //   style: const TextStyle(
//                       //     fontSize: 16,
//                       //     color: Colors.grey,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ],
//               ),
//               const Divider(
//                 height: 20,
//                 thickness: 1,
//               ),
//               const SizedBox(height: 8),
//               // Text(
//               //   'Service: $service',
//               //   style: const TextStyle(
//               //     fontSize: 16,
//               //   ),
//               // ),
//               const SizedBox(height: 4),
//               Text(
//                 'Experience: $exp',
//                 style: const TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               ListTile(
//                 title: Text('Message This person'),
//                 leading: Icon(Icons.message),
//               )
//               // Text(
//               //   'Address: $address',
//               //   style: const TextStyle(
//               //     fontSize: 16,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

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
                'Experience: $exp',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        Theme.of(context).primaryTextTheme.displaySmall?.color),
              ),
              const SizedBox(height: 4),
              ListTile(
                title: const Text('Message This Person'),
                leading: const Icon(Icons.message),
                onTap: () {
                  // Handle message tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
