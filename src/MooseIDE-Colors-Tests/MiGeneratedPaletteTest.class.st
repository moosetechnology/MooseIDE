Class {
	#name : #MiGeneratedPaletteTest,
	#superclass : #MiPaletteTest,
	#category : #'MooseIDE-Colors-Tests-Palettes-Tests'
}

{ #category : #accessing }
MiGeneratedPaletteTest >> classToTest [ 

	^ MiGeneratedPalette 
]

{ #category : #tests }
MiGeneratedPaletteTest >> testCurrentColor [
	
	| aChosenColor |
	self assert: nonEmptyPalette currentColor equals: nonEmptyPalette first .
	aChosenColor := nonEmptyPalette colorAt: 2.
	self assert: nonEmptyPalette currentColor equals: aChosenColor  
]

{ #category : #tests }
MiGeneratedPaletteTest >> testNextColor [
	
	| aChosenColor |
	self assert: nonEmptyPalette currentColor equals: nonEmptyPalette first .
	self assert: nonEmptyPalette nextColor equals: nonEmptyPalette second.
	
	aChosenColor := nonEmptyPalette colorAt: 2.
	self assert: nonEmptyPalette currentColor equals: aChosenColor .
	self assert: nonEmptyPalette nextColor equals: nonEmptyPalette third.
	
	aChosenColor := nonEmptyPalette last.
	self assert: nonEmptyPalette currentColor equals: aChosenColor .
	self assert: nonEmptyPalette nextColor equals: nonEmptyPalette first 
]

{ #category : #tests }
MiGeneratedPaletteTest >> testPreviousColor [
	
	| colorSelected |
	self assert: nonEmptyPalette currentColor equals: self colors first .
	self assert: nonEmptyPalette previousColor equals: self colors last.
	
	colorSelected := nonEmptyPalette colorAt: 2.
	self assert: nonEmptyPalette currentColor equals: self colors second .
	self assert: nonEmptyPalette previousColor equals: self colors first
]

{ #category : #tests }
MiGeneratedPaletteTest >> testRemoveColorAt [
	
	| colorToRemove removedColor nonExistantKeyColor |
	colorToRemove := self colors first.
	self assert: nonEmptyPalette colorsDictionary size equals: self colors size. 
	
	removedColor := nonEmptyPalette removeColorAt: 1.
	self assert: removedColor equals: colorToRemove .
	self assert: nonEmptyPalette colorsDictionary size equals: self colors size - 1.
	self deny: (nonEmptyPalette colorsDictionary includesAssociation: 1->colorToRemove).
	
	"remove a non-existent color"
	nonExistantKeyColor := 4.
	self assert: (nonEmptyPalette removeColorAt: nonExistantKeyColor) equals: 0.
	self assert: nonEmptyPalette colorsDictionary size equals: self colors size - 1.
	

]
