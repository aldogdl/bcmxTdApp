
import 'package:flutter/material.dart';

class DataShared  extends ChangeNotifier {

  String _tokenServer;
  get tokenServer => this._tokenServer;
  void setTokenServer(String tokenServer) => this._tokenServer = tokenServer;

  String _lastPage;
  get lastPage => this._lastPage;
  void setLastPage(String lastPage) => this._lastPage = lastPage;
}