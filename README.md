# SQLiteToRealm
Utility application that helps to create and populate a Realm database from an existing SQLite database

This is meant to assist in migrating from a simple SQLite database to a Realm database, with data populated.

1) Set up the SQLite database in your project
2) Configure a Realm object using an identical (or similar) schema
3) Map the returned values from the SQLite query to the realm object
4) Extract the populated .realm file for use in your other projects

This application goes through the process of converting a SQLite database to a .Realm file. Simply run the project once, and then locate and extract the .realm database and view the contents using Realm Browser.
