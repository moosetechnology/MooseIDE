Class {
	#name : #ContinuousQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'property',
		'bounds',
		'comparator',
		'color'
	],
	#category : #'MooseIDE-Tagging-TagBuilder'
}

{ #category : #accessing }
ContinuousQueryBuilder >> bounds [

	^ bounds
]

{ #category : #accessing }
ContinuousQueryBuilder >> bounds: anObject [

	bounds := anObject
]

{ #category : #'as yet unclassified' }
ContinuousQueryBuilder >> buildSelectBlockOfIndex: anInt [

	^ Smalltalk compiler evaluate: '[ :entity | entity ' , property, comparator, (bounds at: anInt) asString, ']'
]

{ #category : #accessing }
ContinuousQueryBuilder >> color [

	^ color
]

{ #category : #accessing }
ContinuousQueryBuilder >> color: anObject [

	color := anObject
]

{ #category : #accessing }
ContinuousQueryBuilder >> comparator [

	^ comparator
]

{ #category : #accessing }
ContinuousQueryBuilder >> comparator: anObject [

	comparator := anObject
]

{ #category : #accessing }
ContinuousQueryBuilder >> property [

	^ property
]

{ #category : #accessing }
ContinuousQueryBuilder >> property: anObject [

	property := anObject
]
