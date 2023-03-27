"
A model for the CoUsageMap browser
"
Class {
	#name : #MiCoUsageMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'coUsageMap',
		'collectionModel',
		'settings'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #accessing }
MiCoUsageMapModel >> collectionModel [

	^ collectionModel
]

{ #category : #accessing }
MiCoUsageMapModel >> collectionModel: anObject [

	collectionModel := anObject
]

{ #category : #accessing }
MiCoUsageMapModel >> entities [
	^collectionModel
]

{ #category : #actions }
MiCoUsageMapModel >> followEntity: aCollection [
	self collectionModel: aCollection.
	browser update
]

{ #category : #accessing }
MiCoUsageMapModel >> miSelectedItem [
	self flag: 'Should be the attribute currently selected ?'.
	^ collectionModel
]
