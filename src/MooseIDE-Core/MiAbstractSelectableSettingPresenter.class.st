Class {
	#name : 'MiAbstractSelectableSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'allItemsButton',
		'customItemsButton',
		'table',
		'noItemsButton'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> allItems [

	self subclassResponsibility
]

{ #category : 'layout' }
MiAbstractSelectableSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: (self newBoxLayoutTopToBottom
				   add: allItemsButton;
				   add: customItemsButton;
				   add: noItemsButton;
				   yourself);
		  add: table;
		  yourself
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> displayItem: anItem [

	^ anItem printString
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> iconColumn [
	"Do nothing by default. Add an icon column if necessary"

	^ nil
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> initializePresenters [

	super initializePresenters.

	table := self newTable.
	table
		hideColumnHeaders;
		addColumn: self tableColumns;
		items: self allItems;
		hide.

	self initializeRadioButtons
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> initializeRadioButtons [

	allItemsButton := self newRadioButton
		                  label: 'All';
		                  help: self help;
		                  yourself.
	customItemsButton := self newRadioButton
		                     label: 'Custom';
		                     help: self help;
		                     yourself.
	noItemsButton := self newRadioButton
		                 label: 'None';
		                 help: self help;
		                 yourself.

	customItemsButton whenActivatedDo: [ table show ].
	allItemsButton whenActivatedDo: [
			table hide.
			self selectAll ].
	noItemsButton whenActivatedDo: [
			table hide.
			self selectNone ].
	allItemsButton associatedRadioButtons: {
			customItemsButton.
			noItemsButton }.

	(self selectedItems equalsTo: self allItems) ifFalse: [
			self selectedItems
				ifEmpty: [ noItemsButton toggleState ]
				ifNotEmpty: [ customItemsButton toggleState ] ]
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> selectAll [

	self subclassResponsibility
]

{ #category : 'api - selection' }
MiAbstractSelectableSettingPresenter >> selectItem: anObject [

	self subclassResponsibility
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> selectNone [

	self subclassResponsibility
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> selectedItems [

	self subclassResponsibility
]

{ #category : 'initialization' }
MiAbstractSelectableSettingPresenter >> tableColumns [

	| column |
	column := SpCompositeTableColumn new.

	column addColumn: (SpCheckBoxTableColumn new
			 evaluated: [ :anObject | self selectedItems includes: anObject ];
			 onActivation: [ :anObject | self selectItem: anObject ];
			 onDeactivation: [ :anObject | self unselectItem: anObject ];
			 beNotExpandable).

	self iconColumn ifNotNil: [ :iconColumn |
		column addColumn: iconColumn ].

	column addColumn:
		(SpStringTableColumn evaluated: [ :item | self displayItem: item ]).

	^ column
]

{ #category : 'api - selection' }
MiAbstractSelectableSettingPresenter >> unselectItem: anObject [

	self subclassResponsibility
]
