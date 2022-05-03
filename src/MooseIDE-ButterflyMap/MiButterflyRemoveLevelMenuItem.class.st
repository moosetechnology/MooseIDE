Class {
	#name : #MiButterflyRemoveLevelMenuItem,
	#superclass : #MiButterflyCanvasMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #execution }
MiButterflyRemoveLevelMenuItem >> execute [

	visualization removeLevel
]

{ #category : #execution }
MiButterflyRemoveLevelMenuItem >> label [

	^ 'Remove level'
]

{ #category : #execution }
MiButterflyRemoveLevelMenuItem >> order [

	^ 0
]
