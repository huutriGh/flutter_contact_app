import 'package:contact_app/models/contact.dart';
import 'package:contact_app/screens/contact.dart';
import 'package:flutter/material.dart';

import '../data/sql_helper.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  SqlHelper sqlHelper = SqlHelper();
  final TextEditingController txtSearch = TextEditingController();
  List<Contact> contacts = [];

  @override
  void initState() {
    getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: txtSearch,
                decoration: InputDecoration(
                  hintText: 'Enter a name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: searchContact,
                  ),
                ),
              ),
              for (final contact in contacts)
                Dismissible(
                  key: Key(contact.id.toString()),
                  onDismissed: (direction) {
                    sqlHelper.deleteContact(contact);
                  },
                  child: Card(
                    key: ValueKey(contact.phone),
                    child: ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactScreen(contact, false),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactScreen(Contact('', ''), true),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getContact() async {
    contacts = await sqlHelper.getContact();
    setState(() {});
  }

  void searchContact() async {
    contacts = await sqlHelper.searchContact(txtSearch.text);
    setState(() {});
  }
}
