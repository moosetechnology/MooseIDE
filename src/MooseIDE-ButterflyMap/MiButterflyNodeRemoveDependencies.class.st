Class {
	#name : 'MiButterflyNodeRemoveDependencies',
	#superclass : 'MiButterflyNodeMenuItem',
	#category : 'MooseIDE-ButterflyMap-Menu',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Menu'
}

{ #category : 'execution' }
MiButterflyNodeRemoveDependencies >> execute [

	visualization removeNodesFor: shape
]

{ #category : 'accessing' }
MiButterflyNodeRemoveDependencies >> group [

	^ 3
]

{ #category : 'accessing' }
MiButterflyNodeRemoveDependencies >> label [

	^ 'Remove dependencies'
]
