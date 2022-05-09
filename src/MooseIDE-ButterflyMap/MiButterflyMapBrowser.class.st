Class {
	#name : #MiButterflyMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization',
		'settings'
	],
	#category : #'MooseIDE-ButterflyMap-Browser'
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

	^ anObject isMooseEntity
]

{ #category : #actions }
MiButterflyMapBrowser >> closeSettings [

	self layout child: visualization
]

{ #category : #actions }
MiButterflyMapBrowser >> followEntity: anEntity [

	model currentEntity: anEntity.
	visualization run
]

{ #category : #actions }
MiButterflyMapBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiButterflyMapBrowser >> initialize [

	super initialize.
	self application registerConsumer: settings for: FQAbstractQuery
]

{ #category : #initialization }
MiButterflyMapBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: visualization)
]

{ #category : #initialization }
MiButterflyMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	settings := MiButterflyMapSettings owner: self.
	model browser: self.
	self initializeLayout
]

{ #category : #accessing }
MiButterflyMapBrowser >> miSelectedItem [

	^ model currentEntity
]

{ #category : #actions }
MiButterflyMapBrowser >> openSettings [

	self layout child: settings
]

{ #category : #actions }
MiButterflyMapBrowser >> settings [
	
	self openSettings
]

{ #category : #accessing }
MiButterflyMapBrowser >> visualization [

	^ visualization
]
