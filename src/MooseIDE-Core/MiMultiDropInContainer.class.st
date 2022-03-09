"
I accept dropped presenters and i extend my surgace for 
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

{ #category : #initialization }
MiMultiDropInContainer >> beLeftToRight [

	newLayoutBlock := [ SpBoxLayout newLeftToRight ].
	self resetLayout
]

{ #category : #initialization }
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

{ #category : #initialization }
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

	^ presenters flatCollect: [ :a | 
		  (a respondsTo: #installedPresenters)
			  ifTrue: [ a installedPresenters ]
			  ifFalse: [ { a } ] ]
]

{ #category : #initialization }
MiMultiDropInContainer >> newLayout [

	^ newLayoutBlock value
]

{ #category : #testing }
MiMultiDropInContainer >> noteThatWidgetHasBeenClosed: aPresenter [

	presenters remove: aPresenter.
	layout removeAll.
	presenters do: [ :p | layout add: p ].
	(presenters anySatisfy: [ :p | p isDropInContainer ]) ifFalse: [ 
		presenters
			ifEmpty: [ layout add: dragHere ]
			ifNotEmpty: [ layout add: dragHere height: 10 ] ]
]

{ #category : #initialization }
MiMultiDropInContainer >> resetLayout [

	super resetLayout.
	presenters do: [ :p | layout add: p ].
	layout add: dragHere
]

{ #category : #initialization }
MiMultiDropInContainer >> shouldHideDragHere [

	^ presenters anySatisfy: [ :p | p isDropInContainer ]
]
