import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view/auth_view/sign_up_view.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'sign_options_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const AppHeight(height: 70),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Image.asset(AppAssets.onboardingScreen),
            ),
            const AppHeight(height: 40),
            Text(AppStrings.appName,
                style: AppTextStyle.font25.copyWith(color: AppColors.redColor)),
            Text(AppLocalizations.of(context)!.wematchYouWithPeople,
                style: AppTextStyle.font16.copyWith(color: theme.textColor),
                textAlign: TextAlign.center),
            const Spacer(),
            CustomNewButton(
                btnName: AppLocalizations.of(context)!.createAnAccoun,
                onTap: () => Go.to(context, const SignUpView())),
            const AppHeight(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.alreadyHaveAnAccount,
                    style:
                        AppTextStyle.font16.copyWith(color: theme.textColor)),
                GestureDetector(
                    onTap: () => Go.to(context, const SignOptionsView()),
                    child: Text(" ${AppLocalizations.of(context)!.signIn}",
                        style: AppTextStyle.font16
                            .copyWith(color: AppColors.redColor))),
              ],
            ),
            const AppHeight(height: 35),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// class PageViewExample extends StatefulWidget {
//   const PageViewExample({super.key});

//   @override
//   _PageViewExampleState createState() => _PageViewExampleState();
// }

// class _PageViewExampleState extends State<PageViewExample> {
//   PageController? _pageController;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(viewportFraction: 0.8); // Show partial items
//   }

//   @override
//   void dispose() {
//     _pageController?.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int index) {
//     setState(() {
//       _currentPage = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('PageView Example')),
//       body: PageView.builder(
//         controller: _pageController,
//         onPageChanged: _onPageChanged,
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           // Scale the current item and adjust opacity for non-current items
//           final scale = index == _currentPage ? 1.2 : 1.0; 
//           final opacity = index == _currentPage ? 1.0 : 0.5;

//           return Center(
//             child: Transform.scale(
//               scale: scale,
//               child: Opacity(
//                 opacity: opacity,
//                 child: Container(
//                   height: 200, // Base height
//                   width: 150,
//                   decoration: BoxDecoration(
//                     color: Colors.primaries[index % Colors.primaries.length],
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Item ${index + 1}',
//                     style: const TextStyle(fontSize: 24, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }