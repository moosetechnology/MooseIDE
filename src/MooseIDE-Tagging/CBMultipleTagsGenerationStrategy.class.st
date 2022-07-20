Class {
	#name : #CBMultipleTagsGenerationStrategy,
	#superclass : #CBGenerationStrategy,
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #'as yet unclassified' }
CBMultipleTagsGenerationStrategy >> createTagFor: aCondition [
	^ MiCriticDynamicTag new 
		name: aCondition name;
		description: aCondition summary;
		rule: aCondition.
]
