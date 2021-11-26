"
I represent a concept with a name and I can check dynamicaly if I apply to some object.
I have an optional color to display the objects to which I apply.
"
Class {
	#name : #MiDynamicTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'query',
		'color'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #accessing }
MiDynamicTag >> color [

	^ color
]

{ #category : #accessing }
MiDynamicTag >> color: anObject [

	color := anObject
]

{ #category : #testing }
MiDynamicTag >> isApplicableTo: anObject [

	"The query should accept one parameter (anObject) and return a boolean."
	self flag: 'should be more discriminent on the error that we want to catch.'.
	^ [ query value: anObject ] onErrorDo: [ ^ false ]
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
MiDynamicTag >> query [

	^ query
]

{ #category : #accessing }
MiDynamicTag >> query: anObject [

	query := anObject
]
