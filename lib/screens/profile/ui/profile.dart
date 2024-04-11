import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:socialmedia/screens/Drawer/ui/drawer.dart';
import 'package:socialmedia/screens/Drawer/bloc/drawer_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/post_gallery_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/reels_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/tags_tab.dart';
import 'package:socialmedia/screens/profile/ui/widgets/profile_header.dart';

import '../../../global_Bloc/global_bloc.dart';
import '../../../model/user_model.dart';
import '../../Drawer/bloc/drawer_event.dart';
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
    BlocProvider.of<GlobalBloc>(context).add(GetUserIDEvent(uid: uid));
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  String? profileImageUrl;
  String? name;
  String? joindate;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            onPressed: () async {
              BlocProvider.of<DrawerBloc>(context).add(FirstCheckAccTypeEvent());
              await Future.delayed(const Duration(milliseconds: 200), () {
                _scaffoldKey.currentState?.openEndDrawer();
              });
            },
          )
        ],
        leading: ModalRoute.of(context)?.canPop == true
            ? null
            : null,
        backgroundColor: Colors.black,
        title: BlocBuilder<GlobalBloc, GlobalState>(
          builder: (context, state) {
            if (state is GetUserDataFromGlobalBlocState) {
              List<UserModel> userdata = state.userData;
              BlocProvider.of<ProfileBloc>(context).add(
                  ProfilePageFetchUserPostEvent(userid: state.userData[0].Uid));
              log("userdata in profile:- ${userdata.length.toString()}");
              profileImageUrl = userdata[0].Profileurl;
              name = userdata[0].Name;
              joindate = DateFormat('dd-MMM-yyyy').format(
                  DateTime.parse(userdata[0].datetime.toDate().toString()));

              return Text(
                userdata[0].Username,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            } else {
              return const Text(
                "hi",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            }
          },
        ),
        centerTitle: false,
      ),
      endDrawer: MyDrawer(profileImageUrl, name, joindate),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Colors.grey.withOpacity(0.15),
        backgroundColor: Colors.white.withOpacity(0.65),
        animSpeedFactor: 1.5,
        borderWidth: 1,
        height: 70,
        springAnimationDurationInMilliseconds: 150,
        showChildOpacityTransition: false,
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
            body: DefaultTabController(
              length: 3,
              animationDuration: const Duration(milliseconds: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
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
                              size: 28,
                              Icons.video_library_outlined,
                            ),
                          ),
                          Tab(
                            child: Icon(
                                size: 28, CupertinoIcons.person_crop_square),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 4),
                      child: TabBarView(children: [
                        PostGallery(),
                        ProfileReelSection(),
                        ProfileTagSection(),
                      ]),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
