import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SocialMediaInfo> socialMediaList = [
      _SocialMediaInfo(
        icon: FontAwesomeIcons.facebookF,
        title: 'Follow us on Facebook',
        color: AppColors.facebookColor,
        url: 'https://www.facebook.com/p/Ceylon-Meditation-Center-UAE-61571288357698/?',
      ),
      _SocialMediaInfo(
        icon: FontAwesomeIcons.whatsapp,
        title: 'Chat on WhatsApp',
        color: AppColors.whatsappColor,
        url: 'https://wa.me/${AppData.whatsAppNumber}',
      ),
      _SocialMediaInfo(
        icon: FontAwesomeIcons.instagram,
        title: 'Follow us on Instagram',
        color: AppColors.instagramColor,
        url: 'https://www.instagram.com/ceylonmeditationcenteruae',
      ),
      _SocialMediaInfo(
        icon: FontAwesomeIcons.tiktok,
        title: 'Follow us on TikTok',
        color: Colors.black,
        url: 'https://www.tiktok.com/@ceylon_meditation_center',
      ),
      _SocialMediaInfo(
        icon: FontAwesomeIcons.youtube,
        title: 'Subscribe on YouTube',
        color: AppColors.youtubeColor,
        url: 'https://youtube.com/@ahangamarathanawansathero1850?si=cFiGdYH6dNAnB6bZ',
      ),
      _SocialMediaInfo(
        icon: FontAwesomeIcons.link,
        title: 'Visit our website',
        color: AppColors.websiteColor,
        url: 'https://ceylonmeditationcenter.com/',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Social Media',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: socialMediaList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final social = socialMediaList[index];
            return _buildBeautifulCard(context, social);
          },
        ),
      ),
    );
  }

  Widget _buildBeautifulCard(BuildContext context, _SocialMediaInfo social) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(social.url);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [social.color.withOpacity(0.9), social.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: social.color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 24),
            FaIcon(social.icon, color: Colors.white, size: 28),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                social.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _SocialMediaInfo {
  final IconData icon;
  final String title;
  final Color color;
  final String url;

  _SocialMediaInfo({
    required this.icon,
    required this.title,
    required this.color,
    required this.url,
  });
}
