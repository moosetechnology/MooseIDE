"
I am a generator of palettes. 
Note: The number of colors to generate must be specified, the default value is 20

To generate a palette use the common method #generate:


"
Class {
	#name : #ClpPaletteGenerator,
	#superclass : #Object,
	#instVars : [
		'numberOfColors',
		'generatedPalette'
	],
	#category : #'MooseIDE-ColorPalette-GeneratePalettes'
}

{ #category : #translating }
ClpPaletteGenerator class >> generate: aNumberOfColors [

	^ self new generate: aNumberOfColors 
]

{ #category : #testing }
ClpPaletteGenerator class >> isAbstract [
	
	^ self == ClpPaletteGenerator 
]

{ #category : #generating }
ClpPaletteGenerator >> generate [

	"generate 20 colors by default"

	^ self generate: self numberOfColors
]

{ #category : #translating }
ClpPaletteGenerator >> generate: aNumberOfColors [
	
	"return an object of palette with the specified number of colors"
	
	self numberOfColors: aNumberOfColors .
	^ generatedPalette class withAll: self makeColors .
	
	
]

{ #category : #accessing }
ClpPaletteGenerator >> generatedPalette [

	^ generatedPalette
]

{ #category : #initialization }
ClpPaletteGenerator >> initialize [ 
	
	super initialize .
	numberOfColors := 20.
	generatedPalette := GeneratedPalette new
]

{ #category : #accessing }
ClpPaletteGenerator >> makeColors [

	^ self subclassResponsibility 
]

{ #category : #accessing }
ClpPaletteGenerator >> numberOfColors [

	^ numberOfColors
]

{ #category : #accessing }
ClpPaletteGenerator >> numberOfColors: anInteger [

	numberOfColors := anInteger
]

{ #category : #'gt-inspection' }
ClpPaletteGenerator >> paletteInspectorExtension [

	<inspectorPresentationOrder: 1 title: 'Palette'>
	^ self generate paletteInspectorExtension
]
