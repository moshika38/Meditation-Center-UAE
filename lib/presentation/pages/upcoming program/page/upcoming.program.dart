import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.loading.dart';
import 'package:meditation_center/core/formatter/datetime.formatter.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/presentation/components/empty.data.card.dart';
import 'package:meditation_center/presentation/pages/upcoming%20program/widgets/add.new.events.dart';
import 'package:provider/provider.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/event.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
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

  void _deleteEvent(String eventID) {
    final provider = Provider.of<EventsProvider>(context, listen: false);
    provider.deleteEvent(eventID);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /// ✅ HEADER
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

          /// ✅ EVENTS LIST / LOADER
          Consumer<EventsProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<List<EventModel>>(
                stream: provider.getAllEvents(),
                builder: (context, snapshot) {
                  // ✅ LOADING (CENTER)
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: PageLoader(),
                      ),
                    );
                  }

                  // ✅ ERROR
                  if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'Error loading events',
                          style: TextStyle(color: AppColors.gray),
                        ),
                      ),
                    );
                  }

                  final events = snapshot.data ?? [];

                  // ✅ EMPTY
                  if (events.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: EmptyDataCard(
                          title: "No upcoming events yet !",
                        ),
                      ),
                    );
                  }

                  // ✅ DATA
                  return _eventCard(events);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// ✅ ADMIN BUTTON
  Widget _buildAdminButton() {
    if (id.isEmpty) {
      return const Icon(Icons.event, color: AppColors.primaryColor);
    }

    return Consumer<UserProvider>(
      builder: (context, userP, child) {
        return FutureBuilder<UserModel?>(
          future: userP.getUserById(id),
          builder: (context, snapshot) {
            final user = snapshot.data;
            isAdmin = user?.isAdmin ?? false;

            if (!snapshot.hasData || user == null) {
              return const Icon(Icons.event,
                  color: AppColors.primaryColor);
            }

            return user.isAdmin
                ? GestureDetector(
                    onTap: () {
                      AddNewEvents.showAddWindow(context);
                    },
                    child: const Icon(
                      Icons.add_box_rounded,
                      color: AppColors.primaryColor,
                    ),
                  )
                : const Icon(Icons.event,
                    color: AppColors.primaryColor);
          },
        );
      },
    );
  }

  /// ✅ EVENT LIST
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
                  PopupWindow.showPopupWindow(
                    "Are you sure you want to delete this event?",
                    "Yes, Delete",
                    context,
                    () {
                      _deleteEvent(event.id!);
                      context.pop();
                    },
                    () => context.pop(),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 12),
                    _rowText("දිනය : ${event.date}", Icons.date_range),
                    const SizedBox(height: 12),
                    _rowText("වේලාව : ${event.time}", Icons.timelapse),

                    if (event.place!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _rowText("ස්ථානය : ${event.place}", Icons.place),
                    ],

                    if (event.contact!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _rowText(
                          "වැඩි විස්තර සදහා : ${event.contact}",
                          Icons.person),
                    ],

                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        DatetimeFormatter.timeAgo(event.dateTime!),
                        style:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: AppColors.gray,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ✅ ROW TEXT
  Widget _rowText(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.gray),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
