Class {
	#name : #MiButterflyNodeBeCentralNode,
	#superclass : #MiButterflyNodeMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #execution }
MiButterflyNodeBeCentralNode >> canBeExecuted [

	^ shape model rawModel ~= visualization centralNode rawModel
]

{ #category : #execution }
MiButterflyNodeBeCentralNode >> execute [

	visualization mapModel currentEntity: shape model rawModel.
	visualization mapModel browser visualization run
]

{ #category : #execution }
MiButterflyNodeBeCentralNode >> group [ 

	^ 4
]

{ #category : #execution }
MiButterflyNodeBeCentralNode >> label [

	^ 'Be central node'
]
