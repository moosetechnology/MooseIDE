Class {
	#name : #MiButterflyNodeRemove,
	#superclass : #MiButterflyNodeMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #execution }
MiButterflyNodeRemove >> execute [

	visualization removeNode: shape
	
]

{ #category : #accessing }
MiButterflyNodeRemove >> label [

	^ 'Remove node'
]
