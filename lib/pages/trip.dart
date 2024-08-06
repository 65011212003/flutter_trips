// import "dart:developer";
// import "package:flutter/material.dart";



// class TripPage extends StatefulWidget {

//   var idx = 0 ;

//   TripPage({super.key , required this.idx});

//   @override
//   State<TripPage> createState() => _TripPageState();
// }

// class _TripPageState extends State<TripPage> {

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     log(widget.idx.toString());
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(),
//     );
//   }
// }








import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:practice2/config/config.dart';
import 'package:practice2/model/response/get_trips.dart';

class TripPage extends StatefulWidget {
  final int idx;

  const TripPage({Key? key, required this.idx}) : super(key: key);
  
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late Future<GetTrip> futureTrip;
  late String url;

  @override
  void initState() {
    super.initState();
    log('Trip ID: ${widget.idx}');
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
        setState(() {
          futureTrip = fetchTrip();
        });
      },
    );
  }

  Future<GetTrip> fetchTrip() async {
    try {
      final response = await http.get(Uri.parse('$url/trips/${widget.idx}'));

      if (response.statusCode == 200) {
        return getTripFromJson(response.body);
      } else {
        throw Exception('Failed to load trip');
      }
    } catch (e) {
      log('Error fetching trip: $e');
      rethrow;
    }
  }

  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('รายละเอียดทริป'),
    ),
    body: FutureBuilder<GetTrip>(
      future: futureTrip,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return _buildTripDetails(context, snapshot.data!);
        } else {
          return const Center(child: Text('No trip data available'));
        }
      },
    ),
  );
}

Widget _buildTripDetails(BuildContext context, GetTrip trip) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripName(context, trip.name),
              Text(
                trip.country,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildCoverImage(trip.coverimage),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ราคา ${trip.price.toStringAsFixed(0)} บาท',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    trip.destinationZone,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(trip.detail),
              const SizedBox(height: 24),
              _buildBookButton(),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _buildCoverImage(String imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      imageUrl,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    ),
  );
}

Widget _buildTripName(BuildContext context, String name) {
  return Text(
    name,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildBookButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        // Implement booking functionality
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        'จองเลย!',
        style: TextStyle(fontSize: 18 , color: Color.fromARGB(255, 230, 224, 224)),
      ),
    ),
  );
}
}



