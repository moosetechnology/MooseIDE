"
I am an utily class that emulates an tree component list presenter. Because this not exists (yet) in Spec.
"
Class {
	#name : #MiTreeComponentListPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'root',
		'componentListPresenter'
	],
	#category : #'Midas-NewTools-Queries Browser'
}

{ #category : #initialization }
MiTreeComponentListPresenter >> buildPresenterForNode: aNode indentation: aNumber [

	| presenter layoutForPresenter depthLevel |
	layoutForPresenter := SpBoxLayout newLeftToRight.
	depthLevel := aNode children isNotEmpty
		              ifTrue: [ aNumber * 2 - 1 ]
		              ifFalse: [ aNumber * 2 ].
	depthLevel timesRepeat: [ 
		layoutForPresenter
			add: (SpImagePresenter new
					 image: ((self iconNamed: #blank) scaledToSize: 8 @ 8);
					 yourself)
			expand: false ].
	aNode children isNotEmpty ifTrue: [ 
		layoutForPresenter
			add: (SpImagePresenter new
					 image: ((self iconNamed: #arrowDown) scaledToSize: 8 @ 8);
					 yourself)
			expand: false ].
	presenter := TestPresenter new
		             label: ('''' join: { 
						              aNode printString.
						              aNumber asString });
		             indentationLayout: layoutForPresenter;
		             yourself.
	^ presenter
]

{ #category : #initialization }
MiTreeComponentListPresenter >> buildTree: aNode depth: aNumber [

	| newPresenter listOfNodes |
	listOfNodes := OrderedCollection empty.
	"The is no presenter for the root query (FQRootQuery)"
	aNode = root ifFalse: [ 
		newPresenter := self
			                buildPresenterForNode: aNode
			                indentation: aNumber.
		listOfNodes add: newPresenter ].
	aNode children do: [ :child | 
		listOfNodes addAll: (self buildTree: child depth: aNumber + 1) ].
	^ listOfNodes
]

{ #category : #initialization }
MiTreeComponentListPresenter >> buildTreeOld: aNode depth: aNumber [

	| newPresenter |
	aNode = root ifFalse: [ 
		newPresenter := self
			                buildPresenterForNode: aNode
			                indentation: aNumber.
		componentListPresenter addPresenter: newPresenter ].
	aNode children do: [ :child | 
		self buildTreeOld: child depth: aNumber + 1 ]
]

{ #category : #initialization }
MiTreeComponentListPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: #componentListPresenter;
			 yourself)
]

{ #category : #initialization }
MiTreeComponentListPresenter >> initializePresenters [

	self initializeLayout.
	componentListPresenter := self newComponentList.
	componentListPresenter presenters: (self buildTree: root depth: 0)
	"self buildTreeOld: root depth: 0"
]

{ #category : #'accessing model' }
MiTreeComponentListPresenter >> setModelBeforeInitialization: aRoot [

	root := aRoot
]
