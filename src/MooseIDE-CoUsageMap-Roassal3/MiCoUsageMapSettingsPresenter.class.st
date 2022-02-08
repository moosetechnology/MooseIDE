"
todo
"
Class {
	#name : #MiCoUsageMapSettingsPresenter,
	#superclass : #MiPresenter,
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
		add: 'Children block: ' asPresenter expand: false;
		add: #childrenTextInput;
		add: 'Children sort block: ' asPresenter expand: false;
		add: #sortOuterBoxTextInput;
		add: 'Inner box sort block: ' asPresenter expand: false;
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
		text: cls childrenBlock;
		whenSubmitDo: [ :text | cls childrenBlock: text ];
		yourself.
	sortOuterBoxTextInput := self newCode
		text: cls outerBoxSortBlock;
		whenSubmitDo: [ :text | cls outerBoxSortBlock: text ];
		yourself.
	sortInnerBoxTextInput := self newCode
		text: cls innerBoxSortBlock;
		whenSubmitDo: [ :text | cls innerBoxSortBlock: text ];
		yourself.
	button := self newButton
		label: 'Apply';
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
