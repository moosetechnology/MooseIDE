"
Abstract strategy used by the TagGeneratorPage to create tags.

Public API and key messages
- generateTags: anObject
"
Class {
	#name : #GenerationStrategy,
	#superclass : #Object,
	#instVars : [
		'category'
	],
	#category : #'MooseIDE-Tagging-Generation'
}

{ #category : #accessing }
GenerationStrategy >> category [

	^ category
]

{ #category : #accessing }
GenerationStrategy >> category: anObject [

	category := anObject
]

{ #category : #'as yet unclassified' }
GenerationStrategy >> generateTags: anObject [
	
	^ self subclassResponsibility
]
