class PaymentService {
  Future<bool> pay({required double amount, required String currency}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true; // placeholder success
  }
}


