"
Abstract strategy to generate tags using MooseCritics.
"
Class {
	#name : #CBGenerationStrategy,
	#superclass : #GenerationStrategy,
	#instVars : [
		'rule'
	],
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #accessing }
CBGenerationStrategy >> rule [

	^ rule
]

{ #category : #accessing }
CBGenerationStrategy >> rule: anObject [

	rule := anObject
]
