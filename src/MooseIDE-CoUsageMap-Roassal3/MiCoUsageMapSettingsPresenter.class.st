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
		'button'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3-Settings'
}

{ #category : #specs }
MiCoUsageMapSettingsPresenter class >> defaultSpec [
	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: 'Children block:' asPresenter expand: false;
		add: #childrenTextInput;
		add: 'Outer box sort block:' asPresenter expand: false;
		add: #sortOuterBoxTextInput;
		add: 'Inner box sort block:' asPresenter expand: false;
		add: #sortInnerBoxTextInput;
		add: (SpBoxLayout newLeftToRight
			hAlignCenter;
			borderWidth: 5;
			addLast: #button expand: false;
			yourself) expand: false;
		yourself
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
	button := self newButton
		label: 'Apply all';
		action: [ 
			childrenTextInput triggerSubmitAction.
			sortOuterBoxTextInput triggerSubmitAction.
			sortInnerBoxTextInput triggerSubmitAction  ]
		
	
]

{ #category : #initialization }
MiCoUsageMapSettingsPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter 
		initialExtent: 500@600;
		title: 'Blocks Settings - Co Usage Map'
]
