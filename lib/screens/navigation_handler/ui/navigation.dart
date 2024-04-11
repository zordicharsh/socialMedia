import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/navigation_handler/bloc/navigation_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile.dart';
import 'package:socialmedia/screens/user_post/ui/userpost.dart';
import '../../explore_screen/ui/explorescreen.dart';
import '../../home_screen/ui/homescreen.dart';
import '../../videos_screen/ui/videopage.dart';

List<BottomNavigationBarItem> bottomNavItems = <BottomNavigationBarItem>[
  const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined, size: 30),
      activeIcon: Icon(
        Icons.home_filled,
        size: 32,
      ),
      backgroundColor: Colors.black,
      label: '',
      tooltip: 'Here You Can View Posts Of Friends You Follow'),
  const BottomNavigationBarItem(
      icon: Icon(
        Icons.search,
        size: 30,
      ),
      activeIcon: Icon(
        Icons.search,
        size: 32,
      ),
      backgroundColor: Colors.black,
      label: '',
      tooltip: 'Search a Friend or Family Member'),
  const BottomNavigationBarItem(
      icon: Icon(
        Icons.add_box_outlined,
        size: 30,
      ),
      activeIcon: Icon(
        Icons.add_box_rounded,
        size: 32,
      ),
      backgroundColor: Colors.black,
      label: '',
      tooltip: 'Here You Can Upload New Post On Your Profile'),
  const BottomNavigationBarItem(
      icon: Icon(
        Icons.video_library_outlined,
        size: 30,
      ),
      activeIcon: Icon(
        Icons.video_library,
        size: 32,
      ),
      backgroundColor: Colors.black,
      label: '',
      tooltip: 'Here You Can Watch Videos'),
  const BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.person_alt_circle,
        size: 30,
      ),
      activeIcon: Icon(
        CupertinoIcons.person_alt_circle_fill,
        size: 32,
      ),
      label: '',
      tooltip: 'Your SocialRizz Profile'),
];



class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    BlocProvider.of<NavigationBloc>(context)
        .add(NavigationInitialEvent(tabIndex: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomNavScreen = <Widget>[
      const HomeScreen(),
      PopScope(canPop: false,onPopInvoked:(didPop) =>  BlocProvider.of<NavigationBloc>(context)
          .add(TabChangedEvent(tabIndex: 0)) ,child: const AllUserPosts()),
       PopScope(canPop: false,onPopInvoked:(didPop) =>  BlocProvider.of<NavigationBloc>(context)
           .add(TabChangedEvent(tabIndex: 0)) ,child: const ImageUploadScreen()),
       PopScope(canPop: false,onPopInvoked:(didPop) =>  BlocProvider.of<NavigationBloc>(context)
           .add(TabChangedEvent(tabIndex: 0)) ,child: const VideoPage()),
      PopScope(canPop: false,onPopInvoked:(didPop) =>  BlocProvider.of<NavigationBloc>(context)
          .add(TabChangedEvent(tabIndex: 0)) ,child:  const ProfilePage(),)

    ];
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: bottomNavScreen.elementAt(state.tabindex),
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: Stack(
                children: [
                  BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    landscapeLayout:
                        BottomNavigationBarLandscapeLayout.centered,
                    backgroundColor: Colors.black,
                    items: bottomNavItems,
                    currentIndex: state.tabindex,
                    selectedFontSize: 0,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey.withOpacity(0.5),
                    onTap: (index) {
                      BlocProvider.of<NavigationBloc>(context)
                          .add(TabChangedEvent(tabIndex: index));
                     /* if(index == 0){
                        BlocProvider.of<GlobalBloc>(context)
                            .add(GetUserIDEvent(uid:FirebaseAuth.instance.currentUser?.uid));
                      }*/
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.white10,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
