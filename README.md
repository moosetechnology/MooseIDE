# MooseIDE

[![Coverage Status](https://coveralls.io/repos/github/moosetechnology/MooseIDE/badge.svg)](https://coveralls.io/github/moosetechnology/MooseIDE) 
[![Run tests](https://github.com/moosetechnology/MooseIDE/actions/workflows/tests.yml/badge.svg?branch=development)](https://github.com/moosetechnology/MooseIDE/actions/workflows/tests.yml)

New Tools for Moose

## Installation

### From the Pharo Launcher

1. **New** (image)
2. **Official distributions**
3. Choose appropriate Moose image (here the latest **Stable version**)
4. (optionally change **Image name:**)
5. **Create image**

![Screen capture of Pharo Launcher to make MooseIDE image](<img width="964" height="572" src="https://github.com/user-attachments/assets/2fafecbc-df09-4ab2-921c-0f1fe12e511d"/>)

### From latest Pharo Image

```smalltalk
Metacello new
  baseline: 'MooseIDE';
  repository: 'github://moosetechnology/MooseIDE:development/src';
  load
```

### From a Pharo 9 Image

```smalltalk
Metacello new
  baseline: 'MooseIDE';
  repository: 'github://moosetechnology/MooseIDE:v2.x.x/src';
  load
```
