Class {
	#name : #MultipleTagsGenerationStrategy,
	#superclass : #GenerationStrategy,
	#instVars : [
		'colors',
		'currentColor'
	],
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #accessing }
MultipleTagsGenerationStrategy class >> colorPalette [ 

	^ RSQualitativeColorPalette new accent8.
]

{ #category : #public }
MultipleTagsGenerationStrategy >> assignColor [

	colors ifEmpty: [ 
		colors := self class colorPalette range asOrderedCollection ].
	^ colors removeFirst
]

{ #category : #'as yet unclassified' }
MultipleTagsGenerationStrategy >> createTagFor: anEvaluatingObject [

	^ self tagClass new
		  name: anEvaluatingObject name;
		  description: (anEvaluatingObject class = FamixCBCondition
				   ifTrue: [ anEvaluatingObject summary ]
				   ifFalse: [ '' ]);
		  evaluatingObject: anEvaluatingObject;
		  color: self assignColor
]

{ #category : #'as yet unclassified' }
MultipleTagsGenerationStrategy >> generateTags: anObject [

	| tags |
	tags := OrderedCollection new.
	anObject collect: [ :cond | tags add: (self createTagFor: cond) ].
	 ^ tags
]

{ #category : #initialization }
MultipleTagsGenerationStrategy >> initialize [ 

	super initialize.
	colors := self class colorPalette range asOrderedCollection
]
