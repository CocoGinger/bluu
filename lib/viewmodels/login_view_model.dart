import 'package:bluu/constants/route_names.dart';
import 'package:bluu/utils/locator.dart';
import 'package:bluu/services/analytics_service.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/dialog_service.dart';
import 'package:bluu/services/navigation_service.dart';
import 'package:flutter/foundation.dart';

import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future aVerify(phone, cred) async {
    var result = await _authenticationService.autoVerify(cred, phone);

    if (result is bool) {
      if (result) {
        await _analyticsService.logLogin();
        _navigationService.navigateHome(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: "Some unknown error",
      );
    }
  }

  Future verify(
      {@required code, @required phone, @required verificationId}) async {
    setBusy(true);
    var result = await _authenticationService.phoneVerify(
        verificationId: verificationId, code: code, phone: phone);
    setBusy(false); 
    if (result is bool) {
      if (result) {
        await _analyticsService.logLogin();
        _navigationService.navigateHome(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: "Some unknown error",
      );
    }
  }

  Future login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _analyticsService.logLogin();
        _navigationService.navigateHome(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: "Some unknown error",
      );
    }
  }

  Future signUp({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
        email: email, password: password, fullName: fullName);

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _analyticsService.logSignUp();
        _navigationService.navigateHome(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: "Some unknown error",
      );
    }
  }
}
