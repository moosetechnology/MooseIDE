Class {
	#name : #GradualTagsGenerationStrategy,
	#superclass : #GenerationStrategy,
	#instVars : [
		'colors'
	],
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #accessing }
GradualTagsGenerationStrategy class >> colorPalette [

	^ RSColorPalette sequential ylorrd9
]

{ #category : #public }
GradualTagsGenerationStrategy >> assignColor [

	colors ifEmpty: [ 
		colors := self class colorPalette range asOrderedCollection ].
	^ colors removeFirst
]

{ #category : #initialization }
GradualTagsGenerationStrategy >> createCriticTagFor: anEvaluatingObject [
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> createQueryTagFor: anEvaluatingObject [

	^ MiQueryTag new
		  name: anEvaluatingObject name;
		  evaluatingObject: anEvaluatingObject;
		  color: self assignColor
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateQueryTags: anObject [
	
	^ anObject collect: [ :query | self createQueryTagFor: query ]
]

{ #category : #'as yet unclassified' }
GradualTagsGenerationStrategy >> generateTags: anObject [
	
	tagClass = MiQueryTag ifTrue: [ ^ self generateQueryTags: anObject ]
]

{ #category : #initialization }
GradualTagsGenerationStrategy >> initialize [ 

	super initialize.
	colors := self class colorPalette range asOrderedCollection
]
