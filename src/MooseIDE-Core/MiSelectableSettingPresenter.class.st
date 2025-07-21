Class {
	#name : #MiSelectableSettingPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'settingCommand',
		'allItemsButton',
		'customItemsButton',
		'table',
		'noItemsButton'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #layout }
MiSelectableSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: (self newBoxLayoutTopToBottom
				   add: allItemsButton;
				   add: customItemsButton;
				   add: noItemsButton;
				   yourself);
		  add: table;
		  yourself
]

{ #category : #accessing }
MiSelectableSettingPresenter >> help: aString [

	allItemsButton help: aString.
	customItemsButton help: aString.
	noItemsButton help: aString.
	table help: aString
]

{ #category : #initialization }
MiSelectableSettingPresenter >> initializePresenters [

	table := self newTable.
	table
		hideColumnHeaders;
		addColumn: self tableColumns;
		items: settingCommand allItems;
		hide.

	self initializeRadioButtons
]

{ #category : #initialization }
MiSelectableSettingPresenter >> initializeRadioButtons [

	allItemsButton := self newRadioButton label: 'All'.
	customItemsButton := self newRadioButton label: 'Custom'.
	noItemsButton := self newRadioButton label: 'None'.

	customItemsButton whenActivatedDo: [ table show ].
	allItemsButton associatedRadioButtons: {
			customItemsButton.
			noItemsButton }.

	(settingCommand currentValue equalsTo: settingCommand allItems) ifFalse: [
			settingCommand currentValue
				ifEmpty: [ noItemsButton toggleState ]
				ifNotEmpty: [ customItemsButton toggleState ] ].

	allItemsButton whenActivatedDo: [
			settingCommand execute: settingCommand allItems.
			table hide ].
	noItemsButton whenActivatedDo: [
			settingCommand execute: OrderedCollection new.
			table hide ]
]

{ #category : #'accessing - model' }
MiSelectableSettingPresenter >> setModelBeforeInitialization: aSettingCommand [

	settingCommand := aSettingCommand
]

{ #category : #initialization }
MiSelectableSettingPresenter >> tableColumns [

	| column selectColumn |
	column := SpCompositeTableColumn new.

	column addColumn: (selectColumn := SpCheckBoxTableColumn new
			                 evaluated: [ :anObject |
				                 settingCommand currentValue includes: anObject ];
			                 onActivation: [ :anObject |
				                 settingCommand addItem: anObject ];
			                 onDeactivation: [ :anObject |
				                 settingCommand removeItem: anObject ];
			                 beNotExpandable).

	settingCommand icon ifNotNil: [ :nameValuable |
		column addColumn: (SpImageTableColumn new evaluated: nameValuable) ].

	column addColumn:
		(SpStringTableColumn evaluated: settingCommand itemsDisplay).

	^ column
]
