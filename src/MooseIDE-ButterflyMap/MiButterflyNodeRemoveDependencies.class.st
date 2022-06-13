Class {
	#name : #MiButterflyNodeRemoveDependencies,
	#superclass : #MiButterflyNodeMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #accessing }
MiButterflyNodeRemoveDependencies >> execute [

	visualization removeNodesFor: shape
]

{ #category : #accessing }
MiButterflyNodeRemoveDependencies >> group [

	^ 3
]

{ #category : #accessing }
MiButterflyNodeRemoveDependencies >> label [

	^ 'Remove dependencies'
]
