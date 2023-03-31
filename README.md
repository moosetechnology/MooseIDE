# MooseIDE

[![Coverage Status](https://coveralls.io/repos/github/moosetechnology/MooseIDE/badge.svg)](https://coveralls.io/github/moosetechnology/MooseIDE) [![development](https://github.com/moosetechnology/MooseIDE/actions/workflows/daily.yml/badge.svg)](https://github.com/moosetechnology/MooseIDE/actions/workflows/daily.yml) [![Moose version](https://img.shields.io/badge/Moose-8-%23aac9ff.svg)](https://github.com/moosetechnology/Moose)

New Tools for Moose

## Installation

### From the Pharo Launcher

1. **New** (image)
2. **Official distributions**
3. **Moose Suite 9.0 (development)**  
4. (optionally change **Image name:**)
5. **Create image**

![Screen capture of Pharo Launcher to make MooseIDE image](https://user-images.githubusercontent.com/33934979/124268297-9e46f000-db39-11eb-8626-ab578dd16ffb.png)

### From a Pharo 10 Image

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
