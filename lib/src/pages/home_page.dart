import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
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
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

   _scanQR() async{

    //https://fernando-herrera.com
    //

    String futureString = 'https://fernando-herrera.com';
    
    /*

    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      futureString = e.toString();
    }

    */

    if (futureString != null) {

      final scan = ScanModel( valor: futureString );

      scansBloc.agregarScan(scan);

        final scan2 = ScanModel( valor: 'geo:40.724233047051705,-74.00731459101564' );

      scansBloc.agregarScan(scan2);
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