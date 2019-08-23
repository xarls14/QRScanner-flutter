import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
//import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;
import 'direcciones_page.dart';
import 'mapas_page.dart';

class HomePage extends StatefulWidget {
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScansTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

   _scanQR( BuildContext context) async{

    //https://fernando-herrera.com
    //

    String futureString;
    
    

    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      futureString = e.toString();
    }

    

    if (futureString != null) {

      final scan = ScanModel( valor: futureString );

      scansBloc.agregarScan(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(scan, context);
        });
      }else{
        utils.abrirScan(scan, context);
      }
    }



  }

  Widget _callPage(int paginaActual){

    switch( paginaActual ){
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }

  }

  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,//que elemento esta activo
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Direcciones'),
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),
        ),
      ],
    );
  }
}