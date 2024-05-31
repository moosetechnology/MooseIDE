"
Entry menu in HNode for 'Propagate' option
"
Class {
	#name : #HMiPropagateMenuItem,
	#superclass : #HNodeMenuItem,
	#category : #'MooseIDE-Visualization-Helpers'
}

{ #category : #accessing }
HMiPropagateMenuItem >> argument [
	"Propagate on the buses selected by the browser"

	^ visualization mapModel ifNotNil: [ :mapModel |
		  mapModel browser buses ]
]

{ #category : #testing }
HMiPropagateMenuItem >> canBeExecuted [
	^ shape model rawModel isMooseEntity
]

{ #category : #accessing }
HMiPropagateMenuItem >> group [
	^1
]

{ #category : #accessing }
HMiPropagateMenuItem >> iconName [
	^ #mooseOutgoing
]

{ #category : #accessing }
HMiPropagateMenuItem >> label [
	^ 'Propagate'
]

{ #category : #accessing }
HMiPropagateMenuItem >> order [
	^ 100
]

{ #category : #accessing }
HMiPropagateMenuItem >> selector [
	^ #miPropagateOn:
]

{ #category : #accessing }
HMiPropagateMenuItem >> target [
	^ shape model rawModel
]
