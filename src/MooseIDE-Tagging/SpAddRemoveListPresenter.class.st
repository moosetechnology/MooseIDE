"
A generic presenter that handles a list of 'named objects'

Presents a drop list of 'named objects' and a text field to enter new objects
plus 2 buttons to add an object (named from the text field) and remove an object (selected in the list)

API:
- #nameDisplayBlock: -- sets a block to execute to get the 'name' of a named object
- #refreshList: -- updates the drop list of named objects
- #selectName: -- forces the selection of the named object in argument inside the drop list
- #selectedName -- returns the named object selected in the list
- #whenSelectedNameChangedDo: -- sets a block to execute when an object in the drop list is selected
- #addNameAction: -- sets a block to execute when the add button is pressed
- #delNameAction: -- sets a block to execute when the remove button is pressed

"
Class {
	#name : #SpAddRemoveListPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'txtName',
		'btnDel',
		'btnAdd',
		'lstAll',
		'itemDisplayBlock',
		'addBlock',
		'delBlock',
		'selectItemBlock'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #specs }
SpAddRemoveListPresenter class >> defaultSpec [

	^SpGridLayout new
		add: #lstAll at: 1 @ 1 ;
		add: #txtName at: 1 @ 2 ;
		add: #btnDel at: 2 @ 1 ;
		add: #btnAdd at: 2 @ 2 ;
		yourself
]

{ #category : #accessing }
SpAddRemoveListPresenter >> addNameAction: aBlock [
	btnAdd action: aBlock
]

{ #category : #accessing }
SpAddRemoveListPresenter >> clearName [
	txtName text: ''
]

{ #category : #accessing }
SpAddRemoveListPresenter >> delNameAction: aBlock [
	btnDel action: aBlock
]

{ #category : #initialization }
SpAddRemoveListPresenter >> initialize [
	super initialize.
	
	self nameDisplayBlock: [ :object | object name ].
	self whenSelectedNameChangedDo: [:selected | "don't do anything" ].
	self addNameAction: [ "don't do anything" ].
	self delNameAction: [ "don't do anything" ]

]

{ #category : #initialization }
SpAddRemoveListPresenter >> initializePresenters [
	super initializePresenters.

	txtName := self newTextInput.
	lstAll := self newDropList.
	btnAdd := self newButton
		label: 'Add' ;
		yourself.

	btnDel := self newButton
		label: 'Delete' ;
		yourself.
]

{ #category : #accessing }
SpAddRemoveListPresenter >> nameDisplayBlock: aBlock [
	 lstAll display: aBlock
]

{ #category : #accessing }
SpAddRemoveListPresenter >> nameEntered [
	^txtName text
]

{ #category : #updating }
SpAddRemoveListPresenter >> refreshList: aCollection [
	lstAll resetSelection.
	lstAll items: aCollection
]

{ #category : #updating }
SpAddRemoveListPresenter >> selectName: aString [
	lstAll selectItem: aString
]

{ #category : #accessing }
SpAddRemoveListPresenter >> selectedName [
	lstAll selectedItem
]

{ #category : #accessing }
SpAddRemoveListPresenter >> whenSelectedNameChangedDo: aBlock [
	lstAll whenSelectedItemChangedDo: aBlock
]
