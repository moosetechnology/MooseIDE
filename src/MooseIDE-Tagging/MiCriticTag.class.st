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

	(rule runUpTree: anObject asMooseGroup). 
	^ rule violations isNotEmpty
]

{ #category : #accessing }
MiCriticTag >> label [
"returns label for printing in intent page"
	^ self name
]

{ #category : #accessing }
MiCriticTag >> rule [

	^ rule
]

{ #category : #accessing }
MiCriticTag >> rule: anObject [

	rule := anObject
]
