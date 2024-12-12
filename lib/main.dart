import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/view/splash_view/splash_view.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_nav_bloc/admin_nav_bloc.dart';
import 'package:chat_with_bloc/view_model/bio_bloc/bio_bloc.dart';
import 'package:chat_with_bloc/view_model/change_language/change_language_bloc.dart';
import 'package:chat_with_bloc/view_model/change_language/change_language_event.dart';
import 'package:chat_with_bloc/view_model/change_language/change_language_state.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_bloc.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_event.dart';
import 'package:chat_with_bloc/view_model/change_theme_bloc/change_theme_state.dart';
import 'package:chat_with_bloc/view_model/create_post_bloc/create_post_bloc.dart';
import 'package:chat_with_bloc/view_model/profile_bloc/profile_bloc.dart';
import 'package:chat_with_bloc/view_model/setting_bloc/setting_bloc.dart';
import 'package:chat_with_bloc/view_model/story_bloc/story_bloc.dart';
import 'package:chat_with_bloc/view_model/edit_bloc/edit_bloc.dart';
import 'package:chat_with_bloc/view_model/filter_bloc.dart/filter_bloc.dart';
import 'package:chat_with_bloc/view_model/gallery_bloc/gallery_bloc.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:chat_with_bloc/view_model/inbox_bloc/inbox_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/map_bloc/map_bloc.dart';
import 'package:chat_with_bloc/view_model/dob_bloc/dob_bloc.dart';
import 'package:chat_with_bloc/view_model/matches_bloc/matches_bloc.dart';
import 'package:chat_with_bloc/view_model/otp_bloc/otp_bloc.dart';
import 'package:chat_with_bloc/view_model/phone_number_bloc/phone_number_bloc.dart';
import 'package:chat_with_bloc/view_model/preference_bloc/preference_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_in_bloc/sign_in_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/sign_up_bloc/sign_up_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'utils/notification_utils.dart';
import 'view_model/admin_bloc/admin_home_bloc/admin_home_bloc.dart';
import 'view_model/admin_bloc/admin_inbox_bloc/admin_inbox_bloc.dart';
import 'view_model/admin_bloc/admin_reports_bloc/admin_report_bloc.dart';
import 'view_model/chat_bloc/post_bloc/post_bloc.dart';
import 'view_model/contact_us_bloc/contact_us_bloc.dart';
import 'view_model/gender_bloc/gender_bloc.dart';
import 'view_model/location_permission_bloc/location_bloc.dart';
import 'view_model/chat_bloc/chat_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const testStripePublishKey = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await NotificationUtils.init();
  Stripe.publishableKey = testStripePublishKey;
  Stripe.merchantIdentifier = Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await dotenv.load();
  AppTheme.initThemeMode();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => UserBaseBloc()),
      BlocProvider(create: (_) => SignInBloc()),
      BlocProvider(create: (_) => SignUpBloc()),
      BlocProvider(create: (_) => MainBloc()),
      BlocProvider(create: (_) => InboxBloc()),
      BlocProvider(create: (_) => ChatBloc()),
      BlocProvider(create: (_) => LocationBloc()),
      BlocProvider(create: (_) => MapBloc()),
      BlocProvider(create: (_) => DobBloc()),
      BlocProvider(create: (_) => GenderBloc()),
      BlocProvider(create: (_) => PreferenceBloc()),
      BlocProvider(create: (_) => HomeBloc()),
      BlocProvider(create: (_) => FilterBloc()),
      BlocProvider(create: (_) => MatchesBloc()),
      BlocProvider(create: (_) => BioBloc()),
      BlocProvider(create: (_) => PhoneNumberBloc()),
      BlocProvider(create: (_) => GalleryBloc()),
      BlocProvider(create: (_) => OtpBloc()),
      BlocProvider(create: (_) => ChangeThemeBloc()),
      BlocProvider(create: (_) => EditBloc()),
      BlocProvider(create: (_) => StoryBloc()),
      BlocProvider(create: (_) => SettingBloc()),
      BlocProvider(create: (_) => ContactUsBloc()),
      BlocProvider(create: (_) => PostBloc()),
      BlocProvider(create: (_) => CreatePostBloc()),
      BlocProvider(create: (_) => ProfileBloc()),
      BlocProvider(create: (_) => AdminHomeBloc()),
      BlocProvider(create: (_) => AdminInboxBloc()),
      BlocProvider(create: (_) => AdminReportBloc()),
      BlocProvider(create: (_) => AdminNavBloc()),
      BlocProvider(create: (_) => ChangeLanguageBloc()),
    ],
    child: const MyApp(),
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  BuildContext? ancestorContext;

  @override
  void initState() {
    context.read<ChangeLanguageBloc>().add(OnitLanguage());
    context.read<ChangeThemeBloc>().add(OninitTheme());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateOnLineAndOfflineStatus(true);
    } else if (state == AppLifecycleState.paused) {
      _updateOnLineAndOfflineStatus(false);
    }
  }

  _updateOnLineAndOfflineStatus(bool isOnline) async {
    await FirebaseFirestore.instance
        .collection(UserModel.tableName)
        .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
        .set({"isOnline": isOnline}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: BlocBuilder<ChangeLanguageBloc, ChangeLanguageState>(
          builder: (context, state) {
        ancestorContext = context;
        return BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
            builder: (context, themeState) {
          return ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return ValueListenableBuilder(
                    valueListenable: AppTheme.themeNotifier,
                    builder: (_, ThemeMode currentMode, __) {
                      SystemChrome.setSystemUIOverlayStyle(
                        AppTheme.themeMode == ThemeMode.light
                            ? SystemUiOverlayStyle.dark
                            : SystemUiOverlayStyle.light,
                      );
                      return MaterialApp(
                        localizationsDelegates: const [
                          AppLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                        ],
                        themeMode: AppTheme.themeNotifier.value,
                        theme: AppTheme.lightTheme,
                        darkTheme: AppTheme.darkTheme,
                        locale: state.locale,
                        supportedLocales: AppLocalizations.supportedLocales,
                        debugShowCheckedModeBanner: false,
                        builder: (context, child) {
                          return Directionality(
                            textDirection: TextDirection.ltr,
                            child: child!,
                          );
                        },
                        home: const SplashView(),
                      );
                    });
              });
        });
      }),
    );
  }
}

// class AudioPage extends StatefulWidget {
//   const AudioPage({super.key});

//   @override
//   AudioPageState createState() => AudioPageState();
// }

// class AudioPageState extends State<AudioPage> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();

//   bool _isRecording = false;
//   String _audioFilePath = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeRecorder();
//     _initializePlayer();
//   }

//   Future<void> _initializeRecorder() async {
//     await _recorder.openRecorder();
//   }

//   Future<void> _initializePlayer() async {
//     await _player.openPlayer();
//   }

//   Future<String> _getFilePath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return '${directory.path}/audio_example.aac';
//   }

//   Future<void> _startRecording() async {
//     String filePath = await _getFilePath();
//     await _recorder.startRecorder(toFile: filePath);
//     setState(() {
//       _isRecording = true;
//       _audioFilePath = filePath;
//     });
//   }

//   Future<void> _stopRecording() async {
//     await _recorder.stopRecorder();
//     setState(() {
//       _isRecording = false;
//     });
//   }

//   Future<void> _playRecording() async {
//     await _player.startPlayer(fromURI: _audioFilePath);
//   }

//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     _player.closePlayer();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flutter Sound Example')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _isRecording ? _stopRecording : _startRecording,
//               child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _playRecording,
//               child: const Text('Play Recorded Sound'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
