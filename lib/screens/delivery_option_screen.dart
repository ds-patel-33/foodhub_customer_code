import 'package:flutter/material.dart';
import 'package:foodhub/variables/enums.dart';
import 'package:foodhub/variables/images.dart';
import 'package:foodhub/widgets/custom_appbar.dart';

class DeliveryOptionScreen extends StatefulWidget {
  DeliveryType deliveryType;
  PaymentMethod paymentMethod;
  int holeNumber;

  DeliveryOptionScreen(
      {required this.deliveryType,
      required this.paymentMethod,
      required this.holeNumber,
      Key? key})
      : super(key: key);

  @override
  _DeliveryOptionScreenState createState() => _DeliveryOptionScreenState();
}

class _DeliveryOptionScreenState extends State<DeliveryOptionScreen> {
  TextEditingController holeController = TextEditingController();
  DeliveryType? deliveryType;
  PaymentMethod? paymentMethod;

  @override
  void initState() {
    deliveryType = widget.deliveryType;
    paymentMethod = widget.paymentMethod;
    holeController.text = widget.holeNumber.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: customAppbar(
            context: context,
            title: Text(
              "Delivery & Payment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      [paymentMethod, deliveryType, holeController.text]);
                },
                icon: Icon(Icons.arrow_back_ios)),
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              paymentMethodCard(),
              SizedBox(
                height: 20,
              ),
              deliveryOptions(),
              SizedBox(
                height: 20,
              ),
              deliveryType == DeliveryType.pickup ? Container() : currentHole()
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentMethodCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      shadowColor: Colors.grey[200],
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
            ),
            borderRadius: BorderRadius.circular(14)),
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  paymentMethod = PaymentMethod.payLater;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Pay later",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    Spacer(),
                    paymentMethod == PaymentMethod.payLater
                        ? Icon(
                            Icons.done,
                            color: Theme.of(context).primaryColor,
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  paymentMethod = PaymentMethod.payWithCard;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.credit_card_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Pay with card",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    Spacer(),
                    paymentMethod == PaymentMethod.payWithCard
                        ? Icon(
                            Icons.done,
                            color: Theme.of(context).primaryColor,
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "+ Add Card",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget deliveryOptions() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery options",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                  child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      deliveryType = DeliveryType.pickup;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: deliveryType == DeliveryType.pickup
                                ? Theme.of(context).primaryColor
                                : Colors.black12),
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Image.asset(
                          Images.PICKUP,
                          height: 60,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "I'll pick it up\nmy self",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              )),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      deliveryType = DeliveryType.delivery;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: deliveryType == DeliveryType.delivery
                                ? Theme.of(context).primaryColor
                                : Colors.black12),
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Image.asset(
                          Images.CAR2,
                          height: 60,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "On course\ndelivery",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget currentHole() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Hole ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Image.asset(
                Images.GOLF2,
                width: 26,
                height: 26,
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  width: 50,
                  height: 26,
                  child: TextFormField(
                      controller: holeController,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding:
                            EdgeInsets.only(bottom: 5, top: 5, left: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
