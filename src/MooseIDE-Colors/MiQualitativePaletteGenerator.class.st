"
I am the qualitative palette, i can generate a qualitative palette from a starting color. 

**Example generate a palette of 10 colors:**
```Smalltalk
MiQualitativePaletteGenerator generate: 10
```
"
Class {
	#name : #MiQualitativePaletteGenerator,
	#superclass : #MiPaletteGenerator,
	#instVars : [
		'startingColor'
	],
	#category : #'MooseIDE-Colors-PaletteGenerators'
}

{ #category : #examples }
MiQualitativePaletteGenerator class >> example [

	(self generate: 10) inspect
]

{ #category : #initialization }
MiQualitativePaletteGenerator >> initialize [ 

	super initialize .
	startingColor := Color blue
]

{ #category : #accessing }
MiQualitativePaletteGenerator >> makeColors [
	
	^ self qualitative 
]

{ #category : #compute }
MiQualitativePaletteGenerator >> qualitative [
	
	"returns a collection of distinct colors starting from a startingColor"
	
	| colors currentColor hue chroma lightness delta step |
	colors := OrderedCollection new.
	currentColor := startingColor.
	hue := currentColor hue.
	chroma := currentColor chroma.
	lightness := currentColor lightness .
	delta := 360.0  - hue.
	step := delta / numberOfColors  .
	colors add: startingColor .
	2 to: numberOfColors do: [ :i | 
		hue := (hue + step).
		colors add: (Color h: hue s: chroma l: lightness)].
	^ colors
]

{ #category : #accessing }
MiQualitativePaletteGenerator >> startingColor: aColor [

	startingColor := aColor
]
