import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../flavors/build_config.dart';
import '../../network/exceptions/base_api_exception.dart';
import '../utils/it_dialog.dart';
import '../values/app_colors.dart';
import '/app/core/model/page_state.dart';
import '/app/network/exceptions/api_exception.dart';
import '/app/network/exceptions/app_exception.dart';
import '/app/network/exceptions/json_format_exception.dart';
import '/app/network/exceptions/network_exception.dart';
import '/app/network/exceptions/not_found_exception.dart';
import '/app/network/exceptions/service_unavailable_exception.dart';
import '/app/network/exceptions/unauthorize_exception.dart';

abstract class BaseController extends GetxController {
  final Logger logger = BuildConfig.instance.config.logger;
  final logoutController = false.obs;

  //Reload the page
  final _refreshController = false.obs;

  refreshPage(bool refresh) => _refreshController(refresh);

  //Controls page state
  final _pageSateController = PageState.DEFAULT.obs;

  PageState get pageState => _pageSateController.value;

  updatePageState(PageState state) => _pageSateController(state);

  resetPageState() => _pageSateController(PageState.DEFAULT);

  showLoading() => updatePageState(PageState.LOADING);

  hideLoading() => resetPageState();

  final _messageController = ''.obs;

  String get message => _messageController.value;

  showMessage(String msg) => _messageController(msg);

  final _errorMessageController = ''.obs;

  String get errorMessage => _errorMessageController.value;

  showErrorMessage(String msg) {
    _errorMessageController(msg);
  }

  final _successMessageController = ''.obs;

  String get successMessage => _messageController.value;

  showSuccessMessage(String msg) => _successMessageController(msg);

  // ignore: long-parameter-list
  dynamic callDataService<T>(Future<T> future,
      {
        // Function(Exception exception)? onError,
        Function(BaseApiException exception)? onError,
        Function(T response)? onSuccess,
        Function? onStart,
        Function? onComplete,
        bool isErrorShow = true,
        Map<String, dynamic>? message}) async {
    // Exception? _exception;
    BaseApiException? _exception;

    onStart == null ? showLoading() : onStart();

    try {
      final T response = await future;

      if (onSuccess != null) onSuccess(response);

      onComplete == null ? hideLoading() : onComplete();

      return response;
    } on ServiceUnavailableException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on UnauthorizedException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on TimeoutException catch (exception) {
      // _exception = exception;
      _exception = ApiException(
          httpCode: 0, status: '', message: exception.message ?? '');
      showErrorMessage(exception.message ?? 'Timeout exception');
    } on NetworkException catch (exception) {
      // _exception = exception;
      _exception = ApiException(
          httpCode: 0, status: '', message: exception.message);
      showErrorMessage(exception.message);
    } on JsonFormatException catch (exception) {
      // _exception = exception;
      _exception = ApiException(
          httpCode: 0, status: '', message: exception.message);
      showErrorMessage(exception.message);
    } on NotFoundException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message);
    } on ApiException catch (exception) {
      _exception = exception;
      if(_exception.message.contains('+91')){
        isErrorShow = false;
        showDialog(
          context: Get.context!,
          builder: (context) =>
              AlertDialog(
                content: Text(_exception?.message ?? ''),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.deletePrimary),),
                  ),
                  TextButton(
                    onPressed: () {
                      launchUrl(Uri.parse(
                          'tel://${9999999999}'));
                    },
                    child: const Text('Call', style: TextStyle(color: AppColors.colorPrimary),),
                  ),
                ],
              ),
        );
      }
    } on AppException catch (exception) {
      // _exception = exception;
      _exception = ApiException(
          httpCode: 0, status: '', message: exception.message);
      showErrorMessage(exception.message);
    } catch (error) {
      // _exception = AppException(messge: "$error");
      _exception =
          ApiException(httpCode: 0, status: '', message: error.toString());
      logger.e('Controller>>>>>> error $error');
    }

    if (onError != null) {
      onError(_exception);
    } else if (isErrorShow){
      ITDialogs.defaultDialog(_exception.message);
    }
    onComplete == null ? hideLoading() : onComplete();
  }

  @override
  void onClose() {
    _messageController.close();
    _refreshController.close();
    _pageSateController.close();
    super.onClose();
  }
}
