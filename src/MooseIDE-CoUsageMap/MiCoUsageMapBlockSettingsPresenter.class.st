"
Presenter created to edit the children block, outer boxes sort block, and inner boxes sort block.
This interacts directly with MiCoUsageMapSettings
"
Class {
	#name : #MiCoUsageMapBlockSettingsPresenter,
	#superclass : #MiCoUsageMapAbstractSettingsPresenter,
	#instVars : [
		'childrenTextInput',
		'sortOuterBoxTextInput',
		'sortInnerBoxTextInput',
		'button',
		'resetButton'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #layout }
MiCoUsageMapBlockSettingsPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: 'Children block:' asPresenter expand: false;
		add: #childrenTextInput height: 200;
		add: 'Outer box sort block:' asPresenter expand: false;
		add: #sortOuterBoxTextInput height: 170;
		add: 'Inner box sort block:' asPresenter expand: false;
		add: #sortInnerBoxTextInput height: 170;
		add: (SpBoxLayout newLeftToRight
			hAlignCenter;
			borderWidth: 5;
			addLast: (SpBoxLayout newLeftToRight
				add: #button;
				add: #resetButton;
				yourself) expand: false;
			yourself) expand: false;
		yourself
]

{ #category : #initialization }
MiCoUsageMapBlockSettingsPresenter >> connectPresenters [
	| set |
	set := self settings.
	set ifNil: [ ^ self ].
	childrenTextInput text: set childrenBlockText.
	sortOuterBoxTextInput text: set outerBoxSortBlockText.
	sortInnerBoxTextInput text: set innerBoxSortBlockText.
]

{ #category : #initialization }
MiCoUsageMapBlockSettingsPresenter >> initializeButtons [
	button := self newButton
		label: 'Apply all';
		action: [ 
			childrenTextInput triggerSubmitAction.
			sortOuterBoxTextInput triggerSubmitAction.
			sortInnerBoxTextInput triggerSubmitAction  ].
	resetButton := self newButton
		label: 'Reset text fields';
		action: [ | set |
			set := self settings.
			set resetText.
			childrenTextInput text: set childrenBlockText.
			sortOuterBoxTextInput text: set outerBoxSortBlockText.
			sortInnerBoxTextInput text: set innerBoxSortBlockText.
			 ]
		
		
]

{ #category : #initialization }
MiCoUsageMapBlockSettingsPresenter >> initializePresenters [
	childrenTextInput := self newCode
		whenSubmitDo: [ :text | self settings childrenBlockText: text ];
		yourself.
	sortOuterBoxTextInput := self newCode
		whenSubmitDo: [ :text | self settings outerBoxSortBlockText: text ];
		yourself.
	sortInnerBoxTextInput := self newCode
		whenSubmitDo: [ :text | self settings innerBoxSortBlockText: text ];
		yourself.
	self initializeButtons
]

{ #category : #initialization }
MiCoUsageMapBlockSettingsPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter 
		initialExtent: 500@700;
		title: 'Blocks Settings - Co Usage Map'
]
