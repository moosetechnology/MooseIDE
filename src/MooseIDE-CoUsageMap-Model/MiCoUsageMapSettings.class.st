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
