import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/formatter/datetime.formatter.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/presentation/pages/upcoming%20program/widgets/add.new.events.dart';
import 'package:provider/provider.dart';

import 'package:meditation_center/core/shimmer/notice.shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/event.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/providers/events.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';

class UpcomingProgram extends StatefulWidget {
  const UpcomingProgram({super.key});

  @override
  State<UpcomingProgram> createState() => _UpcomingProgramState();
}

class _UpcomingProgramState extends State<UpcomingProgram> {
  final String id = FirebaseAuth.instance.currentUser?.uid ?? '';

  bool isAdmin = false;

  void _deleteEvent(eventID) {
    final provider = Provider.of<EventsProvider>(context, listen: false);
    provider.deleteEvent(eventID);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ඉදිරි වැඩසටහන් පෙළගැස්ම",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                _buildAdminButton(),
              ],
            ),
          ),
          Consumer<EventsProvider>(
            builder: (context, provider, child) =>
                StreamBuilder<List<EventModel>>(
              stream: provider.getAllEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const NoticeCardShimmer();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading events: ${snapshot.error}',
                      style: TextStyle(color: AppColors.gray),
                    ),
                  );
                }

                final events = snapshot.data ?? [];

                if (events.isEmpty) {
                  return Expanded(
                    child: EmptyAnimation(title: "No upcoming events yet !"),
                  );
                }

                return _eventCard(
                  events,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminButton() {
    if (id.isEmpty) {
      return Icon(Icons.event, color: AppColors.primaryColor);
    }

    return Consumer<UserProvider>(
      builder: (context, userP, child) => FutureBuilder<UserModel?>(
        future: userP.getUserById(id),
        builder: (context, snapshot) {
          final user = snapshot.data;
          isAdmin = user?.isAdmin ?? false;

          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              user == null) {
            return Icon(Icons.event, color: AppColors.primaryColor);
          }

          return user.isAdmin
              ? GestureDetector(
                  onTap: () {
                    AddNewEvents.showAddWindow(
                      context,
                    );
                  },
                  child: Icon(
                    Icons.add_box_rounded,
                    color: AppColors.primaryColor,
                  ),
                )
              : Icon(
                  Icons.event,
                  color: AppColors.primaryColor,
                );
        },
      ),
    );
  }

  Widget _eventCard(List<EventModel> events) {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onLongPress: () {
                if (isAdmin) {
                  // delete event
                  PopupWindow.showPopupWindow(
                    "Are you sure you want to delete this event? this event will be deleted from all users.",
                    "Yes, Delete",
                    context,
                    () {
                      // delete
                      _deleteEvent(events[index].id);
                      if (!mounted) return;
                      context.pop();
                    },
                    () {
                      // cancel
                      if (!mounted) return;
                      context.pop();
                    },
                  );
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _rowText(event.time, Icons.timelapse, false),
                      const SizedBox(height: 12),
                      _rowText(event.date, Icons.date_range, false),
                      event.place != ""
                          ? const SizedBox(height: 12)
                          : SizedBox.shrink(),
                      event.place != ""
                          ? _rowText(event.place ?? "", Icons.place, false)
                          : SizedBox.shrink(),
                      event.contact != ""
                          ? const SizedBox(height: 12)
                          : SizedBox.shrink(),
                      event.contact != ""
                          ? _rowText(event.contact ?? "", Icons.person, false)
                          : SizedBox.shrink(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DatetimeFormatter.timeAgo(event.dateTime!),
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.gray,
                                    ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _rowText(
    String text,
    IconData icon,
    bool isPrimary,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isPrimary ? AppColors.primaryColor : AppColors.gray,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      isPrimary ? AppColors.primaryColor : AppColors.textColor,
                  fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
