"
Entry menu in HNode for 'Propagate' option
"
Class {
	#name : #HMiPropagateMenuItem,
	#superclass : #HNodeMenuItem,
	#category : #'MooseIDE-Visualization-Helpers'
}

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
	^ #miPropagate
]

{ #category : #accessing }
HMiPropagateMenuItem >> target [
	^ shape model rawModel
]
