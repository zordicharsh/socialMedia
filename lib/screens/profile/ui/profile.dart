import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/post_gallery_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/reels_tab.dart';
import 'package:socialmedia/screens/profile/ui/profile_page_tabs/tags_tab.dart';
import 'package:socialmedia/screens/profile/ui/widgets/profile_header.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_bloc.dart';
import 'package:socialmedia/screens/user_post/ui/userpost.dart';
class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key,required this.uid});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final photosList = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpYTOlv2wcTRyNd1Ebq0C24UoX8ysKqCK94E0oxAaC2h53Jz4_4kQfV0IxUrRYx6QtN5o&usqp=CAU",
    "https://media.istockphoto.com/id/1281804798/photo/very-closeup-view-of-amazing-domestic-pet-in-mirror-round-fashion-sunglasses-is-isolated-on.jpg?s=612x612&w=0&k=20&c=oMoz9rUr-rDhMGNmEepCkr7F1g3AXs9416hvVnT_4CI=",
    "https://t4.ftcdn.net/jpg/05/72/79/19/360_F_572791996_K9b6rBflENxOXgome76NzXyDq2zmIC9Y.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9dUYzr3f1ACgjAFMqT4OL3an2E1z2LTtyfxwr2FXiJw&s",
    "https://steamuserimages-a.akamaihd.net/ugc/1644340994747007967/853B20CD7694F5CF40E83AAC670572A3FE1E3D35/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpYTOlv2wcTRyNd1Ebq0C24UoX8ysKqCK94E0oxAaC2h53Jz4_4kQfV0IxUrRYx6QtN5o&usqp=CAU",
  ];

    @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigator.push(context,MaterialPageRoute(builder: (context) => BlocProvider.value(value: BlocProvider.of<ProfileBloc>(context),child:const SearchUser(),)));
              // Navigator.push(context,MaterialPageRoute(builder: (context) => ImageUpload(),));
              Navigator.push(context,MaterialPageRoute(builder: (context) => BlocProvider(
  create: (context) => UserpostBloc(),
  child: ImageUploadScreen(),
),));
            },

          ),
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.keyboard_backspace))
            : null,
        backgroundColor: Colors.black,
        title: const Text(
          "lilstuart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: DefaultTabController(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4),
                  child: TabBarView(children: [
                    PostGallery(photosList: photosList),
                    const ProfileReelSection(),
                    const ProfileTagSection(),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
