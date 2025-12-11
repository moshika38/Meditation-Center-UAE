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
       selectedFontSize: 13,
      selectedItemColor: AppColors.primaryColor,
      
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      elevation: 0,
      backgroundColor: Colors.transparent,
      onTap: widget.onTap,
      items: [
        navBarIcon("assets/svg/home0.svg", "assets/svg/home.svg","Home", 0),
        navBarIcon("assets/svg/note0.svg", "assets/svg/note.svg", "Notice", 1),
        navBarIcon("assets/svg/add0.svg", "assets/svg/add.svg", "Add", 2),
        navBarIcon("assets/svg/calendar0.svg", "assets/svg/calendar.svg", "Events", 3),
        navBarIcon("assets/svg/list0.svg", "assets/svg/list.svg", "Menu", 4),
      ],
    );
  }

  BottomNavigationBarItem navBarIcon(
    String inactiveAsset,
    String activeAsset,
    String label,
    int index,
  ) {
    final bool isActive = widget.currentIndex == index;

    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 26,
        height: 26,
        child: SvgPicture.asset(
          isActive ? activeAsset : inactiveAsset,
          colorFilter: ColorFilter.mode(
            isActive ? AppColors.primaryColor : AppColors.secondaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}
