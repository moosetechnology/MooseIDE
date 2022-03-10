"
I am a version of the dropin container that does not allow more than a single presenter. 
"
Class {
	#name : #MiSingleDropInContainer,
	#superclass : #MiAbstractDropInContainer,
	#instVars : [
		'presenter'
	],
	#category : #'MooseIDE-Core-Workspace'
}

{ #category : #initialization }
MiSingleDropInContainer >> initializePresenters [

	super initializePresenters.
	self resetLayout
]

{ #category : #actions }
MiSingleDropInContainer >> install: aPresenter [

	"Note: called by the default #acceptDrop block. See #installTransfer:into: "

	presenter := aPresenter adaptToDropInto: self.
	layout removeAll.
	layout add: presenter.
	^ presenter
]

{ #category : #accessing }
MiSingleDropInContainer >> installedPresenter [

	^ presenter
]

{ #category : #accessing }
MiSingleDropInContainer >> installedPresenters [

	^ presenter ifNil: [ {  } ] ifNotNil: [ { presenter } ]
]

{ #category : #layout }
MiSingleDropInContainer >> newLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : #updating }
MiSingleDropInContainer >> noteThatWidgetHasBeenClosed: aPresenter [

	presenter = aPresenter ifFalse: [ ^ self ].
	presenter := nil.
	layout removeAll.
	layout add: dragHere
]

{ #category : #layout }
MiSingleDropInContainer >> resetLayout [

	super resetLayout.
	layout add: (presenter ifNotNil: [ presenter ] ifNil: [ dragHere ])
]
