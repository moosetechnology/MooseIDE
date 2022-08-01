Class {
	#name : #ContinuousQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'property',
		'bounds',
		'comparator',
		'colors'
	],
	#category : #'MooseIDE-Tagging-TagBuilder'
}

{ #category : #accessing }
ContinuousQueryBuilder class >> colorPalette [

	^ RSColorPalette sequential gnbu9
]

{ #category : #public }
ContinuousQueryBuilder >> assignColor [

	colors ifEmpty: [ 
		colors := self class colorPalette range asOrderedCollection ].
	^ colors removeFirst
]

{ #category : #accessing }
ContinuousQueryBuilder >> bounds [

	^ bounds
]

{ #category : #accessing }
ContinuousQueryBuilder >> bounds: anObject [

	bounds := anObject
]

{ #category : #'as yet unclassified' }
ContinuousQueryBuilder >> buildNameForIndex: anInt [
	
	^ property, ' ', comparator, ' ', (bounds at: anInt) asString.
]

{ #category : #'as yet unclassified' }
ContinuousQueryBuilder >> buildSelectBlockForIndex: anInt [
"build query part of the tag, using the bound at index anInt"
	^ Smalltalk compiler evaluate: '[ :entity | entity ' , property, comparator, (bounds at: anInt) asString, ']'
]

{ #category : #'model-building' }
ContinuousQueryBuilder >> buildTags [

	| tags index |
	index := 1.
	tags := bounds collect: [ :bound | 
		        | dict |
		        dict := Dictionary new.
		        dict at: 'name' put: (self buildNameForIndex: index).
		        dict at: 'query' put: (self buildSelectBlockForIndex: index).
		        dict at: 'color' put: self assignColor.
		        index := index + 1.
		        dict ].
	^ tags
]

{ #category : #accessing }
ContinuousQueryBuilder >> colors [

	^ colors
]

{ #category : #accessing }
ContinuousQueryBuilder >> colors: anObject [

	^ colors := anObject
]

{ #category : #accessing }
ContinuousQueryBuilder >> comparator [

	^ comparator
]

{ #category : #accessing }
ContinuousQueryBuilder >> comparator: anObject [

	comparator := anObject
]

{ #category : #initialization }
ContinuousQueryBuilder >> initialize [
	
	super initialize.
	colors := self class colorPalette range asOrderedCollection
]

{ #category : #accessing }
ContinuousQueryBuilder >> property [

	^ property
]

{ #category : #accessing }
ContinuousQueryBuilder >> property: anObject [

	property := anObject
]
