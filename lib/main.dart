import 'package:chat_with_bloc/model/user_model.dart';
import 'package:chat_with_bloc/view/splash_view/splash_view.dart';
import 'package:chat_with_bloc/view_model/bio_bloc/bio_bloc.dart';
import 'package:chat_with_bloc/view_model/bloc/story_bloc.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'view_model/gender_bloc/gender_bloc.dart';
import 'view_model/location_permission_bloc/location_bloc.dart';
import 'view_model/chat_bloc/chat_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBaseBloc()),
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => MainBloc()),
        BlocProvider(create: (context) => InboxBloc()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(create: (context) => MapBloc()),
        BlocProvider(create: (context) => DobBloc()),
        BlocProvider(create: (context) => GenderBloc()),
        BlocProvider(create: (context) => PreferenceBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => FilterBloc()),
        BlocProvider(create: (context) => MatchesBloc()),
        BlocProvider(create: (context) => BioBloc()),
        BlocProvider(create: (context) => PhoneNumberBloc()),
        BlocProvider(create: (context) => GalleryBloc()),
        BlocProvider(create: (context) => OtpBloc()),
        BlocProvider(create: (context) => EditBloc()),
        BlocProvider(create: (context) => StoryBloc()),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashView(),
        ),
      ),
    );
  }
}
