import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/widgets/image_view.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverPersistentDelegate(user: user),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  color: Colors.black54,
                  child: Column(
                    children: [
                      Text(
                        user.firstName,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "last seen ago",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconWithText(icon: Icons.call, text: 'Call'),
                          iconWithText(icon: Icons.video_call, text: 'Video'),
                          iconWithText(icon: Icons.search, text: 'Search'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const ListTile(
                  contentPadding: EdgeInsets.only(left: 30),
                  title: Text('Hey there! I am using WhatsApp'),
                  subtitle: Text(
                    '17th February',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomListTile(
                  title: 'Mute notification',
                  leading: Icons.notifications,
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const CustomListTile(
                  title: 'Custom notification',
                  leading: Icons.music_note,
                ),
                CustomListTile(
                  title: 'Media visibility',
                  leading: Icons.photo,
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(height: 20),
                const CustomListTile(
                  title: 'Encryption',
                  subTitle:
                      'Messages and calls are end-to-end encrypted, Tap to verify.',
                  leading: Icons.lock,
                ),
                const CustomListTile(
                  title: 'Disappearing messages',
                  subTitle: 'Off',
                  leading: Icons.timer,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: CustomIconButton(
                    onPressed: () {},
                    icon: Icons.group,
                    background: Colors.green,
                    iconColor: Colors.white,
                  ),
                  title: Text('Create group with ${user.firstName}'),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 25, right: 10),
                  leading: const Icon(
                    Icons.block,
                    color: Color(0xFFF15C6D),
                  ),
                  title: Text(
                    'Block ${user.firstName}',
                    style: const TextStyle(
                      color: Color(0xFFF15C6D),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 25, right: 10),
                  leading: const Icon(
                    Icons.thumb_down,
                    color: Color(0xFFF15C6D),
                  ),
                  title: Text(
                    'Report ${user.firstName}',
                    style: const TextStyle(
                      color: Color(0xFFF15C6D),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget iconWithText({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.green,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
  final UserModel user;

  final double maxHeaderHeight = 180;
  final double minHeaderHeight = kToolbarHeight + 20;
  final double maxImageSize = 130;
  final double minImageSize = 40;

  SliverPersistentDelegate({required this.user});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final size = MediaQuery.of(context).size;
    final percent = shrinkOffset / (maxHeaderHeight - minHeaderHeight);
    final percent2 = shrinkOffset / maxHeaderHeight;
    final currentImageSize = (maxImageSize * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition = ((size.width / 2 - 65) * (1 - percent)).clamp(
      minImageSize,
      size.width / 2 - 65,
    );

    return GestureDetector(
      onTap: () {
        Go.to(context, ImageView(imageUrl: user.profileImage));
      },
      child: Container(
        color: Colors.black,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).viewPadding.top + 15,
                left: currentImagePosition + 50,
                child: Text(
                  user.firstName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withOpacity(percent2),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: MediaQuery.of(context).viewPadding.top + 5,
                child: const BackButton(color: Colors.white),
              ),
              Positioned(
                right: 0,
                top: MediaQuery.of(context).viewPadding.top + 5,
                child: CustomIconButton(
                  onPressed: () {},
                  icon: Icons.more_vert,
                  iconColor: percent2 > .3 ? Colors.white : Colors.white,
                ),
              ),
              Positioned(
                left: currentImagePosition,
                top: MediaQuery.of(context).viewPadding.top + 5,
                bottom: 0,
                child: Hero(
                  tag: 'profile',
                  child: Container(
                    width: currentImageSize,
                    height: currentImageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(user.profileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is SliverPersistentDelegate && oldDelegate.user != user;
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    this.subTitle,
    this.trailing,
  });

  final String title;
  final IconData leading;
  final String? subTitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.fromLTRB(25, 5, 10, 5),
      title: Text(title),
      subtitle: subTitle != null
          ? Text(
              subTitle!,
              style: const TextStyle(
                color: Colors.grey,
              ),
            )
          : null,
      leading: Icon(leading),
      trailing: trailing,
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
    this.iconSize,
    this.minWidth,
    this.background,
    this.border,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final double? minWidth;
  final Color? background;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: border,
      ),
      child: IconButton(
        onPressed: onPressed,
        splashColor: Colors.transparent,
        splashRadius: (minWidth ?? 45) - 25,
        iconSize: iconSize ?? 22,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: minWidth ?? 45,
          minHeight: minWidth ?? 45,
        ),
        icon: Icon(
          icon,
          color: iconColor ?? Theme.of(context).appBarTheme.iconTheme?.color,
        ),
      ),
    );
  }
}
















// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// import '../models/user_model.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key, required this.user});

//   final UserModel user;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       body: CustomScrollView(
//         slivers: [
//           SliverPersistentHeader(
//             delegate: SliverPersistentDelegate(user),
//             pinned: true,
//           ),
//           // lets create a long list to make the content scrollable
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 Container(
//                   color: Colors.black54,
//                   child: Column(
//                     children: [
//                       Text(
//                         user.name
//                         ,
//                         style: const TextStyle(fontSize: 24),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         user.email,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         "last seen  ago",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           iconWithText(icon: Icons.call, text: 'Call'),
//                           iconWithText(icon: Icons.video_call, text: 'Video'),
//                           iconWithText(icon: Icons.search, text: 'Search'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const ListTile(
//                   contentPadding: EdgeInsets.only(left: 30),
//                   title: Text('Hey there! I am using WhatsApp'),
//                   subtitle: Text(
//                     '17th February',
//                     style: TextStyle(
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 CustomListTile(
//                   title: 'Mute notification',
//                   leading: Icons.notifications,
//                   trailing: Switch(
//                     value: false,
//                     onChanged: (value) {},
//                   ),
//                 ),
//                 const CustomListTile(
//                   title: 'Custom notification',
//                   leading: Icons.music_note,
//                 ),
//                 CustomListTile(
//                   title: 'Media visibility',
//                   leading: Icons.photo,
//                   trailing: Switch(
//                     value: false,
//                     onChanged: (value) {},
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const CustomListTile(
//                   title: 'Encryption',
//                   subTitle:
//                       'Messages and calls are end-to-end encrypted, Tap to verify.',
//                   leading: Icons.lock,
//                 ),
//                 const CustomListTile(
//                   title: 'Disappearing messages',
//                   subTitle: 'Off',
//                   leading: Icons.timer,
//                 ),
//                 const SizedBox(height: 20),
//                 ListTile(
//                   leading: CustomIconButton(
//                     onPressed: () {},
//                     icon: Icons.group,
//                     background: Colors.green,
//                     iconColor: Colors.white,
//                   ),
//                   title: Text('Create group with ${user.name}'),
//                 ),
//                 const SizedBox(height: 20),
//                 ListTile(
//                   contentPadding: const EdgeInsets.only(left: 25, right: 10),
//                   leading: const Icon(
//                     Icons.block,
//                     color: Color(0xFFF15C6D),
//                   ),
//                   title: Text(
//                     'Block ${user.name}',
//                     style: const TextStyle(
//                       color: Color(0xFFF15C6D),
//                     ),
//                   ),
//                 ),
//                 ListTile(
//                   contentPadding: const EdgeInsets.only(left: 25, right: 10),
//                   leading: const Icon(
//                     Icons.thumb_down,
//                     color: Color(0xFFF15C6D),
//                   ),
//                   title: Text(
//                     'Report ${user.name}',
//                     style: const TextStyle(
//                       color: Color(0xFFF15C6D),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   iconWithText({required IconData icon, required String text}) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 30,
//             color: Colors.green,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             text,
//             style: const TextStyle(color: Colors.green),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
//   final UserModel user;

//   final double maxHeaderHeight = 180;
//   final double minHeaderHeight = kToolbarHeight + 20;
//   final double maxImageSize = 130;
//   final double minImageSize = 40;

//   SliverPersistentDelegate(this.user);

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     final size = MediaQuery.of(context).size;
//     final percent = shrinkOffset / (maxHeaderHeight - 35);
//     final percent2 = shrinkOffset / (maxHeaderHeight);
//     final currentImageSize = (maxImageSize * (1 - percent)).clamp(
//       minImageSize,
//       maxImageSize,
//     );
//     final currentImagePosition = ((size.width / 2 - 65) * (1 - percent)).clamp(
//       minImageSize,
//       maxImageSize,
//     );
//     return Container(
//       color: Theme.of(context).colorScheme.surface,
//       child: Container(
//         color: Theme.of(context)
//             .appBarTheme
//             .backgroundColor!
//             .withOpacity(percent2 * 2 < 1 ? percent2 * 2 : 1),
//         child: Stack(
//           children: [
//             Positioned(
//               top: MediaQuery.of(context).viewPadding.top + 15,
//               left: currentImagePosition + 50,
//               child: Text(
//                 user.name,
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white.withOpacity(percent2),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               top: MediaQuery.of(context).viewPadding.top + 5,
//               child: BackButton(
//                 color:
//                     percent2 > .3 ? Colors.white.withOpacity(percent2) : null,
//               ),
//             ),
//             Positioned(
//               right: 0,
//               top: MediaQuery.of(context).viewPadding.top + 5,
//               child: CustomIconButton(
//                 onPressed: () {},
//                 icon: Icons.more_vert,
//                 iconColor: percent2 > .3
//                     ? Colors.white.withOpacity(percent2)
//                     : Theme.of(context).textTheme.bodyMedium!.color,
//               ),
//             ),
//             Positioned(
//               left: currentImagePosition,
//               top: MediaQuery.of(context).viewPadding.top + 5,
//               bottom: 0,
//               child: Hero(
//                 tag: 'profile',
//                 child: Container(
//                   width: currentImageSize,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: CachedNetworkImageProvider(user.profileImage??""),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => maxHeaderHeight;

//   @override
//   double get minExtent => minHeaderHeight;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }



// class CustomListTile extends StatelessWidget {
//   const CustomListTile({
//     super.key,
//     required this.title,
//     required this.leading,
//     this.subTitle,
//     this.trailing,
//   });

//   final String title;
//   final IconData leading;
//   final String? subTitle;
//   final Widget? trailing;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {},
//       contentPadding: const EdgeInsets.fromLTRB(25, 5, 10, 5),
//       title: Text(title),
//       subtitle: subTitle != null
//           ? Text(
//               subTitle!,
//               style: const TextStyle(
//                 color: Colors.grey,
//               ),
//             )
//           : null,
//       leading: Icon(leading),
//       trailing: trailing,
//     );
//   }
// }


// class CustomIconButton extends StatelessWidget {
//   const CustomIconButton({
//     super.key,
//     required this.onPressed,
//     required this.icon,
//     this.iconColor,
//     this.iconSize,
//     this.minWidth,
//     this.background,
//     this.border,
//   });

//   final VoidCallback onPressed;
//   final IconData icon;
//   final Color? iconColor;
//   final double? iconSize;
//   final double? minWidth;
//   final Color? background;
//   final BoxBorder? border;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: background,
//         shape: BoxShape.circle,
//         border: border,
//       ),
//       child: IconButton(
//         onPressed: onPressed,
//         splashColor: Colors.transparent,
//         splashRadius: (minWidth ?? 45) - 25,
//         iconSize: iconSize ?? 22,
//         padding: EdgeInsets.zero,
//         constraints: BoxConstraints(
//           minWidth: minWidth ?? 45,
//           minHeight: minWidth ?? 45,
//         ),
//         icon: Icon(
//           icon,
//           color: iconColor ?? Theme.of(context).appBarTheme.iconTheme?.color,
//         ),
//       ),
//     );
//   }
// }