"
Presenter created to edit the children block, outer boxes sort block, and inner boxes sort block.
This interacts directly with MiCoUsageMapSettings
"
Class {
	#name : #MiCoUsageMapSettingsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'childrenTextInput',
		'sortOuterBoxTextInput',
		'sortInnerBoxTextInput',
		'button',
		'resetButton'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #specs }
MiCoUsageMapSettingsPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: 'Children block:' asPresenter expand: false;
		add: #childrenTextInput;
		add: 'Outer box sort block:' asPresenter expand: false;
		add: #sortOuterBoxTextInput height: 170;
		add: 'Inner box sort block:' asPresenter expand: false;
		add: #sortInnerBoxTextInput height: 50;
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
MiCoUsageMapSettingsPresenter >> initializeButtons [
	| cls |
	cls := MiCoUsageMapSettings.
	button := self newButton
		label: 'Apply all';
		action: [ 
			childrenTextInput triggerSubmitAction.
			sortOuterBoxTextInput triggerSubmitAction.
			sortInnerBoxTextInput triggerSubmitAction  ].
	resetButton := self newButton
		label: 'Reset text fields';
		action: [ 
			cls resetText.
			childrenTextInput text: cls childrenBlockText.
			sortOuterBoxTextInput text: cls outerBoxSortBlockText.
			sortInnerBoxTextInput text: cls innerBoxSortBlockText.
			 ]
		
		
]

{ #category : #initialization }
MiCoUsageMapSettingsPresenter >> initializePresenters [
	| cls |
	cls := MiCoUsageMapSettings.
	childrenTextInput := self newCode
		text: cls childrenBlockText;
		whenSubmitDo: [ :text | cls childrenBlockText: text ];
		yourself.
	sortOuterBoxTextInput := self newCode
		text: cls outerBoxSortBlockText;
		whenSubmitDo: [ :text | cls outerBoxSortBlockText: text ];
		yourself.
	sortInnerBoxTextInput := self newCode
		text: cls innerBoxSortBlockText;
		whenSubmitDo: [ :text | cls innerBoxSortBlockText: text ];
		yourself.
	self initializeButtons
]

{ #category : #initialization }
MiCoUsageMapSettingsPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter 
		initialExtent: 500@600;
		title: 'Blocks Settings - Co Usage Map'
]
