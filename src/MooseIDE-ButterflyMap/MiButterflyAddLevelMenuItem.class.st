Class {
	#name : #MiButterflyAddLevelMenuItem,
	#superclass : #MiButterflyCanvasMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #execution }
MiButterflyAddLevelMenuItem >> execute [

	visualization addLevel
]

{ #category : #accessing }
MiButterflyAddLevelMenuItem >> label [

	^ 'Add layer'
]

{ #category : #accessing }
MiButterflyAddLevelMenuItem >> order [

	^ 0
]
