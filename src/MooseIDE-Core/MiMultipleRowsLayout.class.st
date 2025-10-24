Class {
	#name : 'MiMultipleRowsLayout',
	#superclass : 'SpBoxLayout',
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'api - adding' }
MiMultipleRowsLayout >> add: aName withConstraints: aBlock [
	"This layout depends on the number of presenters so it should receive all presenters at once.
	
	instead of doing: 
	aCollectionOfPresenters do: [ :p | self layout add: p ]
	
	do: 
	self layout addPresenters: aCollectionOfPresenters
	"
	
	self error: 'Please use #addPresenters: with all your presenters at once'
]

{ #category : 'adding' }
MiMultipleRowsLayout >> addPresenters: aCollection [

	self addPresenters: aCollection withConstraints: [ :constraints |
			constraints
				expand: false;
				fill: false ]
]

{ #category : 'adding' }
MiMultipleRowsLayout >> addPresenters: aCollection withConstraints: aConstraintsBlock [
	"puts presenters on rows of up to 4 presenters (to the limit of 12 presenter)
	 tries to put same number of presenters on each row"

	| nbRows rowLength |
	self beTopToBottom.

	nbRows := aCollection size / 4 roundUpTo: 1.
	"rowLength is the number of items per row in order to be evenly distributed
	e.g: for 9 items it will be:
	 0 - 0 - 0
	 0 - 0 - 0
	 0 - 0 - 0
	instead of
	0 - 0 - 0 - 0
	0 - 0 - 0 - 0
	0
	"
	rowLength := aCollection size / nbRows roundUpTo: 1.


	(aCollection groupsOf: rowLength) do: [ :aRow |
			| rowLayout |
			rowLayout := SpBoxLayout newLeftToRight.
			aRow do: [ :presenter | rowLayout add: presenter withConstraints: aConstraintsBlock ].
			super add: rowLayout withConstraints: [ :c |
					c
						expand: false;
						fill: false ] ]
]
