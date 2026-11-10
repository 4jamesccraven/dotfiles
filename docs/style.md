# Commenting Style Guide
As of [this commit](https://github.com/4jamesccraven/nixos-configs/commit/d7a8695dd3da183861bb2b899d69bb4ffcc567b6)
I have adopted a specific style for commenting my Nix code. This document is a
brief explanation for me and anyone else interested.

## File Headers
Each file begins with a multiline comment (i.e., uses `/**/` syntax) that contains the following:
- The name of the module/file/thing
- What it is (one of {`trait`, `lib`, `dotfile`, or `in` statement})
- Summary of purpose
- What it enables (if it's a trait)

### Examples
#### Trait
```nix
/*
  ====[ Feature ]====
  :: trait

  This trait enables some features.

  Enables:
    :> User Level
    Some user feature   => description

    :> System Level
    Some system feature => description

    :> Config Level
    Some config feature => description
*/
```
Notice that features are divided into user, system, and config subcategories (in
that order). If no features fit into a given subcategory, then that subcategory
is omitted.

The fat arrows (`=>`) can optionally be aligned, as show above. Whitespace is
mandatory.

#### Everything Else
```nix
/*
  ====[ Program ]====
  :: dotfile

  This module enables and configures program, which does x.
*/
```
`dotfile` is a stand in here, it could also be `lib` or an `in` statement. The
whitespace between the file type and description is optional.

`in` statements are for files that are part of a trait's implementation but is
not in the trait's `default.nix`. If the file is in a trait called `Foo`, and
the file is called `bar`, then the header is like this:
```nix
/*
  ====[ Bar ]====
  :: in trait `Foo`
  Adds Bar functionality to Foo.
*/
```

In all cases, the contents of the summary can take whatever form you like.

## Dividers
It is often necessary to break up the document so that it's easier to parse at
a glance. Dividers allow for this. There is a primary divider, used to indicate
a big section, and a secondary one to indicate a smaller section. In all cases
the title of the divider should be relatively short, especially for primary
dividers (1-4 words).

Note that secondary dividers do not need to be nested in primary dividers,
the difference is largely related to the generalness of the heading and the
overall appearance of the surrounding code. A very specific thing is likely
secondary, and a very general thing is likely primary, but if the code isn't
large or complicated enough for a primary divider, a secondary one will
suffice.

### Primary Dividers
Primary dividers are created like so:
```nix
# ---[ My Section ]---
```

### Secondary Dividers
Secondary Dividers are created like so:
```nix
# :> My Smaller Section
```

## Functions
Functions come in one of three types, only the first two of which should be
documented:
- Library code: functions you intend to reuse and share among multiple modules.
- Local functions: named functions used in only one place.
- Lambdas: anonymous functions

### Documentation for named functions
Documentation for named functions should generally look something like this:
```nix
{

  /*
    myFunc :: int -> a -> string

    This function does a thing with an int and a generic other to make a string.
    TRIPLE_TICK
    myString = myFunc 3 [ "foo" ];
    TRIPLE_TICK
  */
  myFunc = param: other: doSomethingWith param other;

}
```
The first line in the comment is a Haskell-style function declaration (see also [noogle](https://noogle.dev)).
There is then a new line (which is optional for local functions), and finally an
example (which should only be used for library code). `TRIPLE_TICK` refers to the
markdown codeblock syntax.

### On Types
The names are based loosely on noogle and `lib.types`.

Types are generally one of:
- int
- float
- string
- path
- bool
- attrs
- generic (a, b, c, etc.)
- \[type] (list of type)
- attrsOf type (attribute set with values of type)

A few specific formats of attrs have their own name:
- nixpkgs: the value typically assigned to `pkgs`
- NixOS System: a system config
- package: a nix derivation

## Why?
It started with wanting to type annotate my functions, but having random
functions with good documentation and everything else bare looked weird so I
conceived this with two goals in mind: standardise dividers (before I used
`### Header ###` and `#-> Header <-#` a lot--and differently depending on
context), and to make something that used a lot of code ligatures because my
font supports them and I think they're pretty.
