# Midas

![Continuous](https://github.com/moosetechnology/Midas/workflows/Continuous/badge.svg?branch=development) [![Moose version](https://img.shields.io/badge/Moose-8-%23aac9ff.svg)](https://github.com/moosetechnology/Moose)

New Tools for Moose

## Installation

### From the Pharo Launcher

1. **New** (image)
2. **Official distributions**
3. **Moose Suite 9.0 (development)**  
4. (optionally change **Image name:**)
5. **Create image**

![Screen capture of Pharo Launcher to make Midas image](https://user-images.githubusercontent.com/7606540/119543402-9e93e480-bd5e-11eb-8fd8-bfa676353741.png)


### From a Pharo Image

```smalltalk
Metacello new
  baseline: 'Midas';
  repository: 'github://moosetechnology/Midas:development/src';
  load.
```
