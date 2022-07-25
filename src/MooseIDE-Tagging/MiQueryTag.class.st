Class {
	#name : #MiQueryTag,
	#superclass : #MiDynamicTag,
	#category : #'MooseIDE-Tagging-DynamicTags'
}

{ #category : #testing }
MiQueryTag >> isApplicableTo: anObject [

	"The query should accept one parameter (anObject) and return a boolean."

	^ (evaluatingObject runOn: anObject asMooseGroup) isNotEmpty
]

{ #category : #accessing }
MiQueryTag >> label [
	"returns label for printing in intent page"
	^ String streamContents: [ :aStream | 
		  self query storeWithParentsOn: aStream ]
]

{ #category : #'as yet unclassified' }
MiQueryTag >> typeOfEvaluatingObject [
"returns the class needed for evaluating objects"
	^ FQAbstractQuery
]
