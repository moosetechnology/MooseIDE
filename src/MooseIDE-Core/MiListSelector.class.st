"
I am a list selection widget.

The list on the left is the source list. The list on the right is filled from the left list using the buttons.
"
Class {
	#name : #MiListSelector,
	#superclass : #MiPresenter,
	#instVars : [
		'initialList',
		'selectedList',
		'selectButton',
		'selectAllButton',
		'unselectAllButton',
		'unselectButton'
	],
	#category : #'MooseIDE-Core-Widgets'
}

{ #category : #layout }
MiListSelector class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: #initialList;
		  add: self filterLayout width: 50;
		  add: #selectedList;
		  yourself
]

{ #category : #specs }
MiListSelector class >> filterLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 6;
		  borderWidth: 8;
		  add: SpNullPresenter new expand: true;
		  add: #selectButton expand: false;
		  add: #selectAllButton expand: false;
		  add: #unselectButton expand: false;
		  add: #unselectAllButton expand: false;
		  add: SpNullPresenter new expand: true;
		  yourself
]

{ #category : #selection }
MiListSelector >> addSelected [

	| selectedItems |
	selectedItems := initialList listPresenter selectedItems.

	selectedList listPresenter items:
		selectedList listPresenter items , selectedItems.

	initialList listPresenter items:
		(initialList listPresenter items \ selectedItems)
]

{ #category : #accessing }
MiListSelector >> initialItems: aCollection [

	initialList items: aCollection copy
]

{ #category : #accessing }
MiListSelector >> initialListHeader: aString [

	initialList listPresenter headerTitle: aString
]

{ #category : #initialization }
MiListSelector >> initializeButtons [

	selectButton := self newButton
		             label: '>';
		             action: [ self addSelected ].
	selectAllButton := self newButton
		                label: '>>>';
		                action: [ self selectAll ].
	unselectButton := self newButton
		                label: '<';
		                action: [ self removeSelected ].
	unselectAllButton := self newButton
		                   label: '<<<';
		                   action: [ self unselectAll ]
]

{ #category : #initialization }
MiListSelector >> initializeLists [

	initialList := self newFilteringList.
	initialList listPresenter
		beMultipleSelection;
		headerTitle: 'Initial list';
		sortingBlock: #yourself ascending.

	selectedList := self newFilteringList.
	selectedList listPresenter
		beMultipleSelection;
		headerTitle: 'Selection';
		sortingBlock: #yourself ascending
]

{ #category : #initialization }
MiListSelector >> initializePresenters [

	self initializeLists.
	self initializeButtons
]

{ #category : #selection }
MiListSelector >> removeSelected [

	| selectedItems |
	selectedItems := selectedList listPresenter selectedItems.

	initialList listPresenter items:
		initialList listPresenter items , selectedItems.

	selectedList listPresenter items:
		selectedList listPresenter items \ selectedItems
]

{ #category : #selection }
MiListSelector >> selectAll [

	selectedList listPresenter items:
		selectedList listPresenter items , initialList listPresenter items.

	initialList listPresenter items: {  }
]

{ #category : #accessing }
MiListSelector >> selectedItems [

	^ selectedList listPresenter items
]

{ #category : #accessing }
MiListSelector >> selectedItems: aCollection [

	selectedList listPresenter items: aCollection.
	initialList listPresenter items:
		initialList listPresenter items \ aCollection
]

{ #category : #accessing }
MiListSelector >> selectedListHeader: aString [

	selectedList listPresenter headerTitle: aString
]

{ #category : #selection }
MiListSelector >> unselectAll [

	initialList listPresenter items:
		initialList listPresenter items , selectedList listPresenter items.

	selectedList listPresenter items: {  }
]
