# Midas

Master: [![Build Pass](https://api.travis-ci.com/moosetechnology/Midas.svg?branch=master)](https://travis-ci.com/github/moosetechnology/Midas)
[![Moose version](https://img.shields.io/badge/Moose-8-%23aac9ff.svg)](https://github.com/moosetechnology/Moose)

New Tools for Moose

## Installation

### From the Pharo Launcher

![downloadMidas](https://user-images.githubusercontent.com/6225039/83118958-5bf9e680-a0cf-11ea-8a17-66d101995d27.gif)

### From a Pharo Image

```smalltalk
Metacello new
  baseline: 'Midas';
  repository: 'github://moosetechnology/Midas:master/src';
  onConflict: [ :e | e useIncoming ];
  onUpgrade: [ :e | e useIncoming ];
  load.
```
