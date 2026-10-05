Class {
	#name : #MiButterflyZoomToFit,
	#superclass : #MiButterflyCanvasMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #execution }
MiButterflyZoomToFit >> execute [

	visualization container zoomToFit
]

{ #category : #accessing }
MiButterflyZoomToFit >> group [

	^ 1
]

{ #category : #accessing }
MiButterflyZoomToFit >> label [

	^ 'ZoomToFit'
]
