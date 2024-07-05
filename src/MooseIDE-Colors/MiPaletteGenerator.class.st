"
I am a generator of palettes. 
Note: The number of colors to generate must be specified, the default value is 20

To generate a palette use the common method #generate:


"
Class {
	#name : #MiPaletteGenerator,
	#superclass : #Object,
	#instVars : [
		'numberOfColors',
		'generatedPalette'
	],
	#category : #'MooseIDE-Colors-PaletteGenerators'
}

{ #category : #translating }
MiPaletteGenerator class >> generate: aNumberOfColors [

	^ self new generate: aNumberOfColors 
]

{ #category : #testing }
MiPaletteGenerator class >> isAbstract [
	
	^ self == MiPaletteGenerator 
]

{ #category : #generating }
MiPaletteGenerator >> generate [

	"generate 20 colors by default"

	^ self generate: self numberOfColors
]

{ #category : #translating }
MiPaletteGenerator >> generate: aNumberOfColors [
	
	"return an object of palette with the specified number of colors"
	
	self numberOfColors: aNumberOfColors .
	^ generatedPalette class withAll: self makeColors .
	
	
]

{ #category : #accessing }
MiPaletteGenerator >> generatedPalette [

	^ generatedPalette
]

{ #category : #initialization }
MiPaletteGenerator >> initialize [ 
	
	super initialize .
	numberOfColors := 20.
	generatedPalette := MiGeneratedPalette new
]

{ #category : #accessing }
MiPaletteGenerator >> makeColors [

	^ self subclassResponsibility 
]

{ #category : #accessing }
MiPaletteGenerator >> numberOfColors [

	^ numberOfColors
]

{ #category : #accessing }
MiPaletteGenerator >> numberOfColors: anInteger [

	numberOfColors := anInteger
]

{ #category : #'gt-inspection' }
MiPaletteGenerator >> paletteInspectorExtension [

	<inspectorPresentationOrder: 1 title: 'Palette'>
	^ self generate paletteInspectorExtension
]
