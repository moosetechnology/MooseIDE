"
Presenter created to edit the children block, outer boxes sort block, and inner boxes sort block.
This interacts directly with MiCoUsageMapSettings
"
Class {
	#name : 'MiCoUsageMapBlockSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'childrenTextInput',
		'sortOuterBoxTextInput',
		'sortInnerBoxTextInput',
		'resetButton',
		'applyButton',
		'closeButton'
	],
	#category : 'MooseIDE-CoUsageMap-Browser',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Browser'
}

{ #category : 'accessing - private tests' }
MiCoUsageMapBlockSettingsPresenter >> applyButton [

	^applyButton
]

{ #category : 'layout' }
MiCoUsageMapBlockSettingsPresenter >> buttonRowLayout [

	^SpBoxLayout newLeftToRight
		hAlignCenter;
		borderWidth: 5;
		addLast: (SpBoxLayout newLeftToRight
			add: applyButton ;
			add: resetButton ;
			add: closeButton ;
			yourself)
		expand: false;
		yourself
]

{ #category : 'accessing - private tests' }
MiCoUsageMapBlockSettingsPresenter >> childrenTextInput [

	^childrenTextInput
]

{ #category : 'accessing - private tests' }
MiCoUsageMapBlockSettingsPresenter >> closeButton [

	^closeButton
]

{ #category : 'initialization' }
MiCoUsageMapBlockSettingsPresenter >> closeWindow [

	self delete
]

{ #category : 'initialization' }
MiCoUsageMapBlockSettingsPresenter >> connectPresenters [

	self settings ifNil: [ ^ self ].

	childrenTextInput
		text: self settings childrenBlockText ;
		whenSubmitDo: [ :text | self settings childrenBlockText: text ].

	sortOuterBoxTextInput
		text: self settings outerBoxSortBlockText ;
		whenSubmitDo: [ :text | self settings outerBoxSortBlockText: text ].

	sortInnerBoxTextInput
		text: self settings innerBoxSortBlockText ;
		whenSubmitDo: [ :text | self settings innerBoxSortBlockText: text ].

	applyButton action: [ 
		childrenTextInput triggerSubmitAction.
		sortOuterBoxTextInput triggerSubmitAction.
		sortInnerBoxTextInput triggerSubmitAction.
		self closeWindow 
	].

	resetButton action: [ | set |
		set := self settings.
		set resetText.
		childrenTextInput text: set childrenBlockText.
		sortOuterBoxTextInput text: set outerBoxSortBlockText.
		sortInnerBoxTextInput text: set innerBoxSortBlockText.
	].
	closeButton action: [
		self closeWindow 
	].
]

{ #category : 'layout' }
MiCoUsageMapBlockSettingsPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		spacing: 3;

		add: 'Children block:' asPresenter expand: false ;
		add: childrenTextInput height: 200 ;

		add: 'Outer box sort block:' asPresenter expand: false ;
		add: sortOuterBoxTextInput height: 170 ;

		add: 'Inner box sort block:' asPresenter expand: false ;
		add: sortInnerBoxTextInput height: 170 ;

		add: self buttonRowLayout
		expand: false;

		yourself
]

{ #category : 'initialization' }
MiCoUsageMapBlockSettingsPresenter >> initializeButtons [

	applyButton := self newButton
		label: 'Apply all'.
	resetButton := self newButton
		label: 'Reset text fields'.
	closeButton := self newButton
		label: 'Close'.

]

{ #category : 'initialization' }
MiCoUsageMapBlockSettingsPresenter >> initializePresenters [

	childrenTextInput := self newCode.
	sortOuterBoxTextInput := self newCode.
	sortInnerBoxTextInput := self newCode.

	self initializeButtons
]

{ #category : 'initialization' }
MiCoUsageMapBlockSettingsPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter 
		initialExtent: 500@700;
		title: 'Blocks Settings - Co Usage Map'
]

{ #category : 'accessing - private tests' }
MiCoUsageMapBlockSettingsPresenter >> resetButton [

	^resetButton
]

{ #category : 'accessing' }
MiCoUsageMapBlockSettingsPresenter >> settings [
	^ owner settings
]

{ #category : 'accessing' }
MiCoUsageMapBlockSettingsPresenter >> settings: anObject [
	owner settings: anObject
]

{ #category : 'accessing - private tests' }
MiCoUsageMapBlockSettingsPresenter >> sortInnerBoxTextInput [

	^sortInnerBoxTextInput
]

{ #category : 'accessing - private tests' }
MiCoUsageMapBlockSettingsPresenter >> sortOuterBoxTextInput [

	^sortOuterBoxTextInput
]
