import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/contact_us_bloc/contact_us_bloc.dart';
import 'package:chat_with_bloc/view_model/contact_us_bloc/contact_us_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/thread_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../view_model/contact_us_bloc/contact_us_event.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  void initState() {
    context.read<ContactUsBloc>().add(OninintContactus(context: context));
    super.initState();
  }

  ContactUsBloc ancestorContext = ContactUsBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<ContactUsBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ancestorContext.add(OnDisposeContact());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body:
          BlocBuilder<ContactUsBloc, ContactUsState>(builder: (context, state) {
        return Column(
          children: [
            const AppHeight(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Text(AppLocalizations.of(context)!.contactUs,
                      style: AppTextStyle.font25
                          .copyWith(color: AppTheme.of(context).textColor)),
                  const SizedBox(width: 50)
                ],
              ),
            ),
            const AppHeight(height: 10),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children:
                      List.generate(state.adminThreadList.length, (index) {
                    return ThreadWidget(
                        threadModel: state.adminThreadList[index]);
                  }),
                ),
              ),
            ))
          ],
        );
      }),
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  final ContactUsBloc bloc;

  const MyInheritedWidget({
    super.key,
    required this.bloc,
    required super.child,
  });

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    return false;
  }
}
