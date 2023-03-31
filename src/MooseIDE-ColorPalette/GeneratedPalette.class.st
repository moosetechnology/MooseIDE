"
I am the generated palette  
"
Class {
	#name : #GeneratedPalette,
	#superclass : #Palette,
	#instVars : [
		'currentShift'
	],
	#category : #'MooseIDE-ColorPalette-Palette'
}

{ #category : #accessing }
GeneratedPalette >> colorAt: anIndex [
	
	"I return the color at the index anIndex from the colorsDictionary. When using this method, the #currentColor is updated to the returned value"
	
	self updateCurrentColor: anIndex.
	^ super colorAt: anIndex 	
]

{ #category : #accessing }
GeneratedPalette >> colorFor: key [
	
	"I return the color specified by its key from the dictionary of colors. When using this method, the #currentColor is updated to the value returned"
	
	| indexOfKey |
	indexOfKey := self colorsDictionary indexOfKey: key.
	self updateCurrentColor: indexOfKey.
	^ super colorFor: key
]

{ #category : #accessing }
GeneratedPalette >> currentColor [
	
	"get the current color in the list of the colors"
	
	^ self colorAt: currentShift . 
	
]

{ #category : #accessing }
GeneratedPalette >> first [ 
	
	^ self colorAt: 1
]

{ #category : #initialization }
GeneratedPalette >> initialize [ 

	super initialize .
	currentShift := 1
]

{ #category : #accessing }
GeneratedPalette >> last [
	
	^ self colorAt: self asCollection size
]

{ #category : #accessing }
GeneratedPalette >> nextColor [
	
	"get the next color of the current color(use #currentColor) in the list of colors. If the current color is the last color, then the next color is the first color in the color list."
	
	| color nextShift |
	nextShift := currentShift + 1.
	nextShift > (colorsDictionary size) ifTrue: [ nextShift := 1 ].
	color := self asCollection at: nextShift.
	self updateCurrentColor: nextShift . 
	^ color
]

{ #category : #'gt-inspection' }
GeneratedPalette >> paletteInspectorExtension [

	<inspectorPresentationOrder: 1 title: 'Colors'>
	| table |
	table := SpTablePresenter new.
	table addColumn: (SpIndexTableColumn new
			 title: 'Index';
			 sortFunction: #yourself ascending;
			 beNotExpandable;
			 yourself).
	table addColumn:
		(SpImageTableColumn title: 'Colors' evaluated: [ :color | 
			 Morph new
				 color: color;
				 asFormOfSize: 50 @ 50 ]) beNotExpandable.
	table addColumn: (SpStringTableColumn
			 title: 'Code'
			 evaluated: [ :color | color asHexString asLowercase asSymbol ]).

	table items: self asCollection.

	^ table
]

{ #category : #accessing }
GeneratedPalette >> previousColor [
	
	"get the previous color of the current color(use #currentColor) in the list of colors"
	
	| color previousShift |
	previousShift := currentShift - 1.
	previousShift < 1 ifTrue: [ previousShift := colorsDictionary size ].
	color := self asCollection at: previousShift. 
	self updateCurrentColor: previousShift .
	^ color
]

{ #category : #removing }
GeneratedPalette >> removeColorAt: aKey [
	
	"I remove the key anIndex from the dictionary of colors. I modify the colorsDictionary. the value of the key is returned"
	
	| newColorsDictionary removedColor |
	newColorsDictionary := OrderedDictionary new.
	removedColor := self colorsDictionary at: aKey ifAbsent: [ ^ 0 ].
	self colorsDictionary associationsDo: [ :each |
		each key = aKey ifFalse: [ newColorsDictionary at: each key put: each value ]  ].
	self colorsDictionary: newColorsDictionary .
	^ removedColor 
]

{ #category : #accessing }
GeneratedPalette >> second [ 
	
	^ self colorAt: 2
]

{ #category : #accessing }
GeneratedPalette >> third [
	
	^ self colorAt: 3
]

{ #category : #private }
GeneratedPalette >> updateCurrentColor: anIndex [

	currentShift := anIndex
]
