Class {
	#name : #MiCriticTag,
	#superclass : #MiDynamicTag,
	#instVars : [
		'rule'
	],
	#category : #'MooseIDE-Tagging-DynamicTags'
}

{ #category : #testing }
MiCriticTag >> isApplicableTo: anObject [

	"The query should accept one parameter (anObject) and return a boolean."

	(evaluatingObject runUpTree: anObject asMooseGroup). 
	^ evaluatingObject violations isNotEmpty
]

{ #category : #accessing }
MiCriticTag >> label [
"returns label for printing in intent page"
	^ self name
]

{ #category : #'as yet unclassified' }
MiCriticTag >> typeOfEvaluatingObject [
"returns the class needed for evaluating objects"
	^ FamixCBCondition
]
