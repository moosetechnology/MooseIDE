"
I am a browser that displays a distribution map.
Accepted entities: any MooseEntity.

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
	#name : #MiDMBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #accessing }
MiDMBrowser class >> mapClass [

	^ MiDMVisualization
]

{ #category : #'world menu' }
MiDMBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiDMBrowser class >> menuItem [

	^ #DMBrowser
]

{ #category : #'world menu' }
MiDMBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 5
]

{ #category : #'instance creation' }
MiDMBrowser class >> newModel [

	^ MiDistributionMapModel new
]

{ #category : #'instance creation' }
MiDMBrowser class >> open [
	<script>
	super open
]

{ #category : #specs }
MiDMBrowser class >> title [

	^ 'Distribution map'
]

{ #category : #specs }
MiDMBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #adding }
MiDMBrowser >> addDynamicTags: aCollection [

	aCollection do: [ :dt | self model addDynamicTag: dt ].
	"settings refreshTagList"
]

{ #category : #actions }
MiDMBrowser >> availableQueries [

	^ (self application itemsFor: FQAbstractQuery) asOrderedCollection 
		  select: [ :q | q isValid ]
]

{ #category : #initialization }
MiDMBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self
]

{ #category : #actions }
MiDMBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #testing }
MiDMBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiDMBrowser >> canvas [

	^ visualization canvas
]

{ #category : #actions }
MiDMBrowser >> followEntity: anEntity [

	specModel entities: anEntity asMooseGroup.
	self runVisualization
]

{ #category : #testing }
MiDMBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiDMBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 3;
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiDMBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiDMBrowser >> miSelectedItem [

	^ specModel entities mooseInterestingEntity
]

{ #category : #actions }
MiDMBrowser >> runVisualization [

	visualization run
]

{ #category : #accessing }
MiDMBrowser >> settings [

	^specModel settings open
]

{ #category : #initialization }
MiDMBrowser >> visualization [

	^ visualization
]
