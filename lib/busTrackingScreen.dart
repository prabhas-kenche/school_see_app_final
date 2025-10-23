import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({Key? key}) : super(key: key);

  @override
  _BusTrackingScreenState createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  MapController mapController = MapController();
  String selectedLayer = "street";

  List busStops = [
    {"name": "School", "location": LatLng(17.385044, 78.486671), "time": "08:00"},
    {"name": "Stop", "location": LatLng(17.395044, 78.496671), "time": "08:10"},
    {"name": "Stop", "location": LatLng(17.405044, 78.506671), "time": "08:20"},
    {"name": "Stop", "location": LatLng(17.415044, 78.516671), "time": "08:30"},
    {"name": "Stop", "location": LatLng(17.425044, 78.526671), "time": "08:40"},
  ];

  void changeMapLayer(String layer) {
    setState(() {
      selectedLayer = layer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Section
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(17.385044, 78.486671), // Example location
              initialZoom: 13.0,
            ),
            children: [
              if (selectedLayer == "street")
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                )
              else if (selectedLayer == "satellite")
                TileLayer(
                  urlTemplate:
                      "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                ),
              MarkerLayer(
                markers: busStops.map((stop) => Marker(
                      point: stop["location"],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_bus_rounded,
                            color: const Color.fromARGB(255, 247, 135, 6),
                            size: 40,
                          ),
                          Text(
                            "${stop['name']} - ${stop['time']}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )).toList(),
              ),
            ],
          ),
          // Top Bar with Bus No, Call and Message Icons
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            height: 70,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 16, 56, 59).withOpacity(0.5), // Yellow background
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_bus_filled,
                        color: Color.fromARGB(255, 255, 181, 32), // Blue icon
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Bus No. 99003 2J",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 233, 224, 224), // Dark text
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Dummy phone call
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Call Driver"),
                              content: const Text("Calling +91 9876543210..."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 96, 227, 31), // Green icon
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Dummy message functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Messaging feature coming soon!")),
                          );
                        },
                        child: const Icon(
                          Icons.message,
                          color: Color.fromARGB(255, 235, 226, 226), // Dark icon
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Layer Selection Icon
          Positioned(
            top: MediaQuery.of(context).size.height / 5 - 40,
            right: 16,
            child: PopupMenuButton(
              onSelected: (String newValue) {
                changeMapLayer(newValue);
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'satellite',
                  child: Row(
                    children: [
                      Icon(Icons.satellite_outlined, color: const Color.fromARGB(255, 23, 220, 36)),
                      const SizedBox(width: 8),
                      const Text('Satellite'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'street',
                  child: Row(
                    children: [
                      Icon(Icons.layers_outlined, color: const Color.fromARGB(255, 23, 214, 183)),
                      const SizedBox(width: 8),
                      const Text('Street'),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 156, 211, 236), // Sky blue color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  selectedLayer == "street" ? Icons.layers_outlined : Icons.satellite_outlined,
                  color: const Color.fromARGB(255, 17, 18, 18),
                  size: 24, // Increased from 20 to 24
                ),
              ),
            ),
          ),
          // Bottom Dark Orange Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 166, 164, 164).withOpacity(0.5), // Dark orange card color
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "25:11",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 33, 30, 30),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Drop Count
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "12",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 33, 30, 30),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Drop",
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 33, 30, 30),
                            ),
                          ),
                        ],
                      ),
                      // Total Time
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "28:25",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 33, 30, 30),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Total Time",
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 33, 30, 30),
                            ),
                          ),
                        ],
                      ),
                      // Distance
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "09 KM",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 33, 30, 30),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Distance",
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 33, 30, 30),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}