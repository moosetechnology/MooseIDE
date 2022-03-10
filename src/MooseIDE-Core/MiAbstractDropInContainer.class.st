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

{ #category : #initialization }
MiAbstractDropInContainer >> acceptDrop: aBlock [

	dragHere acceptDrop: aBlock
]

{ #category : #accessing }
MiAbstractDropInContainer >> borderWidth: anInteger [ 
	 dragHere borderWidth: anInteger.
	dragHere borderColor: Color black .
]

{ #category : #'drag and drop' }
MiAbstractDropInContainer >> dropEnabled: aBoolean [ 
	dragHere dropEnabled: aBoolean 
]

{ #category : #initialization }
MiAbstractDropInContainer >> ensureNoLoopWith: aSp [
	| current | 
	current := self. 
	[ current isNil ] whileFalse: [ 
		current owner = aSp ifTrue: [ ^ self error: 'Invalid looping composition' ].
		current := current owner. 
	]
]

{ #category : #initialization }
MiAbstractDropInContainer >> initializePresenters [

	super initializePresenters.
	dragHere := self instantiate: MiDragHerePresenter.
	dragHere borderWidth: 2.
	dragHere dropInto: self.
	self borderWidth: 2.
	self wantsDrop: [ :transfer :destination | 
		self shouldAcceptTransfer: transfer into: destination ].
	self acceptDrop: [ :transfer :destination | 
		self installTransfer: transfer into: destination ]
]

{ #category : #initialization }
MiAbstractDropInContainer >> install: aPresenter [
	self subclassResponsibility 
]

{ #category : #initialization }
MiAbstractDropInContainer >> installTransfer: transfer into: destination [

	| installed passengerOwner |
	self ensureNoLoopWith: transfer passenger.
	passengerOwner := transfer passenger owner.

	installed := self install: transfer passenger.
	installed owner: self.

	passengerOwner noteThatWidgetHasBeenClosed: self
]

{ #category : #initialization }
MiAbstractDropInContainer >> isDropInContainer [	
	^ true
]

{ #category : #initialization }
MiAbstractDropInContainer >> newLayout [
	^ self subclassResponsibility 
]

{ #category : #initialization }
MiAbstractDropInContainer >> noteThatWidgetHasBeenClosed: aPresenter [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
MiAbstractDropInContainer >> ownerPrivateBus [
	^owner privateBus
]

{ #category : #initialization }
MiAbstractDropInContainer >> resetLayout [

	layout := self newLayout.
]

{ #category : #initialization }
MiAbstractDropInContainer >> shouldAcceptTransfer: aTransfer into: aDestination [

	(aTransfer isKindOf: SpTransferMorph) ifFalse: [ ^ false ].
	^ aTransfer passenger canBeAdaptedToDropInto: aDestination
]

{ #category : #initialization }
MiAbstractDropInContainer >> wantsDrop: aBlock [
 	dragHere wantsDrop: aBlock
]
