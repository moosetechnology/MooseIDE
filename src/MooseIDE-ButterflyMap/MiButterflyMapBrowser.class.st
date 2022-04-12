Class {
	#name : #MiButterflyMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-ButterflyMap'
}

{ #category : #accessing }
MiButterflyMapBrowser class >> mapClass [

	^ MiButterflyMap
]

{ #category : #accessing }
MiButterflyMapBrowser class >> newModel [

	^ MiButterflyMapModel new
]

{ #category : #accessing }
MiButterflyMapBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiButterflyMapBrowser class >> title [

	^ 'Butterfly map'
]

{ #category : #accessing }
MiButterflyMapBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #testing }
MiButterflyMapBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #actions }
MiButterflyMapBrowser >> followEntity: anEntity [

	model currentEntity: anEntity.
	visualization run
]

{ #category : #initialization }
MiButterflyMapBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiButterflyMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiButterflyMapBrowser >> miSelectedItem [

	^ model currentEntity
]

{ #category : #actions }
MiButterflyMapBrowser >> settings [
	
]
