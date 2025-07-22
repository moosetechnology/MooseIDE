Class {
	#name : 'MiButterflyAddLevelMenuItem',
	#superclass : 'MiButterflyCanvasMenuItem',
	#category : 'MooseIDE-ButterflyMap-Menu',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Menu'
}

{ #category : 'accessing' }
MiButterflyAddLevelMenuItem >> execute [

	visualization addLevel
]

{ #category : 'accessing' }
MiButterflyAddLevelMenuItem >> label [

	^ 'Add layer'
]

{ #category : 'accessing' }
MiButterflyAddLevelMenuItem >> order [

	^ 0
]
