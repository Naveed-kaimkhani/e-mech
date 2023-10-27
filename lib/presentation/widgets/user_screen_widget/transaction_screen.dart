import 'package:e_mech/data/models/transaction.dart';
import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';

import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';
import '../../seller_screens/shimmer_screen.dart';
import '../seller_screen_widget/no_data_found_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Styling.primaryColor,
        leading: BackButton(),
        title: Text('Invoices'),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: FirebaseUserRepository.getTransactionByReceiverId(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerScreen();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const NoDataFoundScreen(
              text: "No History",
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  TransactionModel model = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Color.fromARGB(255, 245, 246, 249),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${model.date}\n ${model.time}'),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: model.services!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Text(model.services![index]
                                          .toString()
                                          .split(':')[0]),
                                      trailing: Text(model.services![index]
                                          .toString()
                                          .split(":")[1]),
                                    );
                                  }),
                            ],
                          )),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
