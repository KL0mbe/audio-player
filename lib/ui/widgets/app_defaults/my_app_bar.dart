import 'package:audio_player/ui/widgets/app_defaults/my_body_text.dart';
import 'package:audio_player/ui/widgets/app_defaults/my_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackClick;
  final VoidCallback? onCloseClick;
  final Widget? rightAction;

  const MyAppBar({super.key, required this.title, this.onBackClick, this.onCloseClick, this.rightAction});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      key: ValueKey(title),
      duration: Durations.medium3,
      child: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              onBackClick != null
                  ? MyIconButton(icon: CupertinoIcons.back, onPressed: onBackClick)
                  : SizedBox(width: 48.h),
              MyBodyText(title, fontSize: 20.sp, fontWeight: FontWeight.w600),
              rightAction != null ? rightAction! : SizedBox(width: 48.h),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,

        //Old Way was expanding leading icon to match height
        // actions: rightAction == null ? [] : [Transform.translate(offset: Offset(-24.h, 0), child: rightAction!)],
        // leading: onBackClick != null
        //     ? Transform.translate(
        //         offset: Offset(24.h, 0),
        //         child: MyIconButton(icon: MyIcons.arrowBack, onPressed: onBackClick),
        //       )
        //     : onCloseClick != null
        //     ? Transform.translate(
        //         offset: Offset(24.h, 0),
        //         child: MyIconButton(icon: MyIcons.close, onPressed: onCloseClick),
        //       )
        //     : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
