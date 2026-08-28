"
I am a browser that displays a heat map.
Accepted entities: any MooseEntity.

Controls:

* Mouse over to highlight common inner boxes
* Mouse click to keep the highlight
* right click over a box, to use the menu
* right click over the view to use the general menu
* Mouse left to drag
* Arrow keys to move the visualization around
* Scroll bars to change the view's position
* M to collapse or expand the window
* I to zoom in
* O to zoom out
* Mouse Wheel to zoom in/out
* S to search entities by their name (several searches can be applied)
* R to clear all searches
"
Class {
	#name : 'MiHeatMapBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'MooseIDE-HeatMap-Tests',
	#package : 'MooseIDE-HeatMap',
	#tag : 'Tests'
}

{ #category : 'accessing' }
MiHeatMapBrowser class >> mapClass [

	^ MiHeatMapVisualization
]

{ #category : 'world menu' }
MiHeatMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiHeatMapBrowser class >> menuItem [

	^ #HeatMapBrowser
]

{ #category : 'world menu' }
MiHeatMapBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 7
]

{ #category : 'instance creation' }
MiHeatMapBrowser class >> newModel [

	^ MiHeatMapModel new
]

{ #category : 'instance creation' }
MiHeatMapBrowser class >> open [

	<script>
	^ super open
]

{ #category : 'specs' }
MiHeatMapBrowser class >> title [

	^ 'Heat map'
]

{ #category : 'window control' }
MiHeatMapBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self
]

{ #category : 'testing' }
MiHeatMapBrowser >> canFollowEntity: aCollection [
	"Deliberately simpler than MiDistributionMapBrowser>>canFollowEntity: -- this browser has
	 no O(n^2) seriation algorithm (heat map coloring is a single O(n) linear-scale pass), and
	 no homogeneous-type requirement (the color block is evaluated per-entity independently,
	 with per-entity error recovery in MiHeatMapBuilder>>colorValueFor:), so neither of
	 MiDistributionMapBrowser's two confirm-dialogs applies."

	^ aCollection isCollection
]

{ #category : 'testing' }
MiHeatMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : 'initialization' }
MiHeatMapBrowser >> canvas [

	^ mainPresenter canvas
]

{ #category : 'actions' }
MiHeatMapBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel
		entities: anEntity asMooseGroup;
		initializeSettings.
	self runVisualization
]

{ #category : 'initialization' }
MiHeatMapBrowser >> visualization [

	^ mainPresenter
]
