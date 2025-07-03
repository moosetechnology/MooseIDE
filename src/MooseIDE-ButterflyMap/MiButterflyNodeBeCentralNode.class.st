Class {
	#name : #MiButterflyNodeBeCentralNode,
	#superclass : #MiButterflyNodeMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #testing }
MiButterflyNodeBeCentralNode >> canBeExecuted [

	^ shape model rawModel ~= visualization centralNode rawModel
]

{ #category : #execution }
MiButterflyNodeBeCentralNode >> execute [

	visualization mapModel currentEntity: shape model rawModel.
	visualization mapModel browser visualization run
]

{ #category : #accessing }
MiButterflyNodeBeCentralNode >> group [ 

	^ 4
]

{ #category : #accessing }
MiButterflyNodeBeCentralNode >> label [

	^ 'Be central node'
]
