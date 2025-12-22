import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.loading.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColors.whiteColor,
        centerTitle: false,
        title: Text(
          'Users List',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.pureBlack,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.pureBlack,
            size: 20,
          ),
        ),
      ),
      body: Consumer(
        builder: (context, UserProvider userProvider, child) => FutureBuilder(
          future: userProvider.getAllUsers(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child:   PageLoader());
            }
            if (asyncSnapshot.hasError) {
              return Center(child: Text('Error: ${asyncSnapshot.error}'));
            }
            final users = asyncSnapshot.data as List<UserModel>;
            final TextStyle style=Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray,fontWeight: FontWeight.bold);
            return Column(
              children: [
                
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Users:',style: style),
                      Text( "${users.length}",style: style),
                    ],
                  ),
                ),
                 
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                  
                      return listCard(
                        context,
                        user.name,
                        user.email,
                        user.profileImage,
                        user.uid,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget listCard(
  BuildContext context,
  String name,
  String email,
  String image,
  String userId,
) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: AppColors.whiteColor,
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.secondaryColor,
        backgroundImage: NetworkImage(image),
      ),
      title: Text(
        name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        email,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: AppColors.gray, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        size: 28,
        color: AppColors.secondaryColor,
      ),
      onTap: () {
        context.push('/profile', extra: userId);
      },
    ),
  );
}
