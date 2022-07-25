Class {
	#name : #MiDynamicTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'query',
		'color',
		'description',
		'category'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiDynamicTag >> category [

	^ category
]

{ #category : #accessing }
MiDynamicTag >> category: anObject [

	category := anObject
]

{ #category : #accessing }
MiDynamicTag >> color [

	^ color
]

{ #category : #accessing }
MiDynamicTag >> color: anObject [

	color := anObject
]

{ #category : #accessing }
MiDynamicTag >> description [

	^ description
]

{ #category : #accessing }
MiDynamicTag >> description: anObject [

	description := anObject
]

{ #category : #testing }
MiDynamicTag >> isApplicableTo: anObject [

	"The query should accept one parameter (anObject) and return a boolean."

	^ self subclassResponsibility
]

{ #category : #testing }
MiDynamicTag >> isIntent [

	^ true
]

{ #category : #accessing }
MiDynamicTag >> label [
"returns label for printing in intent page"
	^ self subclassResponsibility
]

{ #category : #accessing }
MiDynamicTag >> name [

	^ name
]

{ #category : #accessing }
MiDynamicTag >> name: anObject [

	name := anObject
]

{ #category : #accessing }
MiDynamicTag >> taggedEntities [

	^ #()
]
