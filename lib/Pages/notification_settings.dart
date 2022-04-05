/*import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isAutoTraderChecked = false;
  bool isDevTest = false;
  bool isAllowNotificationsChecked = false;
  bool isVehicleNotificationChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: 430,
                height: 700,
                child: Column(
                  children: [
                    Text(
                      'Allow Notifications',
                      style: TextStyle(
                          color: Colors.blue[900], fontSize: 30), //TextStyle
                    ), //Text
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ), //SizedBox
                        Text(
                          'Allow notifocations for this device ',
                          style: TextStyle(fontSize: 17.0),
                        ), //Text
                        SizedBox(width: 10), //SizedBox
                        /** Checkbox Widget **/
                        Container(
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                  checkColor: Colors.orange,
                                  activeColor: Colors.green,
                                  value: isAutoTraderChecked,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isAutoTraderChecked = value;
                                    });
                                  }),
                              Text('AutoTrader')
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ), //SizedBox
                        //Text
                        SizedBox(width: 10), //SizedBox
                        /** Checkbox Widget **/
                        Container(
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                  checkColor: Colors.orange,
                                  activeColor: Colors.green,
                                  value: isAutoTraderChecked,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isAutoTraderChecked = value;
                                    });
                                  }),
                              Text('Dev Test')
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
