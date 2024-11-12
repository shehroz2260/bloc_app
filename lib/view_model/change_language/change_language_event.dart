// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class ChangeLanguageEvent {}

class ChnageLocale extends ChangeLanguageEvent {
  final String code;
  ChnageLocale({
    required this.code,
  });
}

class OnitLanguage extends ChangeLanguageEvent {}
