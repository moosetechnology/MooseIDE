"
I am a Butterfly map. I can show incoming and outgoing dependencies from a central entity. It allows to navigate through several level of dependencies.
Accepted entities: a moose entity that is the central entity.

By default entities at left are all clients of the central entity, right ones are providers of the central entity. You can change these rules and custom the semantics of your butterfly map by playing with its settings.

Controls:

* Mouse over to highlight common inner boxes
* Mouse click to keep the highlight
* right click over a box, to use the menu
* right click over the view to use the general menu
* command+click to use the last tag.

* Mouse left to drag
* Arrrow keys to move the visualization around
* Scrolls bars to change the view's position
* M to collapse or expand the window
* I to zoom in
* O to zoom out
* Moouse Wheel to zoom in/out
* S to search entities by their name (several search can be applied)
* R to clear all searches

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

	^ MiButterflyMapVisualization
]

{ #category : #'world menu' }
MiButterflyMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiButterflyMapBrowser class >> menuItem [

	^ #ButterflyMapBrowser
]

{ #category : #'world menu' }
MiButterflyMapBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 2
]

{ #category : #'instance creation' }
MiButterflyMapBrowser class >> newModel [

	^ MiButterflyMapModel new
]

{ #category : #'instance creation' }
MiButterflyMapBrowser class >> open [
	<script>
	super open
]

{ #category : #specs }
MiButterflyMapBrowser class >> title [

	^ 'Butterfly map'
]

{ #category : #specs }
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
	specModel browser: self.
	self initializeLayout
]

{ #category : #brokerage }
MiButterflyMapBrowser >> itemsFor: aClass [

	^ self application itemsFor: aClass
]

{ #category : #accessing }
MiButterflyMapBrowser >> miSelectedItem [

	^ specModel currentEntity
]

{ #category : #running }
MiButterflyMapBrowser >> run [

	self visualization run
]

{ #category : #actions }
MiButterflyMapBrowser >> settings [
	
	^self model openSettings
]

{ #category : #accessing }
MiButterflyMapBrowser >> visualization [

	^ visualization
]
