# Rails Model Schema

A package to show your Rails models schema when you see a file on Atom. It's that easy.

```
TODO: Make an example app so we can take a snapshot.
```

## Current Drawbacks
- It doesn't watch the `schema.rb` file changes so you have to toggle the package after a migration.
- It works by reading the class name of a ruby file, so if the model doesn't have the name of the table (for example, when using simple model inheritance or setting the table name with `self.table_name=`), it won't work.
