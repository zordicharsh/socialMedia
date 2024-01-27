import 'package:flutter/material.dart';


import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route.dart';
import '../widgets/animated_dialog.dart';
import '../widgets/post_card.dart';

class PostGallery extends StatefulWidget {
  const PostGallery({super.key, required this.photosList});

  final List<String> photosList;

  @override
  State<PostGallery> createState() => _PostGalleryState();
}

class _PostGalleryState extends State<PostGallery> {
  @override
  Widget build(BuildContext context) {
    late OverlayEntry popupDialog;
    return GridView.builder(
      itemCount: widget.photosList.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey.withOpacity(0.2),
          child: GestureDetector(
            onLongPressEnd: (details) => popupDialog.remove(),
            onLongPress: () {
              popupDialog = _createPopupDialog(widget.photosList[index]);
              Overlay.of(context).insert(popupDialog);
            },
            onTap: () {
              Navigator.push(
                  context,
                  CustomPageRoute(
                      child: PostCard(
                          currentImageIndex: widget.photosList[index])));
            },
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(
                widget.photosList[index],
              ),
            ),
          ),
        );
      },
    );
  }

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(child: _createPopupContent(url)),
    );
  }

  Widget _createPopupContent(String url) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Colors.black,
                  child: Image.network(url, fit: BoxFit.cover)),
              _createActionBar(),
            ],
          ),
        ),
      );

  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: Colors.grey[900],
      child: const ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/cat_pic.jpg'),
        ),
        title: Text(
          'lilstuart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));

  Widget _createActionBar() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.grey[900],
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            Icon(
              Icons.chat_bubble_outline_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.send,
              color: Colors.white,
            ),
          ],
        ),
      );
}


