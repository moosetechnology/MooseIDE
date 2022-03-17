"
Custom CoUsageMap adapted to work with moose entities and browsers 
"
Class {
	#name : #MiCoUsageMapMooseBuilder,
	#superclass : #MiCoUsageMapBuilder,
	#instVars : [
		'application',
		'visualization'
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
	^ MiCoFromSettingsMethodAttributeTester new
]

{ #category : #'instance creation' }
MiCoUsageMapMooseBuilder >> newAttributeFor: anObject [
	| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ].
	^ MiCoAttribute new
		name: anObject name;
		rawObject: anObject;
		tag: tags;
		application: self application;
		yourself
]

{ #category : #'instance creation' }
MiCoUsageMapMooseBuilder >> newMethodFor: anObject [
	| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ].
	^ MiCoMethod new
		name: anObject name;
		rawObject: anObject;
		tag: tags;
		application: self application;
		yourself
]

{ #category : #update }
MiCoUsageMapMooseBuilder >> updateLegend [
	visualization ifNil: [ ^ self ].
	visualization updateLegend
]

{ #category : #accessing }
MiCoUsageMapMooseBuilder >> visualization [
	^ visualization
]

{ #category : #accessing }
MiCoUsageMapMooseBuilder >> visualization: aMiCoUsageMapVisualization [
	visualization := aMiCoUsageMapVisualization
]
