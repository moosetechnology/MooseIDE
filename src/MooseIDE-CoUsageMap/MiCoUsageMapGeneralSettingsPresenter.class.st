"
used to display basic settings, like threshold, height of the inner box of co usage map
"
Class {
	#name : 'MiCoUsageMapGeneralSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'threshold',
		'innerBoxWidthScale',
		'rangeInnerWidth',
		'settings',
		'childrenTextInput'
	],
	#category : 'MooseIDE-CoUsageMap-Settings',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiCoUsageMapGeneralSettingsPresenter class >> preferredExtent [

	^ 900 @ 450
]

{ #category : 'initialization' }
MiCoUsageMapGeneralSettingsPresenter >> connectPresenters [

	settings ifNil: [ ^ self ].

	"self onAccept: [ childrenTextInput triggerSubmitAction ]".

	innerBoxWidthScale 
		items: settings scaleTypes;
		selectItem: settings innerBoxScaleType;
		whenSelectedItemChangedDo: [:item | settings innerBoxScaleType: item ].
	
	threshold 
		model: settings  ;
		get: #threshold75PercentGroup;
		set: #threshold75PercentGroup:;
		range: (10 to: 100).

	rangeInnerWidth
		model: settings ;
		get: #innerBoxRange;
		set: #innerBoxRange:;
		range: (5 to: 100).

	childrenTextInput
		text: self settings childrenBlockText ;
		whenSubmitDo: [ :text | self settings childrenBlockText: text ].

]

{ #category : 'layout' }
MiCoUsageMapGeneralSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: 'Threshold percent per group' asPresenter expand: false;
		add: #threshold expand: false;
		add: 'Inner box width scale' asPresenter expand: false;
		add: #innerBoxWidthScale expand: false;
		add: 'Range for inner boxes' asPresenter expand: false;
		add: #rangeInnerWidth expand: false;
		add: 'Children block:' asPresenter expand: false ;
		add: childrenTextInput height: 200 ;

		yourself
]

{ #category : 'initialization' }
MiCoUsageMapGeneralSettingsPresenter >> initializeDialogWindow: aDialog [

	aDialog
		addButton: 'Cancel' do: [ :dialog | dialog close ] ;
		addButton: 'Apply' do: [ :dialog | childrenTextInput triggerSubmitAction. dialog close ]
]

{ #category : 'initialization' }
MiCoUsageMapGeneralSettingsPresenter >> initializePresenters [
	threshold := self instantiate: MiCoSliderPresenter.
	innerBoxWidthScale := self newDropList.
	rangeInnerWidth := self instantiate: MiCoDualSliderPresenter.
	childrenTextInput := self newCode.

]

{ #category : 'accessing' }
MiCoUsageMapGeneralSettingsPresenter >> settings [

	^settings
]

{ #category : 'accessing' }
MiCoUsageMapGeneralSettingsPresenter >> settings: anObject [

	settings := anObject.
	self connectPresenters
]
