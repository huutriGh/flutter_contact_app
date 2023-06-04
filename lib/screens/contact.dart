import 'package:contact_app/models/contact.dart';
import 'package:contact_app/screens/contact_list.dart';
import 'package:flutter/material.dart';

import '../data/sql_helper.dart';

class ContactScreen extends StatefulWidget {
  final Contact contact;
  final bool isNew;

  const ContactScreen(this.contact, this.isNew, {super.key});

  @override
  State createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  int settingColor = 0xff1976D2;
  double fontSize = 16;

  SqlHelper helper = SqlHelper();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();

  @override
  void initState() {
    if (!widget.isNew) {
      txtName.text = widget.contact.name;
      txtPhone.text = widget.contact.phone;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isNew
            ? const Text('Insert Contact')
            : const Text('Edit Contact'),
        backgroundColor: Color(settingColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: txtName,
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: "Name"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: txtPhone,
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Phone'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(settingColor),
        onPressed: () {
          //save Note
          widget.contact.name = txtName.text;
          widget.contact.phone = txtPhone.text;

          if (widget.isNew) {
            helper.insertContact(widget.contact);
          } else {
            helper.updateContact(widget.contact);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ContactList()),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
