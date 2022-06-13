"
I am a Butterfly map. I can show incoming and outgoing dependencies from a central entity. It allows to navigate through several level of dependencies.
I accept a moose entity that is the central entity.
By default entities at left are all clients of the central entity, right ones are providers of the central entity. You can change these rules and custom the semantics of your butterfly map by playing with its settings.


"
Class {
	#name : #MiButterflyMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-ButterflyMap-Browser'
}

{ #category : #accessing }
MiButterflyMapBrowser class >> mapClass [

	^ MiButterflyMap
]

{ #category : #accessing }
MiButterflyMapBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #ButterflyMapBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
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
MiButterflyMapBrowser >> followEntity: anEntity [

	self model currentEntity: anEntity
]

{ #category : #actions }
MiButterflyMapBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiButterflyMapBrowser >> initialize [

	super initialize
]

{ #category : #initialization }
MiButterflyMapBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: visualization)
]

{ #category : #initialization }
MiButterflyMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	model browser: self.
	self initializeLayout
]

{ #category : #brokerage }
MiButterflyMapBrowser >> itemsFor: aClass [

	^ self application itemsFor: aClass
]

{ #category : #accessing }
MiButterflyMapBrowser >> miSelectedItem [

	^ model currentEntity
]

{ #category : #running }
MiButterflyMapBrowser >> run [

	self visualization run
]

{ #category : #actions }
MiButterflyMapBrowser >> settings [
	
	self model openSettings
]

{ #category : #accessing }
MiButterflyMapBrowser >> visualization [

	^ visualization
]
