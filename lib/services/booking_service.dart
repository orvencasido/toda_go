import 'dart:async';
import '../models/booking_model.dart';

/// Simple in-memory booking store — replaces Cloud Firestore.
class BookingService {
  static final Map<String, Booking> _bookings = {};
  static final Map<String, List<void Function(Booking?)>> _listeners = {};

  // Create a new booking
  Future<String?> createBooking(Booking booking) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final stored = Booking(
        id: id,
        passengerId: booking.passengerId,
        driverId: booking.driverId,
        pickupAddress: booking.pickupAddress,
        dropoffAddress: booking.dropoffAddress,
        fare: booking.fare,
        status: booking.status,
        createdAt: booking.createdAt,
        driverName: booking.driverName,
        driverPhone: booking.driverPhone,
        plateNumber: booking.plateNumber,
      );
      _bookings[id] = stored;
      _notifyListeners(id, stored);
      return id;
    } catch (e) {
      print('Error creating booking: $e');
      return null;
    }
  }

  // Stream a specific booking
  Stream<Booking?> streamBooking(String bookingId) async* {
    yield _bookings[bookingId];
    await for (final booking in _bookingUpdates(bookingId)) {
      yield booking;
    }
  }

  Stream<Booking?> _bookingUpdates(String bookingId) {
    late StreamController<Booking?> controller;
    void Function(Booking?)? listener;
    controller = StreamController<Booking?>(
      onListen: () {
        listener = (b) => controller.add(b);
        _listeners.putIfAbsent(bookingId, () => []);
        _listeners[bookingId]!.add(listener!);
      },
      onCancel: () {
        if (listener != null) {
          _listeners[bookingId]?.remove(listener);
        }
        controller.close();
      },
    );
    return controller.stream;
  }

  void _notifyListeners(String bookingId, Booking? booking) {
    for (final listener in List.of(_listeners[bookingId] ?? [])) {
      listener(booking);
    }
  }

  // Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final booking = _bookings[bookingId];
      if (booking == null) return false;
      final updated = Booking(
        id: booking.id,
        passengerId: booking.passengerId,
        driverId: booking.driverId,
        pickupAddress: booking.pickupAddress,
        dropoffAddress: booking.dropoffAddress,
        fare: booking.fare,
        status: BookingStatus.cancelled,
        createdAt: booking.createdAt,
        driverName: booking.driverName,
        driverPhone: booking.driverPhone,
        plateNumber: booking.plateNumber,
      );
      _bookings[bookingId] = updated;
      _notifyListeners(bookingId, updated);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get history for a passenger
  Future<List<Booking>> getPassengerHistory(String passengerId) async {
    try {
      final list = _bookings.values
          .where((b) => b.passengerId == passengerId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }
}
