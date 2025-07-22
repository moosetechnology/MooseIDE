Class {
	#name : 'MiButterflyRemoveLevelMenuItem',
	#superclass : 'MiButterflyCanvasMenuItem',
	#category : 'MooseIDE-ButterflyMap-Menu',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Menu'
}

{ #category : 'execution' }
MiButterflyRemoveLevelMenuItem >> execute [

	visualization removeLevel
]

{ #category : 'execution' }
MiButterflyRemoveLevelMenuItem >> label [

	^ 'Remove external layer'
]

{ #category : 'execution' }
MiButterflyRemoveLevelMenuItem >> order [

	^ 0
]
