Class {
	#name : #MiDynamicTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'color',
		'description',
		'category',
		'evaluatingObject'
	],
	#category : #'MooseIDE-Tagging-DynamicTags'
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

{ #category : #accessing }
MiDynamicTag >> evaluatingObject [

	^ evaluatingObject
]

{ #category : #accessing }
MiDynamicTag >> evaluatingObject: anObject [

	(anObject class inheritsFromOrEqualTo: self typeOfEvaluatingObject) ifFalse: [ self error: IncorrectTypeOfEvaluatingObject signal ].
	evaluatingObject := anObject
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

{ #category : #'as yet unclassified' }
MiDynamicTag >> typeOfEvaluatingObject [
"returns the class needed for evaluating objects"
	^ self subclassResponsibility
]
