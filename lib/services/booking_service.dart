import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new booking
  Future<String?> createBooking(Booking booking) async {
    try {
      DocumentReference docRef = await _db.collection('bookings').add(booking.toMap());
      return docRef.id;
    } catch (e) {
      print("Error creating booking: $e");
      return null;
    }
  }

  // Stream a specific booking
  Stream<Booking?> streamBooking(String bookingId) {
    return _db.collection('bookings').doc(bookingId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  // Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.cancelled.name,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get history for a passenger
  Future<List<Booking>> getPassengerHistory(String passengerId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('bookings')
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error getting history: $e");
      return [];
    }
  }
}
