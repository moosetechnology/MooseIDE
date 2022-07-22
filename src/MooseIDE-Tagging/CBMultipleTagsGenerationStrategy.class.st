Class {
	#name : #CBMultipleTagsGenerationStrategy,
	#superclass : #CBGenerationStrategy,
	#instVars : [
		'colors',
		'currentColor'
	],
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #accessing }
CBMultipleTagsGenerationStrategy class >> colorPalette [ 

	^ RSQualitativeColorPalette new accent8.
]

{ #category : #'as yet unclassified' }
CBMultipleTagsGenerationStrategy >> createTagFor: aCondition [

	^ MiCriticTag new
		  name: aCondition name;
		  description: aCondition summary;
		  rule: aCondition;
		  color: (colors remove: colors first ifAbsent: [ 
					   colors := self class colorPalette range.
					   colors remove: colors first ])
]

{ #category : #'as yet unclassified' }
CBMultipleTagsGenerationStrategy >> generateTags: anObject [

	| tags |
	tags := OrderedCollection new.
	"anObject class = FamixCBCondition
		ifTrue: [ tags add: (self createTagFor: anObject) ]
		ifFalse: [ 
			anObject getAllConditions do: [ :cond | 
				tags add: (self createTagFor: cond) ] ]."
	anObject do: [ :cond | tags add: (self createTagFor: cond) ].
	 ^ tags
]

{ #category : #initialization }
CBMultipleTagsGenerationStrategy >> initialize [ 

	super initialize.
	colors := self class colorPalette range asOrderedCollection
]
