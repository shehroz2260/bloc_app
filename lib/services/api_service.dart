// import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

// class ApiServices {
//   static const baseUrl =
//       'https://us-central1-kiip-51772.cloudfunctions.net/subscribe';

//   static Future<List<dynamic>> getCardList(BuildContext context) async {
//     var myCustomerId = context.read<UserBaseBloc>().state.userData.cusId;
//     try {
//       var response = await GetConnect()
//           .get('$baseUrl/customer-cards', query: {'customerId': myCustomerId});
//       if (response.isOk) {
//         return (response.body ?? []) as List<dynamic>;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return [];
//   }

//   static Future<void> setDefaultPaymentMethod(
//       String paymentMethodId, BuildContext context) async {
//     var myCustomerId = context.read<UserBaseBloc>().state.userData.cusId;
//     try {
//       var response =
//           await GetConnect().post('$baseUrl/set-default-payment-method', {
//         'customerId': myCustomerId,
//         'paymentMethodId': paymentMethodId,
//       });
//       if (!response.isOk) {
//         throw response.body;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
