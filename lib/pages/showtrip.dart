import 'dart:developer' ;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:practice2/config/config.dart';
import 'package:practice2/model/response/get_trips.dart';

class ShowtripPage extends StatefulWidget {
  const ShowtripPage({Key? key}) : super(key: key);

  @override
  State<ShowtripPage> createState() => _ShowtripPageState();
}

class _ShowtripPageState extends State<ShowtripPage> {
  late Future<List<GetTrip>> futureTrips;
  String selectedRegion = 'All';
  late String url;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
        setState(() {
          futureTrips = fetchTrips();
        });
      },
    );
  }

  Future<List<GetTrip>> fetchTrips() async {
    try {
      final response = await http.get(Uri.parse('$url/trips'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((trip) => GetTrip.fromJson(trip)).toList();
      } else {
        throw Exception('Failed to load trips');
      }
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการทริป"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
            child: Text(
              'ปลายทาง',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRegionButton('All', 'ทั้งหมด'),
                _buildRegionButton('Asia', 'เอเชีย'),
                _buildRegionButton('Europe', 'ยุโรป'),
                _buildRegionButton('ASEAN', 'อาเซียน'),
                _buildRegionButton('America', 'อเมริกา'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<GetTrip>>(
              future: futureTrips,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<GetTrip> filteredTrips = snapshot.data!.where((trip) {
                    return selectedRegion == 'All' || trip.destinationZone == selectedRegion;
                  }).toList();
                  
                  return ListView.builder(
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      return _buildTripCard(filteredTrips[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('No trips available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionButton(String region, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(
        onPressed: () {
          setState(() {
            selectedRegion = region;
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            selectedRegion == region ? Color.fromARGB(255, 147, 92, 149) : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTripCard(GetTrip trip) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
            child: Text(
              trip.name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildImage(trip.coverimage),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'ประเทศ${trip.country}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'ระยะเวลา ${trip.duration} วัน',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'ราคา ${trip.price.toStringAsFixed(2)} บาท',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: FilledButton(
                          onPressed: () {
                            // Implement more details functionality
                          },
                          child: const Text(
                            'รายละเอียดเพิ่มเติม',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.asset(
        imageUrl,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } else {
      return const Icon(Icons.image_not_supported);
    }
  }
}