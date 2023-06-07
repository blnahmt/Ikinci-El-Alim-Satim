import 'package:flutter/material.dart';
import 'package:ikinci_el/core/auth/auth_manager.dart';
import 'package:ikinci_el/core/models/record_detail.dart';
import 'package:ikinci_el/core/models/user_detail.dart';
import 'package:ikinci_el/core/navigation/fade_route.dart';
import 'package:ikinci_el/core/navigation/routes.dart';
import 'package:ikinci_el/ui/views/auth/create_new_user.dart';
import 'package:ikinci_el/ui/views/auth/signin_view.dart';
import 'package:ikinci_el/ui/views/auth/signup_view.dart';
import 'package:ikinci_el/ui/views/pages/add_record_view.dart';
import 'package:ikinci_el/ui/views/pages/edit_record_view.dart';
import 'package:ikinci_el/ui/views/pages/home_view.dart';
import 'package:ikinci_el/ui/views/pages/profile_view.dart';
import 'package:ikinci_el/ui/views/pages/record_details_view.dart';
import 'package:ikinci_el/ui/views/pages/setting_view.dart';

class ScreenRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return FadeRoute(
          page: AuthManager().auth.currentUser == null
              ? const SignINView()
              : const HomeView(),
        );
      case Routes.signup:
        return FadeRoute(
          page: const Center(
            child: SignUPView(),
          ),
        );
      case Routes.signin:
        return FadeRoute(
          page: const Center(
            child: SignINView(),
          ),
        );
      case Routes.home:
        return FadeRoute(
          page: const HomeView(),
        );

      case Routes.profile:
        return FadeRoute(
          page: const ProfileView(),
        );

      case Routes.createNewUser:
        return FadeRoute(
          page: const CreateNewUserView(),
        );
      case Routes.addNewRecord:
        return FadeRoute(
          page: const AddNewRecordView(),
        );
      case Routes.editRecord:
        RecordDetail record = settings.arguments as RecordDetail;
        return FadeRoute(
          page: EditRecordView(
            recordDetail: record,
          ),
        );
      case Routes.recordDetail:
        List<Object?> args = settings.arguments as List<Object?>;

        return FadeRoute(
          page: RecordDetailView(
              record: args.first as RecordDetail,
              user: args[1] as UserDetail,
              isProfile: args[2] as bool),
        );
      case Routes.settings:
        return FadeRoute(
          page: SettingsView(),
        );

      default:
        return FadeRoute(
          page: Center(
            child: Text(
              'No route defined for ${settings.name}',
            ),
          ),
        );
    }
  }
}
