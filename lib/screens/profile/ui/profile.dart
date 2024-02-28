import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/Drawer/drawer.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/post_gallery_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/reels_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/tags_tab.dart';
import 'package:socialmedia/screens/profile/ui/widgets/profile_header.dart';
import '../../../model/user_model.dart';
import '../../Drawer/drawer_bloc.dart';
import '../../Drawer/drawer_event.dart';
import '../../navigation_handler/bloc/navigation_bloc.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(ProfilePageInitialEvent());
    super.initState();
  }
  @override
   String? ProfileImageUrl ;
   String? Name ;
   String? joindate;
  Widget build(BuildContext context) {
    print("lllllllllllllllllllllllllllllllllllllllllllllllllll");
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
            onPressed: () {
              BlocProvider.of<DrawerBloc>(context).add(FirstCheckAccTypeEvent());
              Future.delayed(const Duration(milliseconds: 200), () {
                _scaffoldKey.currentState?.openEndDrawer();
              });

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
              BlocProvider.of<ProfileBloc>(context).add(ProfilePageFetchUserPostLengthEvent(userid: state.userData[0].Uid));
              log("userdata in profile:- ${userdata.length.toString()}");
              ProfileImageUrl = userdata[0].Profileurl!;
              Name = userdata[0].Name!;
              joindate = userdata[0].datetime!.toDate().toString();
              joindate = DateFormat('dd-MMM-yyyy').format(DateTime.parse(joindate!));

              return Text(
                userdata[0].Username,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      endDrawer: MyDrawer(ProfileImageUrl,Name,joindate),
      body: DefaultTabController(
        length: 3,
        animationDuration: const Duration(milliseconds: 800),
        child: NestedScrollView(
            headerSliverBuilder: (context,_) {
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
                  height: 16,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2),
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
                                profileimage:state.userData[0].Profileurl.toString(),
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
    );
  }
}
