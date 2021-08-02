"
I am the qualitative palette, i can generate a qualitative palette from a starting color. 

**Example generate a palette of 10 colors:**
```Smalltalk
p := ClpQualitativePaletteGenerator generate: 10.
p asCollection 
```
"
Class {
	#name : #ClpQualitativePaletteGenerator,
	#superclass : #ClpPaletteGenerator,
	#instVars : [
		'startingColor'
	],
	#category : #'MooseIDE-ColorPalette-GeneratePalettes'
}

{ #category : #initialization }
ClpQualitativePaletteGenerator >> initialize [ 

	super initialize .
	startingColor := Color blue
]

{ #category : #accessing }
ClpQualitativePaletteGenerator >> makeColors [
	
	^ self qualitative 
]

{ #category : #compute }
ClpQualitativePaletteGenerator >> qualitative [
	
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
ClpQualitativePaletteGenerator >> startingColor: aColor [

	startingColor := aColor
]
