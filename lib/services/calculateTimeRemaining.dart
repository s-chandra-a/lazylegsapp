int calculateMinutesLeft(DateTime expiry) {
  final now = DateTime.now();
  final difference = expiry.difference(now).inMinutes;
  return difference > 0 ? difference : 0; // return 0 if already expired
}

