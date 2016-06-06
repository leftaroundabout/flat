Haskell implementation of [Flat](http://quid2.org), a minimalist binary data format ([specs](http://quid2.org/docs/Flat.pdf)).

 ### Installation

Install as part of the [quid2](https://github.com/tittoassini/quid2) project.

 ### Brief Tutorial for Haskellers

Flat is a binary data format, similar to `binary` or `cereal`.

To (de)serialise a data type it needs to be an instance of the `Flat` class.

Instances for a few common data types (Bool,Tuples, Lists, String, Text ..) are already defined (in `Data.Flat.Instances):

There is `Generics` based support to automatically derive instances of additional types.

So, let's enable `Generics`:

> {-# LANGUAGE DeriveGeneric #-}
> {-# LANGUAGE NoMonomorphismRestriction #-}

Import the Flat library:

> import Data.Flat

Define a couple of custom data types, deriving `Generic`:

> data Direction = North | South | Center | East | West deriving (Show,Generic)

> data List a = Cons a (List a) | Nil deriving (Show,Generic)

Automatically derive the `Flat` instances:

> instance Flat Direction
> instance Flat a => Flat (List a)

A little utility function: `bits` encodes the value, `prettyShow` displays it nicely:

> p :: Flat a => a -> String
> p = prettyShow . bits

Let's see some encodings:

> p1 = p Center

> p2 = p (Nil::List Direction)

> p3 = p $ Cons North (Cons South Nil)

These encodings shows a pecularity of Flat, it uses an optimal bit-encoding rather than the usual byte-oriented one.

For the serialisation to work with byte-oriented devices, we need to add some final padding, this is done automatically by the function `flat`:

> f :: Flat a => a -> String
> f = prettyShow . flat

> f1 = f Center

> f2 = f (Nil::List Direction)

> f3 = f $ Cons North (Cons South Nil)

The padding is a sequence of 0s terminated by a 1, till the next byte boundary.

For decoding, use `unflat`:

> d1 = unflat (flat $ Cons North (Cons South Nil)) :: Decoded (List Direction)

-----
See the [source code](https://github.com/tittoassini/flat/blob/master/src/README.lhs) of this file. 