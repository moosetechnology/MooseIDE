Class {
	#name : #MiEditableListSelector,
	#superclass : #MiPresenter,
	#instVars : [
		'editableList',
		'addList',
		'allItems'
	],
	#category : #'MooseIDE-Core-Widgets'
}

{ #category : #accessing }
MiEditableListSelector >> allItems: aCollection [

	allItems := aCollection
]

{ #category : #initialization }
MiEditableListSelector >> connectPresenters [

	editableList addItemBlock: [ self openAddList. nil ]
]

{ #category : #initialization }
MiEditableListSelector >> defaultLayout [

	^ SpScrollableLayout new
		  child: editableList;
		  yourself
]

{ #category : #api }
MiEditableListSelector >> display: aBlock [

	editableList display: aBlock.
	addList display: aBlock
]

{ #category : #api }
MiEditableListSelector >> displayIcon: aBlock [

	editableList displayIcon: aBlock.
	addList displayIcon: aBlock
]

{ #category : #initialization }
MiEditableListSelector >> initialize [ 

	super initialize.
	allItems := OrderedCollection new
]

{ #category : #initialization }
MiEditableListSelector >> initializePresenters [

	addList := self newList
		           beMultipleSelection;
		           yourself.
	editableList := self instantiate: SpEditableListPresenter
]

{ #category : #accessing }
MiEditableListSelector >> items [

	^ editableList items
]

{ #category : #accessing }
MiEditableListSelector >> items: aCollection [

	editableList items: aCollection
]

{ #category : #initialization }
MiEditableListSelector >> openAddList [

	| modal |
	addList items: allItems \ self items.
	modal := addList asModalWindow.
	modal okAction: [ 
		editableList items: editableList items , addList selectedItems ].
	modal open
]
