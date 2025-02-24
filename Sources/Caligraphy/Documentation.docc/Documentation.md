# ``Caligraphy``

A declarative API for building strings in Swift

## Overview

Caligraphy is a declarative API used to declaratively build and template strings in Swift, for application such as code generation.
The API consists individual string components called "strokes" (represented the ``Stroke`` protocol), instances of which are joined together declarativley using the ``Caligraphy`` result builder.

## Topics

### Core API

- ``Stroke``
- ``Caligraphy``

### Strokes & Operators

- ``AnyStroke``
- ``Indented``
- ``Line``
- ``Lines``
- ``NewLine``
- ``StringStroke``
- ``Space``
- ``Strokes``
- ``Tab``

### Files & Directories

- ``File``
- ``Directory``
- ``DirectoryContentBuilder``
