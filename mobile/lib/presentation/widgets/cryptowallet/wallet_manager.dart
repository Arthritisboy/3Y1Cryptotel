class WalletManager {
  static final WalletManager _instance = WalletManager._internal();

  factory WalletManager() {
    return _instance;
  }

  WalletManager._internal();

  String walletAddress = 'No Address';
  String balance = '₱ 0';
  bool isConnected = false;

  void reset() {
    walletAddress = 'No Address';
    balance = '₱ 0';
    isConnected = false; // Change if you want to maintain connected state
  }
}
