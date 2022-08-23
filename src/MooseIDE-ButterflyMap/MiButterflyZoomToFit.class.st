Class {
	#name : #MiButterflyZoomToFit,
	#superclass : #MiButterflyCanvasMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #execution }
MiButterflyZoomToFit >> execute [

	visualization container zoomToFit
]

{ #category : #execution }
MiButterflyZoomToFit >> group [

	^ 1
]

{ #category : #execution }
MiButterflyZoomToFit >> label [

	^ 'ZoomToFit'
]
