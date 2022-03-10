"
I define the basic abstract feature of a spec surface allowing to accept dropped spec presenters
"
Class {
	#name : #MiAbstractDropInContainer,
	#superclass : #SpPresenter,
	#instVars : [
		'dragHere',
		'installingStrategy'
	],
	#category : #'MooseIDE-Core-Workspace'
}

{ #category : #'drag and drop' }
MiAbstractDropInContainer >> acceptDrop: aBlock [

	dragHere acceptDrop: aBlock
]

{ #category : #accessing }
MiAbstractDropInContainer >> borderWidth: anInteger [

	dragHere borderWidth: anInteger.
	dragHere borderColor: Color black
]

{ #category : #'drag and drop' }
MiAbstractDropInContainer >> dropEnabled: aBoolean [

	dragHere dropEnabled: aBoolean
]

{ #category : #actions }
MiAbstractDropInContainer >> ensureNoLoopWith: aSp [

	| current |
	current := self.
	[ current isNil ] whileFalse: [ 
		current owner = aSp ifTrue: [ 
			^ self error: 'Invalid looping composition' ].
		current := current owner ]
]

{ #category : #initialization }
MiAbstractDropInContainer >> initializePresenters [

	dragHere := self instantiate: MiDragHerePresenter.
	dragHere dropInto: self.

	self borderWidth: 2.

	self wantsDrop: [ :transfer :destination | 
		self shouldAcceptTransfer: transfer into: destination ].
	self acceptDrop: [ :transfer :destination | 
		self installTransfer: transfer into: destination ]
]

{ #category : #actions }
MiAbstractDropInContainer >> install: aPresenter [

	self subclassResponsibility
]

{ #category : #actions }
MiAbstractDropInContainer >> installTransfer: transfer into: destination [

	| installed passengerOwner |
	self ensureNoLoopWith: transfer passenger.
	passengerOwner := transfer passenger owner.

	installed := self install: transfer passenger.
	installed owner: self.

	passengerOwner noteThatWidgetHasBeenClosed: self
]

{ #category : #testing }
MiAbstractDropInContainer >> isDropInContainer [

	^ true
]

{ #category : #layout }
MiAbstractDropInContainer >> newLayout [

	^ self subclassResponsibility
]

{ #category : #updating }
MiAbstractDropInContainer >> noteThatWidgetHasBeenClosed: aPresenter [

	self flag:
		'To remove or to be used when we can remove a presenter from workspace'.

	^ self subclassResponsibility
]

{ #category : #layout }
MiAbstractDropInContainer >> resetLayout [

	self layout: self newLayout
]

{ #category : #testing }
MiAbstractDropInContainer >> shouldAcceptTransfer: aTransfer into: aDestination [

	(aTransfer isKindOf: SpTransferMorph) ifFalse: [ ^ false ].

	^ aTransfer passenger canBeAdaptedToDropInto: aDestination
]

{ #category : #'drag and drop' }
MiAbstractDropInContainer >> wantsDrop: aBlock [

	dragHere wantsDrop: aBlock
]
