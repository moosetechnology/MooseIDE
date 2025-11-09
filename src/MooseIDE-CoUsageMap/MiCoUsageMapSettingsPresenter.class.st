"
used to display basic settings, like threshold, height of the inner box of co usage map
"
Class {
	#name : 'MiCoUsageMapSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'threshold',
		'innerBoxWidthScale',
		'rangeInnerWidth',
		'settings',
		'lstInnerBoxExtractor',
		'specModel'
	],
	#category : 'MooseIDE-CoUsageMap-Settings',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiCoUsageMapSettingsPresenter class >> preferredExtent [

	^ 450 @ 280
]

{ #category : 'initialization' }
MiCoUsageMapSettingsPresenter >> connectPresenters [

	settings ifNil: [ ^ self ].

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

	lstInnerBoxExtractor
		items: MiCoChildrenBoxAbstractExtractor subclasses ;
		selectItem: settings innerBoxExtractor ;
		display: [ :i | i menuItemName ];
		whenSelectedItemChangedDo: [:item | settings innerBoxExtractor: item ].

]

{ #category : 'layout' }
MiCoUsageMapSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: 'Threshold percent per group' asPresenter expand: false;
		add: #threshold expand: false;
		add: 'Inner box width scale' asPresenter expand: false;
		add: #innerBoxWidthScale expand: false;
		add: 'Range for inner boxes' asPresenter expand: false;
		add: #rangeInnerWidth expand: false;
		add: 'Children block:' asPresenter expand: false ;
		add: lstInnerBoxExtractor asPresenter expand: false ;

		yourself
]

{ #category : 'initialization' }
MiCoUsageMapSettingsPresenter >> initializeDialogWindow: aDialog [

	aDialog
		addButton: 'Cancel' do: [ :dialog | dialog close ] ;
		addButton: 'Apply' do: [ :dialog |
			settings innerBoxExtractor: lstInnerBoxExtractor selectedItem.
			specModel refreshVisualization.
			dialog close ]
]

{ #category : 'initialization' }
MiCoUsageMapSettingsPresenter >> initializePresenters [
	threshold := self instantiate: MiCoSliderPresenter.
	innerBoxWidthScale := self newDropList.
	rangeInnerWidth := self instantiate: MiCoDualSliderPresenter.
	lstInnerBoxExtractor := self newDropList.

]

{ #category : 'accessing' }
MiCoUsageMapSettingsPresenter >> settings [

	^settings
]

{ #category : 'accessing' }
MiCoUsageMapSettingsPresenter >> settings: anObject [

	settings := anObject.
	self connectPresenters
]

{ #category : 'accessing' }
MiCoUsageMapSettingsPresenter >> specModel: anObject [

	specModel := anObject 
]
