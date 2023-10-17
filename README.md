# AbstractMem
A library for Delphi/FreePascal to use as an automated storage simple to use, both memory and file mangament

Work with **large amount** of data without thinking in load/save to disk, work always with data (**up to tons of bytes**) and library will load/save/cache it for you.

Also, data can be indexed thanks to BTree automatic storage.

This library was developed by Albert Molina for use at PascalCoin project (see https://github.com/PascalCoinDev/PascalCoin)

At PascalCoin we needed a native and compileable source code for storage data of the PascalCoin blockchain

Instead of use DLL's or third party software (like SQLite or similar) Albert developed a native storage-like library usefull that contains also some improvements in order to use **large amounts** of data without thinking in store on memory or save to disk. This process is automated. This is what makes "AbstractMem" a usefull library to use in Pascal language.

## Changelog
See https://github.com/PascalCoinDev/AbstractMem/blob/main/src/ConfigAbstractMem.inc 

## Instructions
(Instructions subject to a developer knowing basic Delphi/FreePascal compiler and development)

### Folders
- `src` folder contains all units needed for usage
- `tests` contains tests units
- `utils` contains some examples

## How to use
If interested, see how PascalCoin project used this library.
Also, see `tests` and `folders` source code to understand

Start creating a `TAbstractStorage` struct and add data working on it. (See `tests\src\UAbstractStorage.Tests.pas` source code for a basic example

At this moment this library is only used for myself on PascalCoin project, so documentation is not part of my time. 

## Info
```
  This file is part of AbstractMem framework

  Copyright (C) 2020-2021 Albert Molina - bpascalblockchain@gmail.com

  https://github.com/PascalCoinDev/

  *** BEGIN LICENSE BLOCK *****

  The contents of this files are subject to the Mozilla Public License Version
  2.0 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License.

  The Initial Developer of the Original Code is Albert Molina.

  See ConfigAbstractMem.inc file for more info

  ***** END LICENSE BLOCK *****
```
