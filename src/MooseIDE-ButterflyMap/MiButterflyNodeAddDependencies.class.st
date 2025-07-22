Class {
	#name : 'MiButterflyNodeAddDependencies',
	#superclass : 'MiButterflyNodeMenuItem',
	#category : 'MooseIDE-ButterflyMap-Menu',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Menu'
}

{ #category : 'execution' }
MiButterflyNodeAddDependencies >> execute [

	visualization addNodesFor: shape
]

{ #category : 'accessing' }
MiButterflyNodeAddDependencies >> group [

	^ 3
]

{ #category : 'execution' }
MiButterflyNodeAddDependencies >> label [

	^ 'Add dependencies'
]
