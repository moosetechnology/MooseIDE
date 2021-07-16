"
I am a presenter that allows multiselection. I was created because there is no yet implemented in Spec a drop list with checkboxes (for multi-selection).
For initialize me you have to set my `displayBlock`, `windowName` and `whenWindowClosedBlock` variables.

For example:
```
	(MiMultiSelectionTable on: aCollection)
		displayBlock: #name;
		windowName: 'Types';
		whenWindowClosedDo: [ :selectedTypes | 
			self someMethod: selectedTypes ]
```

whenWindowClosedDo is very important, because it will determine the action after selecting the desirable items and closing the window.
"
Class {
	#name : #MiMultiSelectionTable,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'items',
		'selectedItems',
		'displayBlock',
		'windowName',
		'whenWindowClosedBlock'
	],
	#category : #'Midas-NewTools-Queries Browser configuration'
}

{ #category : #actions }
MiMultiSelectionTable >> deactivationAction: each [

	selectedItems size = 1
		ifTrue: [ 
			UIManager default
				alert: 'You must select at least one item'
				title: 'Cannot unselect all items' ]
		ifFalse: [ selectedItems remove: each ].
	^ self update
]

{ #category : #'api - initializing' }
MiMultiSelectionTable >> displayBlock: aBlock [

	displayBlock := aBlock
]

{ #category : #initialization }
MiMultiSelectionTable >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: #table;
			 yourself)
]

{ #category : #initialization }
MiMultiSelectionTable >> initializePresenter [

	self initializeLayout.
	self initializeTable
]

{ #category : #initialization }
MiMultiSelectionTable >> initializeTable [

	table := self newTable.
	table
		addColumn: ((SpCheckBoxTableColumn
				  title: ''
				  evaluated: [ :each | selectedItems includes: each ])
				 onActivation: [ :each | selectedItems add: each ];
				 onDeactivation: [ :each | self deactivationAction: each ];
				 width: 20;
				 yourself);
		addColumn: (SpStringTableColumn
				 title: 'Name'
				 evaluated: [ :each | displayBlock value: each ]);
		items: items;
		beResizable
]

{ #category : #initialization }
MiMultiSelectionTable >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: windowName;
		whenClosedDo: [ whenWindowClosedBlock value: selectedItems ]
]

{ #category : #accessing }
MiMultiSelectionTable >> items: aModel [

	items := aModel asOrderedCollection copy.
	selectedItems := items asOrderedCollection copy.
	table items: items
]

{ #category : #api }
MiMultiSelectionTable >> open [

	^ self openModalWithSpec
]

{ #category : #'accessing - model' }
MiMultiSelectionTable >> setModelBeforeInitialization: aModel [

	"The `copy` message is to avoid having references to another objects."

	items := aModel asOrderedCollection copy.
	selectedItems := items asOrderedCollection copy
]

{ #category : #'api - initializing' }
MiMultiSelectionTable >> whenWindowClosedDo: aFullBlockClosure [

	whenWindowClosedBlock := aFullBlockClosure
]

{ #category : #'api - initializing' }
MiMultiSelectionTable >> windowName: aString [ 
	windowName := aString
]
