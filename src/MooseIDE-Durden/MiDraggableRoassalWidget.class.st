"
I allow to drag my roassal content into a MiDropIntoBrowser
"
Class {
	#name : #MiDraggableRoassalWidget,
	#superclass : #MiDraggableAbstractWidget,
	#instVars : [
		'viewport',
		'refresh'
	],
	#category : #'MooseIDE-Durden'
}

{ #category : #specs }
MiDraggableRoassalWidget class >> defaultLayout [
	^ super defaultLayout
		add: #viewport;
		add: #refresh height: self toolbarHeight; 
		yourself
]

{ #category : #specs }
MiDraggableRoassalWidget class >> isAbstract [

	^ self = MiDraggableRoassalWidget
]

{ #category : #initialization }
MiDraggableRoassalWidget >> element [

	^ toSelect
]

{ #category : #initialization }
MiDraggableRoassalWidget >> followAction [

	self viewport script: [ :aCanvas | 
		self loadChart: aCanvas withElement: self element ]
]

{ #category : #initialization }
MiDraggableRoassalWidget >> initializePresenters [

	super initializePresenters.
	viewport := self instantiate:
		            (self class environment classNamed: #SpRoassalPresenter).
	refresh := self newButton.
	refresh label: 'Refresh'.
	refresh action: [ self refresh ]
]

{ #category : #initialization }
MiDraggableRoassalWidget >> loadChart: aCanvas withElement: anElement [ 

	self subclassResponsibility

]

{ #category : #initialization }
MiDraggableRoassalWidget >> refresh [

	self followAction
]

{ #category : #initialization }
MiDraggableRoassalWidget >> viewport [

	^ (viewport isKindOf: SpLabelPresenter)
		  ifTrue: [ viewport := self instantiate: SpRoassalPresenter ]
		  ifFalse: [ viewport ]
]
