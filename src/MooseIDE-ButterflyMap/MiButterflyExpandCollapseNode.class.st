Class {
	#name : #MiButterflyExpandCollapseNode,
	#superclass : #MiButterflyNodeMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #testing }
MiButterflyExpandCollapseNode >> canBeExecuted [
	^ shape model children isNotEmpty
]

{ #category : #accessing }
MiButterflyExpandCollapseNode >> label [
	^ shape model isExpanded
		ifTrue: [ 'Collapse' ]
		ifFalse: [ 'Expand' ]
]

{ #category : #accessing }
MiButterflyExpandCollapseNode >> order [
	^ 0
]

{ #category : #accessing }
MiButterflyExpandCollapseNode >> selector [
	^ #expandCollapse
]

{ #category : #accessing }
MiButterflyExpandCollapseNode >> target [
	^ shape model
]
