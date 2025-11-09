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

{ #category : 'accessing - computed' }
MiCoUsageMapSettings >> childrenBlockCompiled [
	^ self compiledBlock: self childrenBlockText onError: self defaultChildrenBlockText
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> childrenBlockText [
	^ self propertiesMap at: #childrenBlockText ifAbsent: [ self defaultChildrenBlockText ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> childrenBlockText: aString [
	self propertiesMap at: #childrenBlockText put: aString
]

{ #category : 'accessing - computed' }
MiCoUsageMapSettings >> compiledBlock: aString onError: defaultString [
	| compiler |
	compiler := Smalltalk compiler.
	^ [ compiler evaluate: aString ]
	on: Error
	do: [ :ex | compiler evaluate: defaultString ]
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultChildrenBlockText [

	^ '"This code should return all the inner entities for one of the big boxes (outer entities).
	It is for attributes (inner)) accessed by methods (outer), but you can change it"
[ :outerEntity |
	outerEntity isContainerEntity
	ifTrue: [
		outerEntity accesses
			collect: [ :access | access variable ]
			thenSelect: [ :var | var isAttribute ]
	]
	ifFalse: [ #() ]
]'
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
		removeKey: #childrenBlockText ifAbsent: []
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
