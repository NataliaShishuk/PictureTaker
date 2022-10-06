import 'dart:io';

import 'package:flutter/material.dart';

class PictureGalleryScreen extends StatefulWidget {
  const PictureGalleryScreen({
    super.key,
    required this.pictures,
  });

  final List<File> pictures;

  @override
  State<PictureGalleryScreen> createState() => _PictureGalleryScreenState();
}

class _PictureGalleryScreenState extends State<PictureGalleryScreen> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    const spaceSize = 5.0;
    const cardSize = 120.0;

    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(context),
      ),
      body: GridView.extent(
        padding: const EdgeInsets.all(spaceSize),
        crossAxisSpacing: spaceSize,
        mainAxisSpacing: spaceSize,
        maxCrossAxisExtent: cardSize,
        primary: false,
        shrinkWrap: true,
        children: widget.pictures
            .map((picture) => _buildPictureCard(context, picture))
            .toList(),
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    final picturesLength = widget.pictures.length;

    final picturesNumberText = picturesLength == 1
        ? '$picturesLength picture'
        : '$picturesLength pictures';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gallery'),
        if (widget.pictures.isNotEmpty)
          Text(
            picturesNumberText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          )
      ],
    );
  }

  Widget _buildPictureCard(BuildContext context, File picture) {
    return Stack(
      children: [
        Image.file(
          picture,
          cacheWidth: 300,
          cacheHeight: 300,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTapDown: (details) => _getTapPosition(details),
              onTap: () => _onPictureTap(context, picture),
              onLongPress: () async => _onPictureLondTap(context, picture),
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuEntry _buildMenuItem(
    String title, {
    IconData? icon,
    void Function()? onPressed,
    Color? color,
  }) {
    return PopupMenuItem(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  _getTapPosition(TapDownDetails details) {
    final referenceBox = context.findRenderObject() as RenderBox;

    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void _onPictureTap(BuildContext context, File picture) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.7),
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(scale: animation, child: child);
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(child: Image.file(picture));
        });
  }

  Future<void> _onPictureLondTap(BuildContext context, File picture) async {
    final renderBox = context.findRenderObject() as RenderBox;

    final left = _tapPosition.dx;
    final top = _tapPosition.dy;
    final right = left + renderBox.size.width;
    final bottom = top + renderBox.size.height;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: <PopupMenuEntry>[
        _buildMenuItem(
          'Share',
          icon: Icons.share,
          onPressed: () => _removePicture(picture),
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          'Delete',
          icon: Icons.delete_outline_sharp,
          onPressed: () => _removePicture(picture),
          color: Colors.red,
        ),
      ],
    );
  }

  void _removePicture(File picture) {
    return setState(() {
      widget.pictures.remove(picture);
    });
  }
}
