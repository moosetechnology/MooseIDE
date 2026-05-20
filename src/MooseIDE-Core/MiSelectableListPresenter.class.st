Class {
	#name : 'MiSelectableListPresenter',
	#superclass : 'SpFilteringSelectableListPresenter',
	#instVars : [
		'selectAllCheckbox'
	],
	#category : 'MooseIDE-Core-Widgets',
	#package : 'MooseIDE-Core',
	#tag : 'Widgets'
}

{ #category : 'layout' }
MiSelectableListPresenter >> defaultLayout [
	"We are hacking the superclass layout to show a checkbox instead of the filter text field. 
This is not nice, we should make a PR to spec to manage this better"

	^ SpBoxLayout newTopToBottom
		  add: selectAllCheckbox expand: false;
		  add: listPresenter;
		  yourself
]

{ #category : 'initialization' }
MiSelectableListPresenter >> initializePresenters [

	super initializePresenters.

	selectAllCheckbox := self newCheckBox
		                     label: 'Select all';
		                     whenActivatedDo: [ self selectAll ];
		                     whenDeactivatedDo: [ self unselectAll ];
		                     yourself
]

{ #category : 'api - selection' }
MiSelectableListPresenter >> selectAll [

	| newlySelected |
	newlySelected := listPresenter items \ selectedItems.

	selectedItems addAll: newlySelected.
	listPresenter refresh.

	self onActivation ifNotNil: [ :valuable |
		newlySelected do: [ :item | valuable cull: item ] ]
]

{ #category : 'api - selection' }
MiSelectableListPresenter >> unselectAll [

	| currentSelected |
	currentSelected := selectedItems ifEmpty: [ ^ self ].

	selectedItems := Set new.
	listPresenter refresh.

	self onDeactivation ifNotNil: [ :valuable |
		currentSelected do: [ :item | valuable cull: item ] ]
]
