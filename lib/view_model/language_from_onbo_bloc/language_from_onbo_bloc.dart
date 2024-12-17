import 'package:chat_with_bloc/view_model/change_language/change_language_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../change_language/change_language_event.dart';
import 'language_from_onbo_event.dart';
import 'language_from_onbo_state.dart';

class LanguageFromOnboBloc
    extends Bloc<LanguageFromOnboEvent, LanguageFromOnboState> {
  LanguageFromOnboBloc() : super(LanguageFromOnboState(currentIndex: -1)) {
    on<UdateLanguage>(_updateLanguage);
  }

  _updateLanguage(UdateLanguage event, Emitter<LanguageFromOnboState> emit) {
    event.context
        .read<ChangeLanguageBloc>()
        .add(ChnageLocale(code: event.code));

    emit(state.copyWith(currentIndex: event.index));
  }
}
