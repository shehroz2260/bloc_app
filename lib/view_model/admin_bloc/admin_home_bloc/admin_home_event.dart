abstract class AdminHomeEvent {}

class AdminHomeInit extends AdminHomeEvent {}

class OnChangedTextField extends AdminHomeEvent {
  final String val;
  OnChangedTextField({
    required this.val,
  });
}

class OnChangeVerify extends AdminHomeEvent {
  final bool val;
  OnChangeVerify({
    required this.val,
  });
}
