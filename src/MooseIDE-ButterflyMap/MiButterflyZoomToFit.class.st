Class {
	#name : 'MiButterflyZoomToFit',
	#superclass : 'MiButterflyCanvasMenuItem',
	#category : 'MooseIDE-ButterflyMap-Menu',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Menu'
}

{ #category : 'execution' }
MiButterflyZoomToFit >> execute [

	visualization container zoomToFit
]

{ #category : 'accessing' }
MiButterflyZoomToFit >> group [

	^ 1
]

{ #category : 'accessing' }
MiButterflyZoomToFit >> label [

	^ 'ZoomToFit'
]
