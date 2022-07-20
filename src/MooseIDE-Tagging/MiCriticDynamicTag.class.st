Class {
	#name : #MiCriticDynamicTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'rule',
		'color',
		'description',
		'category'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiCriticDynamicTag >> category [

	^ category
]

{ #category : #accessing }
MiCriticDynamicTag >> category: anObject [

	category := anObject
]

{ #category : #accessing }
MiCriticDynamicTag >> color [

	^ color
]

{ #category : #accessing }
MiCriticDynamicTag >> color: anObject [

	color := anObject
]

{ #category : #accessing }
MiCriticDynamicTag >> description [

	^ description
]

{ #category : #accessing }
MiCriticDynamicTag >> description: anObject [

	description := anObject
]

{ #category : #testing }
MiCriticDynamicTag >> isApplicableTo: anObject [

	"The query should accept one parameter (anObject) and return a boolean."

	^ (rule runUpTree: anObject asMooseGroup) isNotEmpty
]

{ #category : #testing }
MiCriticDynamicTag >> isIntent [

	^ true
]

{ #category : #accessing }
MiCriticDynamicTag >> name [

	^ name
]

{ #category : #accessing }
MiCriticDynamicTag >> name: anObject [

	name := anObject
]

{ #category : #accessing }
MiCriticDynamicTag >> rule [

	^ rule
]

{ #category : #accessing }
MiCriticDynamicTag >> rule: anObject [

	rule := anObject
]
