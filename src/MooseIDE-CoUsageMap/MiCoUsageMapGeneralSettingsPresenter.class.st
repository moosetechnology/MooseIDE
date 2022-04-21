"
used to display basic settings, like threshold, height of the inner box of co usage map
"
Class {
	#name : #MiCoUsageMapGeneralSettingsPresenter,
	#superclass : #MiCoUsageMapAbstractSettingsPresenter,
	#instVars : [
		'threshold',
		'innerBoxHeight',
		'innerBoxWidthScale',
		'rangeInnerWidth',
		'coUsageMap'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #layout }
MiCoUsageMapGeneralSettingsPresenter class >> defaultLayout [
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
		yourself
]

{ #category : #initialization }
MiCoUsageMapGeneralSettingsPresenter >> connectPresenters [
	| set |
	set := self settings.
	set ifNil: [ ^ self ].
	innerBoxWidthScale items: #(linear symlog).
	threshold 
		model: set;
		get: #threshold75PercentGroup;
		set: #threshold75PercentGroup:;
		range: (10 to: 100).
	innerBoxHeight 
		model: set;
		get: #innerBoxHeight;
		set: #innerBoxHeight:;
		range: (2 to: 50).
	
		
]

{ #category : #initialization }
MiCoUsageMapGeneralSettingsPresenter >> initializePresenters [
	threshold := self instantiate: MiCoSliderPresenter.
	innerBoxHeight := self instantiate: MiCoSliderPresenter.
	innerBoxWidthScale := self newDropList.
	rangeInnerWidth := self instantiate: MiCoDualSliderPresenter.
]
