Class {
	#name : 'MiButterflyNodeRemove',
	#superclass : 'MiButterflyNodeMenuItem',
	#category : 'MooseIDE-ButterflyMap-Menu',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Menu'
}

{ #category : 'execution' }
MiButterflyNodeRemove >> execute [

	visualization removeNode: shape
	
]

{ #category : 'accessing' }
MiButterflyNodeRemove >> label [

	^ 'Remove node'
]
