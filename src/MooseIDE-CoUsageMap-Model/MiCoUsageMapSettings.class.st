"
TODO
"
Class {
	#name : #MiCoUsageMapSettings,
	#superclass : #Object,
	#classInstVars : [
		'innerBoxSize',
		'threshold75'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #private }
MiCoUsageMapSettings class >> browserDo: aBlock [
	Smalltalk globals 
		at: #MiCoUsageMapMooseBuilder
		ifPresent: [ :cls | cls allInstancesDo: aBlock ]
		ifAbsent: [ "nothing" ]
]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettings01On: aBuilder [
	<systemsettings>
	(aBuilder group: #moose)
		label: 'Moose';
		description: 'All settings concerned with moose browsers'
]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettings02On: aBuilder [
	<systemsettings>
	(aBuilder group: #CoUsageMap)
		parent: #moose;
		label: 'Co Usage Map';
		description: 'Alls settings concerned with co usage map browser'
]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingsInnerSizeOn: aBuilder [
	<systemsettings>
	(aBuilder range: #innerBoxSize)
		parent: #CoUsageMap;
		target: self;
		label: 'Inner box size';
		description: 'Will change the size of the inner box for co usage map visualization';
		default: self defaultInnerBoxSize;
		range: (2 to: 50)

]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingsThresholdOn: aBuilder [
	<systemsettings>
	(aBuilder range: #threshold75PercentGroup)
		parent: #CoUsageMap;
		target: self;
		label: 'Threshold 75 percent per group';
		description: 'This threshold is used by automatic color methods in the CoUsageMapBrowser.
When the container has several attributes of different colors, the color is chosen from the group that exceeds the threshold in relation to the size of the attributes.';
		default: self defaultThreshold75;
		range: (10 to: 100)

]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxSize [
	^ 5
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultThreshold75 [
	^ 75
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSize [
	^ innerBoxSize ifNil: [ self defaultInnerBoxSize ].
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSize: aNumber [
	innerBoxSize := aNumber.
	self browserDo: [ :b | b innerBoxSize: aNumber ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup [
	^ threshold75 ifNil: [ self defaultThreshold75 ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup: aNumber [
	threshold75 := aNumber.
	self browserDo: [ :b | b threshold75: threshold75 ]
]
