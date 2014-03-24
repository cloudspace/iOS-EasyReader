# Inflections

Inflections is a port of several of the ActiveSupport Inflector methods into Objective C. This was inspired by the wonderful inflection.js by Ryan Schuft (<http://code.google.com/p/inflection-js/>). The framework has all the support for camelization pluralization and some of the other nice features. It also depends on RegexKitLite for Regex support.

## Usage

The simplest way to use the project is to add the `NSString+Inflections.h` and `NSString+Inflections.m` to your project. You will also need to have RegexKitLite in your project.

To install RegexKitLite check their site: <http://regexkit.sourceforge.net/RegexKitLite/#AddingRegexKitLitetoyourProject>

## Supported Methods

`- (NSString *)pluralize;`

Returns the plural form of the word in the string.

`- (NSString *)singularize;`

The reverse of +pluralize+, returns the singular form of a word in a string.

`- (NSString *)humanize;`

Capitalizes the first word and turns underscores into spaces and strips a trailing "_id", if any. Like +titleize+, this is meant for creating pretty output.
 
`- (NSString *)titleize;`

Capitalizes all words that are not part of the nonTitlecasedWords.

`- (NSString *)tableize;`

Create the name of a table like Rails does for models to table names. This method uses the +pluralize+ method on the last word in the string.

`- (NSString *)classify;`

Create a class name from a plural table name like Rails does for table names to models.

`- (NSString *)camelize;`

Converts an underscored separated string into a CamelCasedString.

`- (NSString *)camelizeWithLowerFirstLetter;`

Converts an underscored separated string into a camelCasedString with the first letter lower case.

`- (NSString *)underscore;`

Makes an underscored, lowercase form from the expression in the string.

`- (NSString *)dasherize;`

Replaces underscores with dashes in the string.

`- (NSString *)demodulize;`

Removes the module part from the expression in the string.

`- (NSString *)foreignKey;`

Creates a foreign key name from a class name.

`- (NSString *)foreignKeyWithoutIdUnderscore;`

Creates a foreign key name from a class name without the underscore  separating the id part.
  
`- (NSString *)ordinalize;`

Turns a number into an ordinal string used to denote the position in an ordered sequence such as 1st, 2nd, 3rd, 4th.

`- (NSString *)capitalize;`

Capitalizes the first letter and makes everything else lower case.

## Issues

Currently some of the singularization tests are passing. The testing suite was ported over from Rails 3.0 and most of it's working. There are still a couple odd cases though.

## Project Info

Copyright (c) 2010 Adam Elliot, released under the MIT license.


