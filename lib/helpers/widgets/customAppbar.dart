import 'package:flutter/material.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:provider/provider.dart';
import '../../providers/bottomBarProvider.dart';
import '../colorRes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final Function(bool)? onDarkModeChanged;
  final bool? needActions;
  final bool? implyBackButton;
  final String? title;
  final bool? centerTitle;

  const CustomAppBar({
    Key? key,
    required this.isDarkMode,
    this.onDarkModeChanged,
    this.needActions,
    this.implyBackButton,
    this.title,
    this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);

    return AppBar(
      backgroundColor: ColorsRes.canvasColor,
      title: title != null
          ? Text(title.toString())
          : implyBackButton == true
              ? Row(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      scale: 8,
                    ),
                    const SizedBox(width: 10),
                    const Text("IS3"),
                  ],
                )
              : Text("IS3"),
      leading: implyBackButton == true
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new),
            )
          : Image.asset(
              "assets/logo.png",
              scale: 8,
            ),
      centerTitle: centerTitle == true ? true : false,
      actions: needActions == false
          ? []
          : [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              PopupMenuButton<String>(
                icon: Image.asset(
                  "assets/more.png",
                  scale: 2,
                ),
                onSelected: (value) {
                  // Handle menu item selection here
                  switch (value) {
                    case 'profile':
                      // Navigate to profile screen or handle profile action
                      bottomBarProvider.setIndex(3);
                      Navigator.pushReplacementNamed(context, bottomBarScreen);
                      break;
                    case 'feedback':
                      // Navigate to feedback screen or handle feedback action
                      break;
                    case 'contact_us':
                      // Handle contact us action
                      Navigator.pushNamed(context, contactUs);
                      break;
                    case 'settings':
                      Navigator.pushNamed(context, addressPickerScreen);

                      break;
                    case 'log_out':
                      // Handle log out action
                      break;
                    case 'dark_light':
                      onDarkModeChanged?.call(!isDarkMode); // Toggle dark mode
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'feedback',
                    child: ListTile(
                      leading: Icon(Icons.feedback),
                      title: Text('Feedback'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'contact_us',
                    child: ListTile(
                      leading: Icon(Icons.contact_phone),
                      title: Text('Contact us'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'log_out',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Log out'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'dark_light',
                    child: ListTile(
                      leading: Icon(Icons.lightbulb),
                      title: Text('Dark / Light'),
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          onDarkModeChanged?.call(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
