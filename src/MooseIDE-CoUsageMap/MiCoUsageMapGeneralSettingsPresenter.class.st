"
used to display basic settings, like threshold, height of the inner box of co usage map
"
Class {
	#name : 'MiCoUsageMapGeneralSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'threshold',
		'innerBoxHeight',
		'innerBoxWidthScale',
		'rangeInnerWidth',
		'coUsageMap',
		'blockSettings',
		'settings'
	],
	#category : 'MooseIDE-CoUsageMap-Browser',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiCoUsageMapGeneralSettingsPresenter class >> preferredExtent [

	^ 900 @ 880
]

{ #category : 'initialization' }
MiCoUsageMapGeneralSettingsPresenter >> connectPresenters [

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
	innerBoxHeight 
		model: settings ;
		get: #innerBoxHeight;
		set: #innerBoxHeight:;
		range: (2 to: 50).
	rangeInnerWidth
		model: settings ;
		get: #innerBoxRange;
		set: #innerBoxRange:;
		range: (5 to: 100)
]

{ #category : 'layout' }
MiCoUsageMapGeneralSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: 'Threshold percent per group' asPresenter expand: false;
		add: #threshold expand: false;
		add: 'Inner box height' asPresenter expand: false;
		add: #innerBoxHeight expand: false;
		add: 'Inner box width scale' asPresenter expand: false;
		add: #innerBoxWidthScale expand: false;
		add: 'Range for inner boxes' asPresenter expand: false;
		add: #rangeInnerWidth expand: false;
		add: blockSettings ;
		yourself
]

{ #category : 'initialization' }
MiCoUsageMapGeneralSettingsPresenter >> initializePresenters [
	threshold := self instantiate: MiCoSliderPresenter.
	innerBoxHeight := self instantiate: MiCoSliderPresenter.
	innerBoxWidthScale := self newDropList.
	rangeInnerWidth := self instantiate: MiCoDualSliderPresenter.

	blockSettings := self instantiate: MiCoUsageMapBlockSettingsPresenter
]

{ #category : 'accessing' }
MiCoUsageMapGeneralSettingsPresenter >> settings [

	^settings
]

{ #category : 'accessing' }
MiCoUsageMapGeneralSettingsPresenter >> settings: anObject [

	settings := anObject.
	self connectPresenters.
	blockSettings connectPresenters.
]
