import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class NavItems extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const NavItems({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<NavItems> createState() => _NavItemsState();
}

class _NavItemsState extends State<NavItems> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
       
      currentIndex: widget.currentIndex,  
       backgroundColor: Colors.transparent,    
  elevation: 0,
      onTap: widget.onTap,
      items: [
        navBarIcons("assets/svg/home0.svg",widget.currentIndex == 0),
        navBarIcons("assets/svg/note0.svg",widget.currentIndex == 1),
        navBarIcons("assets/svg/add0.svg",widget.currentIndex == 2),
        navBarIcons("assets/svg/calendar0.svg",widget.currentIndex == 3),
        navBarIcons("assets/svg/list0.svg",widget.currentIndex == 4),
      ],
    );
  }

  BottomNavigationBarItem navBarIcons(
    String assetName,
    bool isActive,

  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
       isActive? "${assetName.split("0")[0]}.svg":assetName,
        colorFilter: ColorFilter.mode(isActive?AppColors.primaryColor:AppColors.secondaryColor, BlendMode.srcIn),
        width: 26,
        height: 26,
      ),
      label: "",
    );
  }
}
