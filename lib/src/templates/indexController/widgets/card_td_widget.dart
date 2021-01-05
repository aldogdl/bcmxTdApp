import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bcmxtds/config/globals.dart' as globals;
import 'package:bcmxtds/config/data_shared.dart';

import '../../../repository/data_server_repository.dart';
import '../../../widgets/alerts_varios.dart';

class CardTdWidget extends StatefulWidget {

  final Map<String, dynamic> dataTd;

  CardTdWidget({Key key, this.dataTd}) : super(key: key);

  @override
  _CardTdWidgetState createState() => _CardTdWidgetState();
}

class _CardTdWidgetState extends State<CardTdWidget> {

  AlertsVarios alertsVarios = AlertsVarios();
  DataServerRepository emServer = DataServerRepository();

  bool _showBlock = false;
  bool _isPagado = false;
  IconData _icoPagado = FontAwesomeIcons.handHoldingUsd;
  Color _icoColorPagado = Colors.red;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_initWidget);
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        _card(),
        (_showBlock) ?  _uiBlock() : SizedBox(height: 0)
      ],
    );
  }

  ///
  Future<void> _initWidget(_) async {

    this._isPagado = widget.dataTd['td_isPagado'];
  }

  ///
  Widget _card() {

    if(this._isPagado){ 
      this._icoPagado = FontAwesomeIcons.moneyBillWave;
      this._icoColorPagado = Colors.grey;
    }else{
      this._icoPagado = FontAwesomeIcons.handHoldingUsd;
      this._icoColorPagado = Colors.red;
    }

    return Row(
      children: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.whatsapp, color: (widget.dataTd['d_movil'] == null) ? Colors.grey[300] : Colors.green),
          onPressed: () async => (widget.dataTd['d_movil'] == null) ? null : await _openWhatsapp()
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.phone, color: (widget.dataTd['d_movil'] == null) ? Colors.grey[300] : Colors.blue),
          onPressed: () async => (widget.dataTd['d_movil'] == null) ? null : await _openLlamada()
        ),
        IconButton(
          icon: FaIcon(this._icoPagado, color: this._icoColorPagado),
          onPressed: () async => _marckPagado()
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.eye, color: (widget.dataTd['td_td'] == '0') ? Colors.grey[300] : Colors.orange),
              onPressed: () async => (widget.dataTd['td_td'] == '0') ? null : await _openInternet()
            )
          ),
        )
      ]
    );
  }

  ///
  Widget _uiBlock() {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(100),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5)
        )
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }

  ///
  Future<void> _openWhatsapp() async {

    String txt = 'Hola ${widget.dataTd['d_nombre']}!! quería preguntarte como va el diseño de ${widget.dataTd['td_nombreEmpresa']}';
    String urlLaunch = 'https://wa.me/52${widget.dataTd['d_movil']}?text=$txt';
    
    if (await canLaunch(urlLaunch)) {
        await launch(urlLaunch);
    } else {
      String body = 'No se encontró un Número Móbil para realizar mensajes';
      alertsVarios.entendido(context, titulo: 'El Dieñador', body: body);
    }
  }

  ///
  Future<void> _openLlamada() async {

    String urlLaunch = 'tel://${widget.dataTd['d_movil']}';
    if (await canLaunch(urlLaunch)) {
        await launch(urlLaunch);
    } else {
      String body = 'No se encontró un Número Móbil para llamara';
      alertsVarios.entendido(context, titulo: 'El Dieñador', body: body);
    }
  }

  ///
  Future<void> _openInternet() async {

    String urlLaunch = '${globals.uriBaseTdPdf}/${widget.dataTd['td_td']}';
    if (await canLaunch(urlLaunch)) {
        await launch(urlLaunch);
    }
  }

  ///
  Future<void> _marckPagado() async {

    setState(() {
      this._showBlock = true;
    });
    String tokenServer = Provider.of<DataShared>(context, listen: false).tokenServer;
    int result = await emServer.marckWithPagado(tokenServer, widget.dataTd['td_id']);

    this._showBlock = false;
    if(result == 1) {
      this._icoPagado = FontAwesomeIcons.moneyBillWave;
      this._icoColorPagado = Colors.grey;
      this._isPagado = true;
    }
    if(result == 0) {
      this._icoPagado = FontAwesomeIcons.handHoldingUsd;
      this._icoColorPagado = Colors.red;
      this._isPagado = false;
    }
    setState(() { });

    if(result == 2) {
      String body = 'Hubo un error al marcar este servicio como pagado o pendiente de pago, inténtalo nuevamente por favor';
      alertsVarios.entendido(context, titulo: 'ERROR AL GUARDAR', body: body);
    }
  }

}