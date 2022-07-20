"
Abstract strategy used by the TagGeneratorPage to create tags.

Public API and key messages
- generateTags: anObject
"
Class {
	#name : #GenerationStrategy,
	#superclass : #Object,
	#instVars : [
		'category',
		'name',
		'description',
		'color'
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

{ #category : #accessing }
GenerationStrategy >> color [

	^ color
]

{ #category : #accessing }
GenerationStrategy >> color: anObject [

	color := anObject
]

{ #category : #accessing }
GenerationStrategy >> description [

	^ description
]

{ #category : #accessing }
GenerationStrategy >> description: anObject [

	description := anObject
]

{ #category : #'as yet unclassified' }
GenerationStrategy >> generateTags: anObject [
	
	^ self subclassResponsibility
]

{ #category : #accessing }
GenerationStrategy >> name [

	^ name
]

{ #category : #accessing }
GenerationStrategy >> name: anObject [

	name := anObject
]
