import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';

class BookingService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> createBooking(Booking booking) async {
    try {
      final row = await _client
          .from('bookings')
          .insert(booking.toMap()..remove('id'))
          .select('id')
          .single();
      return row['id'];
    } catch (e) {
      print('Error creating booking: $e');
      return null;
    }
  }

  Stream<Booking?> streamBooking(String bookingId) {
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('id', bookingId)
        .map((rows) => rows.isEmpty ? null : Booking.fromMap(rows.first, rows.first['id']));
  }

  Future<bool> updateTripStatus(String bookingId, BookingStatus status) async {
    try {
      await _client
          .from('bookings')
          .update({
            'status': status.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
      return true;
    } catch (e) {
      print('Error updating booking: $e');
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    return updateTripStatus(bookingId, BookingStatus.cancelled);
  }

  Future<List<Booking>> getPassengerHistory(String passengerId) async {
    try {
      final rows = await _client
          .from('bookings')
          .select()
          .eq('passenger_id', passengerId)
          .inFilter('status', ['completed', 'cancelled'])
          .order('created_at', ascending: false);
      return rows.map<Booking>((row) => Booking.fromMap(row, row['id'])).toList();
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }
}
