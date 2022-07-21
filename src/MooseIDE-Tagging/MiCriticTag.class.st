Class {
	#name : #MiCriticTag,
	#superclass : #MiDynamicTag,
	#instVars : [
		'rule'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #testing }
MiCriticTag >> isApplicableTo: anObject [

	"The query should accept one parameter (anObject) and return a boolean."

	^ (rule runUpTree: anObject asMooseGroup) isNotEmpty
]

{ #category : #accessing }
MiCriticTag >> rule [

	^ rule
]

{ #category : #accessing }
MiCriticTag >> rule: anObject [

	rule := anObject
]
