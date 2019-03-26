import 'dart:async';
import 'dart:collection';

import 'package:agilie_flutter_payments/data/cinema_repository.dart';
import 'package:agilie_flutter_payments/data/ds/local/local_cinema_ds.dart';
import 'package:agilie_flutter_payments/model/models.dart';
import 'package:agilie_flutter_payments/utils.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

import 'screens/movies_list_screen.dart';
import 'utils.dart';
import 'vm/home_page_vm.dart';

void main() => runApp(MyApp());

Size cinemasSize = Size(0, 0);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId("YOUR_API_KEY");
  }

  MyApp() {
    _initSquarePayment();
    FirebaseAdMob.instance
        .initialize(appId: FirebaseAdMob.testAppId);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
      home: HomePage(),
      );
  }
}

class HomePage extends StatefulWidget {
  @override
  State createState() {
    return DefaultPageState();
  }
}

final String inOutButtonId = "inOutButtonId";
final String cinemasListButtonId = "cinemasListButtonId";

class DefaultPageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  GoogleMapController _controller;
  Animation<double> animation;
  AnimationController controller;

  HomePageVm vm;

  StreamController<List<Cinema>> cinemasStreamController =
  StreamController.broadcast(sync: true);

  MobileAd myBanner;

  @override
  void initState() {
    myBanner ??= getAds(AdType.BANNER)
      ..load()
      ..show();

    vm = new HomePageVm(
        CinemaRepository(
          LocalCinemaDs(),
          ),
        cinemasStreamController);
    _initAnimation();
    super.initState();
  }

  _initAnimation() {
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: Stack(
        children: <Widget>[
          _getMap(),
          Transform(
            transform: Matrix4.translationValues(
                animation.value * cinemasSize.width, 0.0, 0.0),
            child: Container(
              child: CustomMultiChildLayout(
                delegate: CinemasListMultichildLayoutDelegate(),
                children: <Widget>[
                  LayoutId(
                    id: cinemasListButtonId,
                    child: _getCinemasScroll(size),
                  ),
                  LayoutId(
                    id: inOutButtonId,
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                        ),
                        child: Transform.rotate(
                          angle: 3.14159 * animation.value,
                          child: IconButton(
                              icon: SvgPicture.asset(getAssetImagePath(
                                  "arrow-point-to-right.svg")),
                              onPressed: () {
                                if (animation.value == 0.0)
                                  controller.forward();
                                else if (animation.value == 1.0) {
                                  controller.reverse();
                                }
                              }),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMap() {
    return StreamBuilder<List<Cinema>>(
      stream: vm.cinemaStream,
      builder: (BuildContext context, cinemas) {
        return GoogleMap(
          onMapCreated: (contrl) {
            _onMapCreated(contrl, cinemas.data, cinemas.data[0].city);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(0.0, 0.0),
          ),
        );
      },
    );
  }

  Widget _getCinemasScroll(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.9),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      width: size.width / 5,
      height: size.height / 3,
      child: SafeArea(
        child: StreamBuilder<List<Cinema>>(
          stream: vm.cinemaStream,
          builder: (context, cinemasData) {
            if (cinemasData.hasData) {
              final cinemas = cinemasData.data;
              return ScrollConfiguration(
                behavior: NoOverscrollBehavior(),
                child: ListView.builder(
                    itemCount: cinemas.length,
                    itemBuilder: (BuildContext context, int position) {
                      final cinema = cinemas[position];
                      return Container(
                        child: ListTile(
                          onTap: () {
                            _controller.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    cinema.coordinates, 16));
                          },
                          title: Image.network(cinema.logoUrl),
                          subtitle: Center(
                            child: Text(
                              cinema.name,
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                  decorationStyle: TextDecorationStyle.dotted),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            } else
              return Text("");
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    cinemasStreamController.close();
    cinemasSize = null;
    myBanner.dispose();
    myBanner = null;
    super.dispose();
  }

  final _markers = new HashMap<int, Marker>();

  _onMapCreated(
      GoogleMapController controller, List<Cinema> cinemas, City city) {
    _controller = controller;
    _controller.onMarkerTapped.add((marker) {
      myBanner.dispose();
      myBanner = null;

      getAds(AdType.INTERSTITIAL)
        ..load()
        ..show();

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) {
            return MoviesListPage();
          },
          ),
        ).then((v) {
        myBanner ??= getAds(AdType.BANNER)
          ..load()
          ..show();
      });
    });

    _controller.animateCamera(CameraUpdate.newLatLngZoom(city.center, 12));
    cinemas.forEach((cinema) {
      _controller
          .addMarker(
        MarkerOptions(
          position: cinema.coordinates,
          infoWindowText: InfoWindowText(cinema.name, null),
        ),
      )
          .then((marker) {
        _markers.putIfAbsent(cinema.id, () {
          return marker;
        });
      });
    });
  }
}

class CinemasListMultichildLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final Size cinemasListSize =
        layoutChild(cinemasListButtonId, BoxConstraints.loose(size));
    final Size inOutButtonSize = layoutChild(
        inOutButtonId, BoxConstraints.tightFor(width: 30, height: 30));

    cinemasSize = cinemasListSize;

    positionChild(
      cinemasListButtonId,
      Offset(size.width - cinemasListSize.width - 5, 5),
    );
    positionChild(
      inOutButtonId,
      Offset(size.width - cinemasListSize.width - inOutButtonSize.width / 2 - 5,
          cinemasListSize.height - cinemasListSize.height / 6),
    );
  }

  @override
  bool shouldRelayout(CinemasListMultichildLayoutDelegate oldDelegate) => true;
}

class NoOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
