Class {
	#name : #MiButterflyAddLevelMenuItem,
	#superclass : #MiButterflyCanvasMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #accessing }
MiButterflyAddLevelMenuItem >> execute [

	visualization addLevel
]

{ #category : #accessing }
MiButterflyAddLevelMenuItem >> label [

	^ 'Add level'
]

{ #category : #accessing }
MiButterflyAddLevelMenuItem >> order [

	^ 0
]
