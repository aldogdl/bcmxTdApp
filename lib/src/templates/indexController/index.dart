import 'package:flutter/material.dart';
import 'package:bcmxtds/config/globals.dart' as globals;

import '../../singletons/lst_tds_singleton.dart';
import '../../repository/data_server_repository.dart';
import 'widgets/card_td_widget.dart';


class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  TextEditingController _bskCtr = TextEditingController();
  LstTdsSingleton lstTdsSng = LstTdsSingleton();
  DataServerRepository emTds = DataServerRepository();
  
  BuildContext _context;
  bool _isInit = false;
  bool _showCargando = false;
  List<Map<String, dynamic>> _lstPrint = new List();
  Widget _queVerInScreen;

  @override
  void dispose() {
    this._bskCtr?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      context = null;
      this._queVerInScreen = _msgBuscarScreen();
    }

    return Container(
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(this._context).size.width,
            height: MediaQuery.of(this._context).size.height * 0.1,
            decoration: BoxDecoration(
              color: const Color(0xff0070B3)
            ),
            child: _inputBuscar(),
          ),
          Flexible(
            child: Container(
              width: MediaQuery.of(this._context).size.width,
              height: (MediaQuery.of(this._context).size.height - (MediaQuery.of(this._context).size.height * 0.1) - 24),
              decoration: BoxDecoration(
                color: Colors.grey
              ),
              child: (!this._showCargando) ? this._queVerInScreen :  _cargando()
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _msgBuscarScreen({msg:'Busca Tarjetas Digitales por medio de Palabras Claves. app. v: ${globals.version}'}) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.search, size: 150, color: Colors.grey[400]),
        SizedBox(
          width: MediaQuery.of(this._context).size.width * 0.7,
          child: Text(
            msg,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _inputBuscar() {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(Icons.search, size: 25, color: const Color(0xffFFFFFF)),
          ),
          Expanded(
            flex: 9,
            child:Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(this._context).size.height * 0.06,
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(20)
              ),
              child: TextFormField(
                controller: this._bskCtr,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) => _buscarTarjetaConPalabra(),
                onEditingComplete: () => _buscarTarjetaConPalabra(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Buscador de Tarjetas',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                  ),
                  contentPadding: EdgeInsets.only(top: 5, right: 10, bottom: 0, left: 10)
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 20, height: 35,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
                ),
                onPressed: () => _buscarUltimasTarjeta(),
                padding: EdgeInsets.all(0),
                child: Icon(Icons.arrow_circle_down, size: 25,),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _cargando() {

    return Center(
      child: const SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(),
      ),
    );
  }

  ///
  Future<void> _buscarUltimasTarjeta() async {

    setState(() {
      this._showCargando = true;
    });

    this._lstPrint = await emTds.buscarUltimasTarjetas();
    await _printTarjetasInScreen();
  }

  ///
  Future<void> _buscarTarjetaConPalabra() async {

    FocusScope.of(this._context).requestFocus(new FocusNode());
     setState(() {
      this._showCargando = true;
    });

    if(this._bskCtr.text.isNotEmpty) {
      this._lstPrint = await emTds.getTarjetasConPalClas(this._bskCtr.text);
    }else{
      this._lstPrint = new List();
    }
    await _printTarjetasInScreen();
  }

  ///
  Future<void> _printTarjetasInScreen() async {

    if(this._lstPrint.isNotEmpty) {
      this._queVerInScreen =  _listaDeTarjetas();
    }else{
      this._queVerInScreen = _msgBuscarScreen(msg: 'Sin Resultados por el momento.');
    }

    setState(() {
      this._showCargando = false;
    });
  }

  ///
  Widget _listaDeTarjetas() {

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: this._lstPrint.length,
      itemBuilder: (_, int index) {
        return _cardDeTarjetas(index);
      },
    );
  }

  ///
  Widget _cardDeTarjetas(int index) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this._lstPrint[index]['td_nombreEmpresa'],
              textScaleFactor: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey
              ),
            ),
            Text(
              this._lstPrint[index]['td_giro'],
              textScaleFactor: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue
              ),
            ),
            Row(
              children: [
                Text(
                  'Usuario:',
                  textScaleFactor: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${this._lstPrint[index]['u_username']}',
                  textScaleFactor: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                  ),
                )
              ],
            ),
            Divider(color: const Color(0xff0070B3)),
            _seccDataCard(index),
            const SizedBox(width: 10),
            CardTdWidget(dataTd: this._lstPrint[index])
          ],
        ),
      ),
    );
  }

  ///
  Widget _seccDataCard(int index) {

    String diseniador = (this._lstPrint[index]['d_nombre'] == null) ? 'No asignado' : this._lstPrint[index]['d_nombre'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$diseniador',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 13
              ),
            ),
            Text(
              'Diseñador',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$ ${this._lstPrint[index]['td_costo']}',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 13
              ),
            ),
            Text(
              'Costo:',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${this._lstPrint[index]['ds_status']}',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 13
              ),
            ),
            Text(
              'Estatus:',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            )
          ],
        )
      ],
    );
  }

}