"
I accept dropped presenters and I extend my surface for it
"
Class {
	#name : #MiMultiDropInContainer,
	#superclass : #MiAbstractDropInContainer,
	#instVars : [
		'presenters',
		'newLayoutBlock'
	],
	#category : #'MooseIDE-Core-Workspace'
}

{ #category : #layout }
MiMultiDropInContainer >> beLeftToRight [

	newLayoutBlock := [ SpBoxLayout newLeftToRight ].
	self resetLayout
]

{ #category : #layout }
MiMultiDropInContainer >> beTopToBottom [

	newLayoutBlock := [ SpBoxLayout newTopToBottom ].
	self resetLayout
]

{ #category : #initialization }
MiMultiDropInContainer >> initializePresenters [

	super initializePresenters.
	presenters := OrderedCollection new.
	self beTopToBottom
]

{ #category : #actions }
MiMultiDropInContainer >> install: aPresenter [

	| newPresenter |
	newPresenter := aPresenter adaptToDropInto: self.
	presenters add: newPresenter.

	layout removeAll.
	presenters do: [ :p | layout add: p ].

	self shouldHideDragHere ifFalse: [ layout add: dragHere height: 10 ].

	^ newPresenter
]

{ #category : #accessing }
MiMultiDropInContainer >> installedPresenters [

	^ presenters flatCollect: [ :presenter | 
		  presenter isDropInContainer
			  ifTrue: [ presenter installedPresenters ]
			  ifFalse: [ { presenter } ] ]
]

{ #category : #layout }
MiMultiDropInContainer >> newLayout [

	^ newLayoutBlock value
]

{ #category : #updating }
MiMultiDropInContainer >> noteThatWidgetHasBeenClosed: aPresenter [

	self flag:
		'To remove or to be used when we can remove a presenter from workspace'.
	presenters remove: aPresenter.

	layout removeAll.

	presenters do: [ :p | layout add: p ].

	(presenters anySatisfy: [ :p | p isDropInContainer ]) ifFalse: [ 
		presenters
			ifEmpty: [ layout add: dragHere ]
			ifNotEmpty: [ layout add: dragHere height: 10 ] ]
]

{ #category : #layout }
MiMultiDropInContainer >> resetLayout [

	super resetLayout.
	presenters do: [ :p | layout add: p ].
	layout add: dragHere
]

{ #category : #testing }
MiMultiDropInContainer >> shouldHideDragHere [

	^ presenters anySatisfy: [ :p | p isDropInContainer ]
]
