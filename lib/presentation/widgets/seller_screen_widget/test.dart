import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Test({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  // SizedBox(height: 16.0),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Name'),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter your name';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 16.0),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Name'),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter your name';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 16.0),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Name'),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter your name';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 16.0),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Name'),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter your name';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 16.0),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Name'),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter your name';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, perform the desired action
                        // e.g., submit the form data to a server
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
