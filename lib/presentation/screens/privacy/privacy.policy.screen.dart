import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.primaryColor,
         
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'ගෝලීය රහස්‍යතා ප්‍රතිපත්තිය — Meditation Center UAE',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Effective date: October 4, 2025',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),

                // Intro
                Text(
                  '1. හැඳින්වීම',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'මේ Privacy Policy (පෞද්ගලිකත්ව ප්‍රතිපත්තිපත්‍රය) ඔබට Meditation Center UAE (ඉන්පසු "අප", "අපේ") විසින් ඔබ ගේ දත්ත කෙරෙහි කරන ක්‍රියා පටිපාටි, ඒ දත්ත එකතු කරන ආකාරය, භාවිතය සහ ඔබට ඇති අයිතිවාසිකම් පැහැදිලි කරයි. ඇප් එක භාවිතය කිරීමෙන් ඔබ මෙම ප්‍රතිපත්තියට එකඟ වන බව සැලකේ.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),

                // Data collected
                Text(
                  '2. අප විසින් එකතු කරන දත්ත',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'අපට පහත දේවල් එකතු කිරීමක් සිදු විය හැක:',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                _bullet(theme, 'Account information — නම, email, profile picture (ඔබ සපයන විට).'),
                _bullet(theme, 'Authentication data — Google / Facebook login identifiers.'),
                _bullet(theme, 'Device & usage data — device model, OS, app usage patterns (analytics සඳහා).'),
                _bullet(theme, 'Notifications — push notification tokens (සංදේශ යැවීමට).'),
                _bullet(theme, 'Local storage files — ඔබගේ පෞද්ගලික සැකසුම්, download කරගත් media/temporary files (ඇප් තුළ local storage හි).'),
                const SizedBox(height: 12),

                // Purpose
                Text(
                  '3. දත්ත භාවිතය හේතු',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'ඔබගේ දත්ත පහත අරමුණු සඳහා භාවිතා කරයි:',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                _bullet(theme, 'Service delivery — ඇප් එකේ features ක්‍රියාත්මක කිරීමට.'),
                _bullet(theme, 'Notifications — විශේෂ අවස්ථා, updates, reminders යවීමට.'),
                _bullet(theme, 'Authentication — Google/Facebook login හරහා user verification.'),
                _bullet(theme, 'Analytics — app usage වර්ධනය හා දෝෂ සොයා ගැනීමට (Firebase Analytics වැනි third-party tools භාවිතා කරයි).'),
                _bullet(theme, 'Security & support — fraud prevention සහ පාරිභෝගික සහය සැපයීමට.'),

                const SizedBox(height: 12),

                // Firebase and third parties
                Text(
                  '4. Firebase සහ තෙවන පාර්ශව සේවා',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'අප Firebase (Authentication, Firestore/Realtime DB, Cloud Messaging, Analytics වැනි සේවා) භාවිතා කරයි. Firebase සහ තවත් third-party සේවා (උදා: Google, Facebook, analytics providers) ඔබේ දත්ත අධියරවීම සහ ප්‍රතිපත්තීන් අනුව සංරක්ෂණය/දකී. ඔබට third-party privacy policies කළමනාකරණය කිරීම සඳහා එම සේවා සපයන්නන්ගේ policies බලන්න කියවීම යෝජිතයි.',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // Notifications and local storage
                Text(
                  '5. Push Notifications හා Local Storage',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Notifications වලට push token එකක් අප සුරක්ෂිතව ගබඩා කරයි. ඔබ notifications අක්‍රීය කළහොත් තවදුරටත් එවීම නවත්වනු ලැබේ. Local storage ආකාරයෙන් ඇප් එක ඔබගේ පෞද්ගලික උපාංගයේ දත්ත (cache, saved files) භාවිතා කරයි — ඒවා උපාංගයෙන්ම මකන්න පුළුවන්.',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // Sharing
                Text(
                  '6. දත්ත බෙදාගැනීම සහ ප්‍රකාශනය',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'අප ඔබේ පුද්ගලික දත්ත තෙවන පාර්ශවයන්ට විකිණීමේ හෝ ආරක්ෂක නොවන ප්‍රයෝජන සඳහා බෙදා නොදෙයි. නමුත් පහත අවස්ථාවල දත්ත බෙදා හැරිය හැක:',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                _bullet(theme, 'සේවා සැපයුම්කරුවන් — Firebase, analytics providers වැනි සේවා.'),
                _bullet(theme, 'නීත්‍යානුකූල අවශ්‍යතා — නීතිමය ඉල්ලීම් අනුව.'),
                _bullet(theme, 'එක්කෝෂකයින්/පැරණි භාවිතයේදී වෙනත් සංයුතියකට (business transfer) උපාංගික අවස්ථාවන්.'),

                const SizedBox(height: 12),

                // Security
                Text(
                  '7. ආරක්ෂාව',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'අපි ඔබේ දත්ත ආරක්ෂා කිරීමට සාමාන්‍යයෙන් පිළිවෙලෙන් security measures (encryption, access controls) ක්‍රියාත්මක කරමු. නමුත් කිසිදු ක්‍රමයක් 100% ආරක්ෂිත නොවන බැවින් ඔබටද මූලික අවශ්‍යතා (  device lock) පවත්වා ගැනීමට යෝජනා කරමු.',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // Children
                Text(
                  '8. ළමුන් පිළිබඳ ප්‍රතිපත්තිය',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'අපේ සේවාව 13 හැවිරිදිවලට පහළ ළමුන් සඳහා නිර්දේශ නොවේ. 13 යටිතලයේ පිරිසකින් දත්ත එකතු කරන අවස්ථාවල', 
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'ඔබ 13 හැවිරිදිට වඩා වැඩි බවට සහතික නොකරන විට ඔබගේ guardian/parent අවසරය ලබා ගත යුතුය.',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // User rights
                Text(
                  '9. ඔබගේ අයිතිවාසිකම්',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                _bullet(theme, 'දත්ත ප්‍රවේශය — ඔබ අප සමග තිබෙන ඔබගේ දත්ත නැරඹිය හැක.'),
                _bullet(theme, 'දත්ත පහසුකම් — ඔබට දත්ත සකස් කිරීම හෝ මැකීම ඉල්ලිය හැක (නීතිමය සීමා යටතේ).'),
                _bullet(theme, 'Notifications disable කිරීම — ඔබ settings තුළින් notification ආවරණය කළ හැක.'),

                const SizedBox(height: 12),

                // Changes
                Text(
                  '10. ප්‍රතිපත්තියේ වෙනස්කම්',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'අප මෙම ප්‍රතිපත්තිය සමහරවිට යාවත්කාලීන කරනු ඇත. ප්‍රධාන වෙනස්කම් සිදු වන්නේ නම් අපි app තුළ හෝ registered email මඟින් ඔබට දැන්වීම් ලබා දෙන්නෙමු.',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // Contact
                Text(
                  '11. අප හා සම්බන්ධ වන්න',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Privacy relate කරුණු, දත්ත ප්‍රවේශ ඉල්ලීම් හෝ වෙනත් ගැටලු සඳහා අපව අමතන්න:',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, size: 18),
                    const SizedBox(width: 8),
                    SelectableText(
                      'info.app.cmc@gmail.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),

 
               

                const SizedBox(height: 40),

                // Footer
                Center(
                  child: Text(
                    '© 2025 Meditation Center UAE',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),

               
                 
              ],
            ),
          ),
        ),
      ),
    );
  }

  // helper to render bullet rows
  static Widget _bullet(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
