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

{ #category : #actions }
MiTreeComponentListPresenter >> buildLayoutForNode: aNode indentation: aNumber [

	| layoutForPresenter depthLevel |
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
	^ layoutForPresenter
]

{ #category : #actions }
MiTreeComponentListPresenter >> buildPresenterForNode: aNode indentation: aNumber [

	| presenter indentationLayout newLayout |
	indentationLayout := self buildLayoutForNode: aNode indentation: aNumber.
	presenter := self instantiate:
		             ((MiNewQueryCreationPresenter on: aNode)
			              parentPresenter: owner;
			              yourself).
	newLayout := SpBoxLayout newLeftToRight
		             add: indentationLayout expand: true;
		             add: presenter layout expand: false;
		             yourself.
	presenter layout: newLayout.
	^ presenter
]

{ #category : #actions }
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

{ #category : #actions }
MiTreeComponentListPresenter >> buildTreePresenter [

	componentListPresenter presenters: (self buildTree: root depth: 0)
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
	self buildTreePresenter
	"self buildTreeOld: root depth: 0"
]

{ #category : #'accessing model' }
MiTreeComponentListPresenter >> setModelBeforeInitialization: aRoot [

	root := aRoot
]

{ #category : #updating }
MiTreeComponentListPresenter >> update [

	self buildTreePresenter.
	super update
]
