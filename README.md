# Midas

New Tools for Moose

## Installation

```smalltalk
Metacello new
    baseline: 'NewTools';
    repository: 'github://pharo-spec/NewTools';
    load.

Metacello new
        githubUser: 'pharo-spec' project: 'Spec' commitish: 'master' path: 'src';
        baseline: 'Spec2';
        onConflict: [ :e | e useIncoming ];
        onUpgrade: [ :e | e useIncoming ];
        ignoreImage;
        load.

Metacello new
  baseline: 'Midas';
  repository: 'github://moosetechnology/Midas:master/src';
  load.
```
