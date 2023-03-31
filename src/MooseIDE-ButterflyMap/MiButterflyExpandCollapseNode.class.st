Class {
	#name : #MiButterflyExpandCollapseNode,
	#superclass : #MiButterflyNodeMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #testing }
MiButterflyExpandCollapseNode >> canBeExecuted [
	^ shape model children isNotEmpty
]

{ #category : #testing }
MiButterflyExpandCollapseNode >> label [
	^ shape model isExpanded
		ifTrue: [ 'Collapse' ]
		ifFalse: [ 'Expand' ]
]

{ #category : #testing }
MiButterflyExpandCollapseNode >> order [
	^ 0
]

{ #category : #testing }
MiButterflyExpandCollapseNode >> selector [
	^ #expandCollapse
]

{ #category : #testing }
MiButterflyExpandCollapseNode >> target [
	^ shape model
]
