"
This strategy uses the tag of the bigger group, categorized by tag.
Also uses a threshold from MiCoUsageMapSettings
"
Class {
	#name : #MiCo75PercentageMarkStrategy,
	#superclass : #MiCoMarkStrategy,
	#instVars : [
		'threshold'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #hooks }
MiCo75PercentageMarkStrategy >> computeTag [
	| biggerGroup tag |
	biggerGroup := #().
	tag := nil.
	self groupsByTag keysAndValuesDo: [ :groupTag :group | 
		group size > biggerGroup size ifTrue: [
			tag := groupTag.
			biggerGroup := group ] ].
	^ (biggerGroup size / self method usedAttributes size) > self threshold 
		ifTrue: [ tag ]
		ifFalse: [ nil ]
]

{ #category : #initialization }
MiCo75PercentageMarkStrategy >> initialize [
	super initialize.
	self threshold: MiCoUsageMapSettings threshold75PercentGroup/100.0
]

{ #category : #hooks }
MiCo75PercentageMarkStrategy >> order [
	^ 1
]

{ #category : #accessing }
MiCo75PercentageMarkStrategy >> threshold [
	^ threshold
]

{ #category : #accessing }
MiCo75PercentageMarkStrategy >> threshold: aNumber [
	self assert: (aNumber between: 0 and: 1) description: 'Threshold must be between 0 and 1'.
	threshold := aNumber
]
