"
TODO
"
Class {
	#name : #MiCoUsageMapMooseBuilder,
	#superclass : #MiCoUsageMapBuilder,
	#instVars : [
		'application'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #accessing }
MiCoUsageMapMooseBuilder >> application [

	^ application
]

{ #category : #accessing }
MiCoUsageMapMooseBuilder >> application: anObject [

	application := anObject
]

{ #category : #default }
MiCoUsageMapMooseBuilder >> defaultTester [
	^ MiCoMooseMethodAttributeTester new
]

{ #category : #initialization }
MiCoUsageMapMooseBuilder >> initializeAttributes [
	| tags |
	miAttributes := attributes collect: [ :att |
		tags := att allTagAssociations collect: [ :asso | asso tag ].
		MiCoAttribute new
			name: att name;
			rawObject: att;
			tag: (tags ifEmpty: [ nil ] ifNotEmpty: [ tags anyOne ]) ;
			application: self application;
			yourself ] as: OrderedCollection
]

{ #category : #initialization }
MiCoUsageMapMooseBuilder >> initializeMethods [
	| tags |
	miMethods := methods collect: [ :met |
		tags := met allTagAssociations collect: [ :asso | asso tag ].
		MiCoMethod new
			name: met name;
			rawObject: met;
			tag: (tags ifEmpty: [ nil ] ifNotEmpty: [ tags anyOne ]) ;
			application: self application;
			yourself ] as: OrderedCollection.
]
