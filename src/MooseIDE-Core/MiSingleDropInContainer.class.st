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

	self resetLayout.
]

{ #category : #initialization }
MiSingleDropInContainer >> install: aPresenter [

	"note: called by the default #acceptDrop: block"

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

{ #category : #initialization }
MiSingleDropInContainer >> newLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : #initialization }
MiSingleDropInContainer >> noteThatWidgetHasBeenClosed: aPresenter [

	self flag:
		'To remove or to be used when we can remove a presenter from workspace'.
	presenter = aPresenter ifFalse: [ ^ self ].

	presenter := nil.
	layout removeAll.
	layout add: dragHere
]

{ #category : #initialization }
MiSingleDropInContainer >> resetLayout [

	layout := self newLayout.
	layout add: (presenter ifNotNil: [ presenter ] ifNil: [ dragHere ])
]
