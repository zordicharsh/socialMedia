import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/post_gallery_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/reels_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/tags_tab.dart';
import 'package:socialmedia/screens/profile/ui/widgets/profile_header.dart';

import '../../../model/user_model.dart';
import '../../login/loginui.dart';
import '../../navigation_handler/bloc/navigation_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(ProfilePageInitialEvent());
    super.initState();
  }

  Future<void> _handleRefresh() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    //var uid = cuser?.uid;
    log("uid while refreshing :-------------------------------------------------- $uid");
    BlocProvider.of<GlobalBloc>(context).add(GetUserIDEvent(uid: uid));
    // await Future.delayed(const Duration(milliseconds: 500));
    //  refreshController.refreshCompleted();
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          surfaceTintColor: Colors.black,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add_box_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                BlocProvider.of<NavigationBloc>(context)
                    .add(TabChangedEvent(tabIndex: 2));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                BlocProvider.of<ProfileBloc>(context).add(SignOutEvent());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginUi()));
              },
            )
          ],
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.keyboard_backspace))
              : null,
          backgroundColor: Colors.black,
          title: BlocBuilder<GlobalBloc, GlobalState>(
            builder: (context, state) {
              if (state is GetUserDataFromGlobalBlocState) {
                List<UserModel> userdata = state.userData;
                BlocProvider.of<ProfileBloc>(context).add(
                    ProfilePageFetchUserPostLengthEvent(
                        userid: state.userData[0].Uid));
                log("userdata in profile:- ${userdata.length.toString()}");
                return Text(
                  userdata[0].Username,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              } else {
                return const Text(
                  "hi",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          centerTitle: false,
        ),
        body: LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: Colors.grey.withOpacity(0.15),
          backgroundColor: Colors.white.withOpacity(0.65),
          animSpeedFactor:1.5,
          borderWidth: 0.5,
          height: 76,
          springAnimationDurationInMilliseconds:300,
          showChildOpacityTransition: false,
          child: DefaultTabController(
            length: 3,
            animationDuration: const Duration(milliseconds: 800),
            child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const ProfileHeader(),
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 2),
                      child: TabBar(
                          physics: const BouncingScrollPhysics(),
                          dividerColor: Colors.white.withOpacity(0.1),
                          indicatorColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 1.5,
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.white,
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: MaterialStateProperty.resolveWith(
                            (Set states) {
                              return states.contains(MaterialState.focused)
                                  ? null
                                  : Colors.transparent;
                            },
                          ),
                          tabs: const [
                            Tab(
                              child: Icon(
                                Icons.grid_on_rounded,
                              ),
                            ),
                            Tab(
                              child: Icon(
                                Icons.movie_filter_outlined,
                              ),
                            ),
                            Tab(
                              child: Icon(
                                Icons.perm_contact_cal_outlined,
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 4),
                        child: TabBarView(children: [
                          BlocBuilder<GlobalBloc, GlobalState>(
                              builder: (context, state) {
                            if (state is GetUserDataFromGlobalBlocState) {
                              return PostGallery(
                                profileimage:
                                    state.userData[0].Profileurl.toString(),
                              );
                            } else {
                              return const PostGallery(
                                profileimage: "",
                              );
                            }
                          }),
                          const ProfileReelSection(),
                          const ProfileTagSection(),
                        ]),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}

class CustomLoadingBar extends StatelessWidget {
  const CustomLoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          strokeWidth: 10,
        ),
      ),
    );
  }
}
