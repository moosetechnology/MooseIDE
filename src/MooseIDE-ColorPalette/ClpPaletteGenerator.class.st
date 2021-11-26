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

{ #category : #'gt-inspection' }
ClpPaletteGenerator >> gtInspectorColorsIn: composite [
	<gtInspectorPresentationOrder: 0>
	
	^ composite fastTable
		title: 'Colors';
		display: [ self generate asCollection ];
		beMultiple;
		enableElementIndex;
		wantsAutomaticRefresh: true;
		column: 'Index' evaluated: [ :color :idex | idex asString ] width: 50;
		column: 'Color' evaluated: [ :color | BorderedMorph new color: color ] width: 52;
		column: 'Code' evaluated: [ :color | GTObjectPrinter asTruncatedTextFrom: color asHexString asLowercase asSymbol ];
		send: [ :result | 
			result
				ifNil: [ nil ]
				ifNotNil: [ result size = 1
						ifTrue: [ result anyOne ]
						ifFalse: [ self species withAll: result ]
					]
			]
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
