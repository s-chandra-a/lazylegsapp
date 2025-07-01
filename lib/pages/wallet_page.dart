import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF1D1D1D);
    const Color cardColor = Colors.red;
    const Color transactionColor = Color(0xFF2A2A2A);
    const Color accentRed = Color(0xFFFF5C5C);
    const Color textWhite = Colors.white;
    const Color textGrey = Color(0xFFC0C0C0);

    final transactions = [
      {'title': 'Order Payout', 'amount': '+₹20', 'date': 'Jul 1, 2025'},
      {'title': 'Order Posted', 'amount': '-₹5', 'date': 'Jun 30, 2025'},
      {'title': 'Order Payout', 'amount': '+₹20', 'date': 'Jun 28, 2025'},
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Wallet', style: TextStyle(color: textWhite)),
        iconTheme: const IconThemeData(color: textWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [cardColor, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hey, ', style: TextStyle(color: textGrey)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'James Cam',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textWhite),
                      ),
                      const Spacer(),
                      Icon(Icons.edit, color: textGrey),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('LazyLegs Credits:', style: TextStyle(color: textGrey)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '© 500',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textWhite),
                      ),
                      Icon(Icons.credit_card_sharp, color: textGrey),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text('Latest Transactions', style: TextStyle(color: textWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Dummy Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: transactionColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx['title']!, style: const TextStyle(color: textWhite, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(tx['date']!, style: const TextStyle(color: textGrey, fontSize: 12)),
                          ],
                        ),
                        Text(
                          tx['amount']!,
                          style: TextStyle(
                            color: tx['amount']!.startsWith('+') ? Colors.greenAccent : accentRed,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
