import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/explorescreen/ui/explorescreen.dart';
import 'package:socialmedia/screens/navigation_handler/bloc/navigation_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile.dart';
import 'package:socialmedia/screens/search_user/searchui/searchui.dart';
import 'package:socialmedia/screens/user_post/ui/userpost.dart';
import 'package:socialmedia/screens/videoscreen/ui/videopage.dart';


List<BottomNavigationBarItem> bottomNavItems =  <BottomNavigationBarItem>[
  const BottomNavigationBarItem(icon: Icon(Icons.home_outlined,size: 30),
      activeIcon: Icon(Icons.home_filled,size:32,),
      backgroundColor:Colors.black,
      label: '',tooltip: 'Here You Can View Posts Of Friends You Follow'),
  const BottomNavigationBarItem(icon: Icon(Icons.search,size: 30,),
      activeIcon: Icon(Icons.search,size:32,),
      backgroundColor:Colors.black,
      label: '',tooltip: 'Search a Friend or Family Member'),
  const BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined,size: 30,),
      activeIcon: Icon(Icons.add_box_rounded,size: 32,),
      backgroundColor:Colors.black,
      label: '',tooltip: 'Here You Can Upload New Post On Your Profile'),
  const BottomNavigationBarItem(icon: Icon(Icons.video_library_outlined,size: 30,),
      activeIcon: Icon(Icons.video_library,size: 32,),
      backgroundColor:Colors.black,
      label: '',tooltip: 'Here You Can Watch Reels'),
   const BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_alt_circle,size: 30,),
      activeIcon: Icon(CupertinoIcons.person_alt_circle_fill,size: 32,),
      label: '',tooltip: 'Your SocialRizz Profile'),
];

const List<Widget> bottomNavScreen = <Widget>[
  Text('Index 0: Home'),
  AllUserPosts(),
  ImageUploadScreen(),
  VideoPage(),
  ProfilePage(),

];

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    BlocProvider.of<NavigationBloc>(context).add(NavigationInitialEvent(tabIndex: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Center(child: bottomNavScreen.elementAt(state.tabindex),),
            bottomNavigationBar: Theme(
              data: ThemeData(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: Stack(
                children: [
                  BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                    backgroundColor:Colors.black,
                    items: bottomNavItems,
                    currentIndex: state.tabindex,
                    selectedFontSize: 0,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey.withOpacity(0.5),
                    onTap: (index) {
                      BlocProvider.of<NavigationBloc>(context).add(
                          TabChangedEvent(tabIndex: index));
                    },),
                   const Divider(height: 1,color: Colors.white10,thickness:1 ,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}