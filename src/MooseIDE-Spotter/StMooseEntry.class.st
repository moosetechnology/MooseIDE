Class {
	#name : #StMooseEntry,
	#superclass : #StEntry,
	#category : #'MooseIDE-Spotter'
}

{ #category : #converting }
StMooseEntry >> asString [

	^ content mooseName
]

{ #category : #evaluating }
StMooseEntry >> doEvaluate [

	^ content inspect
]

{ #category : #accessing }
StMooseEntry >> iconName [

	^ #mooseIcon
]

{ #category : #accessing }
StMooseEntry >> label [

	^ content printString
]
