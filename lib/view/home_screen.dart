import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:while_app/repository/firebase_repository.dart';
import 'package:while_app/theme/pallete.dart';
import 'package:while_app/view/create_screen.dart';
import 'package:while_app/view/feed_screen.dart';
import 'package:while_app/view/user_profile_screen.dart';
import 'package:while_app/view/reels_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:while_app/view/social/social_home_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ignore: non_constant_identifier_names
  int CurrentIndex = 0;
  final List<String> _popupMenuList = [
    "Sign Out",
  ];

  void onTapChange(int index) {
    setState(() {
      CurrentIndex = index;
    });
  }

  void themeToggler(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const FeedScreen(),
    const ReelsScreen(),
    const CreateScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Stack(children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: currentTheme.scaffoldBackgroundColor,
            elevation: 0.0,
            actions: [
              Switch.adaptive(
                value: ref.watch(themeNotifierProvider.notifier).mode ==
                    ThemeMode.dark,
                onChanged: (value) => themeToggler(ref),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SocialScreen(),
                    ));
                  },
                  icon: const Icon(
                    Icons.message,
                    color: Colors.black,
                  )),
              PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    // color: Colors.white,
                  ),
                  itemBuilder: (_) => _popupMenuList.map((menuItem) {
                        return PopupMenuItem(
                          child: Text(menuItem),
                          onTap: () async {
                            FirebaseAuthMethods(FirebaseAuth.instance)
                                .signOut(context);
                          },
                        );
                      }).toList())
            ],
          ),
          extendBody: true,
          backgroundColor: Color.fromARGB(255, 234, 33, 33),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 18, 18, 18),
                borderRadius: BorderRadius.circular(0)),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GNav(
                  onTabChange: onTapChange,
                  activeColor: Colors.black,
                  tabBackgroundColor: currentTheme.primaryColor,
                  padding: const EdgeInsets.all(5),
                  tabs: const [
                    GButton(
                      iconColor: Colors.white,
                      icon: Icons.home,
                      text: 'Home',
                    ),

                    // textColor: currentTheme ==),
                    GButton(
                      iconColor: Colors.white,
                      icon: Icons.movie_creation_outlined,
                      text: 'Reels',
                      iconSize: 25,
                    ),
                    GButton(
                      iconColor: Colors.white,
                      icon: Icons.add,
                      text: 'Create',
                    ),
                    GButton(
                      iconColor: Colors.white,
                      icon: Icons.account_circle,
                      text: 'User Profile',
                    ),
                  ]),
            ),
          ),
          body: Center(
            child: _widgetOptions.elementAt(CurrentIndex),
          ),
        ),
      ]),
    );
  }
}
