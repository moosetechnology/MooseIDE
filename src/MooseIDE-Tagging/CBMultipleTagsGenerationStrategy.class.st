Class {
	#name : #CBMultipleTagsGenerationStrategy,
	#superclass : #CBGenerationStrategy,
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #'as yet unclassified' }
CBMultipleTagsGenerationStrategy >> createTagFor: aCondition [

	^ MiCriticTag new
		  name: aCondition name;
		  description: aCondition summary;
		  rule: aCondition;
		  color: (Color
				   r: 26
				   g: 188
				   b: 156
				   range: 255)
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
