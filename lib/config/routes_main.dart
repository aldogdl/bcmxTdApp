import 'package:flutter/material.dart';

import '../src/controller/init_config_controller.dart';
import '../src/controller/login_controller.dart';
import '../src/controller/index_controller.dart';
import '../src/controller/td_data_contac_controller.dart';
import '../src/controller/td_data_links_controller.dart';
import '../src/controller/td_data_disenio_controller.dart';
import '../src/controller/td_data_franq_cats_cost_controller.dart';
import '../src/controller/td_data_send_controller.dart';
import '../src/controller/td_data_send_finish_controller.dart';

class RoutesMain {

  Map<String, Widget Function(BuildContext)> getRutas(BuildContext context) {

    return {
      'init_config_ctrl'             : (context) => InitConfigController(),
      'login_ctrl'                   : (context) => LoginController(),
      'index_ctrl'                   : (context) => IndexController(),
      'td_data_contac'               : (context) => TdDataContacController(),
      'td_data_links'                : (context) => TdDataLinksController(),
      'td_data_disenio'              : (context) => TdDataDisenioController(),
      'td_data_fr_ca_co'             : (context) => TdDataFranqCatsCostController(),
      'td_data_send'                 : (context) => TdDataSendController(),
      'td_data_send_finish'          : (context) => TdDataSendFinishController()
    };
  }
}