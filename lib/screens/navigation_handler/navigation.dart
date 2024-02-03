import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/navigation_handler/bloc/navigation_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile.dart';


List<BottomNavigationBarItem> bottomNavItems =  <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: const Icon(Icons.home,),
      activeIcon: const Icon(Icons.home_outlined),
      backgroundColor:Colors.black.withOpacity(0.25),
      label: 'Home',tooltip: 'Here You Can View Posts Of Friends You Follow'),
  BottomNavigationBarItem(icon: const Icon(Icons.search,),
      activeIcon: const Icon(Icons.search),
      backgroundColor:Colors.black.withOpacity(0.25),
      label: 'Search',tooltip: 'Search a Friend or Family Member'),
  BottomNavigationBarItem(icon: const Icon(Icons.add_box_rounded,size: 32,),
      activeIcon: const Icon(Icons.add_box_outlined,size: 32,),
      backgroundColor:Colors.black.withOpacity(0.25),
      label: 'New Post',tooltip: 'Here You Can Upload New Post On Your Profile'),
  BottomNavigationBarItem(icon: const Icon(Icons.movie_filter,),
      activeIcon: const Icon(Icons.movie_filter_outlined),
      backgroundColor:Colors.black.withOpacity(0.25),
      label: 'Reels',tooltip: 'Here You Can Watch Reels'),
  BottomNavigationBarItem(icon: const Icon(Icons.person,),
      activeIcon: const Icon(Icons.portrait_rounded),
      backgroundColor:Colors.black.withOpacity(0.25),
      label: 'Profile',tooltip: 'Your Social Profile'),
];

const List<Widget> bottomNavScreen = <Widget>[
  Text('Index 0: Home'),
  Text('Index 1: Search'),
  Text('Index 2: Reels'),
  Text('Index 3: Notifications'),
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
          return Scaffold(
            body: Center(child: bottomNavScreen.elementAt(state.tabindex),),
            bottomNavigationBar: BottomNavigationBar(
              enableFeedback:true ,
              items: bottomNavItems,
              currentIndex: state.tabindex,


              selectedFontSize: 12,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.withOpacity(0.5),
              onTap: (index) {
              BlocProvider.of<NavigationBloc>(context).add(
                  TabChangedEvent(tabIndex: index));
            },),
          );
        },
    );
  }
}
