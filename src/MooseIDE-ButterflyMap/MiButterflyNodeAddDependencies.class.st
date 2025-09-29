Class {
	#name : #MiButterflyNodeAddDependencies,
	#superclass : #MiButterflyNodeMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #execution }
MiButterflyNodeAddDependencies >> execute [

	visualization addNodesFor: shape
]

{ #category : #accessing }
MiButterflyNodeAddDependencies >> group [

	^ 3
]

{ #category : #accessing }
MiButterflyNodeAddDependencies >> label [

	^ 'Add dependencies'
]
