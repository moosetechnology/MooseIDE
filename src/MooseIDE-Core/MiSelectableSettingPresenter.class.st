Class {
	#name : #MiSelectableSettingPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'allItemsButton',
		'customItemsButton',
		'settingCommand',
		'table',
		'displayBlock',
		'noItemsButton'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #layout }
MiSelectableSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: allItemsButton;
		  add: customItemsButton;
		  add: table;
		  add: noItemsButton;
		  yourself
]

{ #category : #api }
MiSelectableSettingPresenter >> display [

	^ displayBlock ifNil: [ #printString ]
]

{ #category : #api }
MiSelectableSettingPresenter >> display: aBlock [

	displayBlock := aBlock
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

{ #category : #'as yet unclassified' }
MiSelectableSettingPresenter >> initializeRadioButtons [

	allItemsButton := self newRadioButton label: 'All'.
	customItemsButton := self newRadioButton label: 'Custom'.
	noItemsButton := self newRadioButton label: 'None'.

	customItemsButton whenActivatedDo: [ table show ].
	allItemsButton associatedRadioButtons: {
			customItemsButton.
			noItemsButton }.

	settingCommand currentValue = settingCommand allItems ifFalse: [
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

{ #category : #'as yet unclassified' }
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

	column addColumn: (SpStringTableColumn evaluated: self display).

	^ column
]
