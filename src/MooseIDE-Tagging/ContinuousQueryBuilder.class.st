Class {
	#name : #ContinuousQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'property',
		'bounds',
		'colors',
		'chosenPalette',
		'type'
	],
	#category : #'MooseIDE-Tagging-TagBuilder'
}

{ #category : #public }
ContinuousQueryBuilder >> assignColor [

	colors ifEmpty: [ 
		colors := chosenPalette copy asOrderedCollection ].
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
ContinuousQueryBuilder >> buildDictForBound: anInt andComparator: aString [

	| dict |
	dict := Dictionary new.
	dict
		at: 'name'
		put: (self buildNameForBound: anInt andComparator: aString).
	dict at: 'type' put: type.
	dict
		at: 'query'
		put: (self buildSelectBlockForBound: anInt andComparator: aString).
	dict at: 'color' put: self assignColor.
	^ dict
]

{ #category : #'as yet unclassified' }
ContinuousQueryBuilder >> buildNameForBound: anInt andComparator: aString [
	
	^ property, ' ', aString, ' ', anInt asString.
]

{ #category : #'as yet unclassified' }
ContinuousQueryBuilder >> buildSelectBlockForBound: anInt andComparator: aString [
"build query part of the tag, using the bound at index anInt"
	^ Smalltalk compiler evaluate: '[ :entity | entity ' , property, aString, anInt asString, ']'
]

{ #category : #'model-building' }
ContinuousQueryBuilder >> buildTags [

	| tags index |
	index := 1.
	tags := (bounds collect: [ :bound | 
		        self buildDictForBound: bound andComparator: '<=' ]) asOrderedCollection.
	tags add: (self buildDictForBound: bounds last andComparator: '>').
	^ tags
]

{ #category : #accessing }
ContinuousQueryBuilder >> chosenPalette [

	^ chosenPalette
]

{ #category : #accessing }
ContinuousQueryBuilder >> chosenPalette: anObject [

	chosenPalette := anObject
]

{ #category : #accessing }
ContinuousQueryBuilder >> colors [

	^ colors
]

{ #category : #accessing }
ContinuousQueryBuilder >> colors: anObject [

	^ colors := anObject
]

{ #category : #initialization }
ContinuousQueryBuilder >> initialize [
	
	super initialize.
	colors := OrderedCollection new
]

{ #category : #accessing }
ContinuousQueryBuilder >> property [

	^ property
]

{ #category : #accessing }
ContinuousQueryBuilder >> property: anObject [

	property := anObject
]

{ #category : #accessing }
ContinuousQueryBuilder >> type [

	^ type
]

{ #category : #accessing }
ContinuousQueryBuilder >> type: anObject [

	type := anObject
]
