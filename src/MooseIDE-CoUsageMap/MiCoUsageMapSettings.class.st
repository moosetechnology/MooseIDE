"
I am a singleton, I store global values for settings used by CoUsageMapBuilder
"
Class {
	#name : 'MiCoUsageMapSettings',
	#superclass : 'Object',
	#instVars : [
		'properties'
	],
	#category : 'MooseIDE-CoUsageMap-Settings',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Settings'
}

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultInnerBoxExtractor [

	^MiCoChildrenBoxAttributeAccessExtractor 
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultInnerBoxRange [
	^ #(5 100)
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultInnerBoxScaleType [
	^ #linear
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultThreshold75 [
	^ 75
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxExtractor [
	^ self propertiesMap at: #innerBoxExtractor ifAbsent: [ self defaultInnerBoxExtractor ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxExtractor: aString [
	self propertiesMap at: #innerBoxExtractor put: aString
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxRange [
	^ self propertiesMap at: #innerBoxRange ifAbsent: [ self defaultInnerBoxRange ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxRange: anInterval [
	self propertiesMap at: #innerBoxRange put: anInterval
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxScaleType [
	^ self propertiesMap at: #innerBoxScaleType ifAbsent: [ self defaultInnerBoxScaleType ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxScaleType: aString [
	self propertiesMap at: #innerBoxScaleType put: aString
]

{ #category : 'private' }
MiCoUsageMapSettings >> propertiesMap [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : 'class initialization' }
MiCoUsageMapSettings >> reset [
	properties := nil
]

{ #category : 'class initialization' }
MiCoUsageMapSettings >> resetText [
	<script>
	self propertiesMap
		removeKey: #innerBoxExtractor ifAbsent: []
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> scaleTypes [
	^ #(linear symlog)
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> threshold75PercentGroup [
	^ self propertiesMap at: #threshold75 ifAbsent: [ self defaultThreshold75 ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> threshold75PercentGroup: aNumber [
	self propertiesMap at: #threshold75 put: aNumber
]
