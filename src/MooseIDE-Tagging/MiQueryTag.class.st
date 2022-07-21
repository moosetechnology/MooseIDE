Class {
	#name : #MiQueryTag,
	#superclass : #MiDynamicTag,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #testing }
MiQueryTag >> isApplicableTo: anObject [

	"The query should accept one parameter (anObject) and return a boolean."

	^ (query runOn: anObject asMooseGroup) isNotEmpty
]

{ #category : #accessing }
MiQueryTag >> query [

	^ query
]

{ #category : #accessing }
MiQueryTag >> query: anObject [

	query := anObject
]
