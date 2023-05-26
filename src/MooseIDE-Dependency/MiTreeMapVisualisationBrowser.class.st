"
Shows the containment (direct relations for now) between entities.
Dynamic presentation: clicking on an entity shows the entities it contains.

- Accepted entities: a MooseObject.
- Highlight: Entities if present.
- Propagate: <TODO>.

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
	#name : #MiTreeMapVisualisationBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Dependency-TreeMap'
}

{ #category : #layout }
MiTreeMapVisualisationBrowser class >> defaultLayout [
	^ super defaultLayout
		add: #diagram;
		yourself
]

{ #category : #'world menu' }
MiTreeMapVisualisationBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiTreeMapVisualisationBrowser class >> menuIconName [

	^ #mooseTreeMap
]

{ #category : #'world menu' }
MiTreeMapVisualisationBrowser class >> menuItem [

	^ #TreeMapVisualisationBrowser
]

{ #category : #'world menu' }
MiTreeMapVisualisationBrowser class >> menuParent [

	^ self dependencyMenuRoot
]

{ #category : #'world menu' }
MiTreeMapVisualisationBrowser class >> menuPriority [

	^ 3.0
]

{ #category : #'instance creation' }
MiTreeMapVisualisationBrowser class >> newModel [

	^ MiTreeMapVisualisationModel new
]

{ #category : #'instance creation' }
MiTreeMapVisualisationBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiTreeMapVisualisationBrowser class >> title [

	^ 'Tree Map Visualization'
]

{ #category : #testing }
MiTreeMapVisualisationBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ anObject rootsForTreeMap isNotEmpty ]
]

{ #category : #testing }
MiTreeMapVisualisationBrowser >> canHighlight [

	^ true
]

{ #category : #actions }
MiTreeMapVisualisationBrowser >> followEntity: anEntity [
	self window title: self class title, '-' , anEntity name.
	specModel entities: anEntity rootsForTreeMap.
	diagram run
]

{ #category : #actions }
MiTreeMapVisualisationBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity rootsForTreeMap
]

{ #category : #initialization }
MiTreeMapVisualisationBrowser >> initializePresenters [

	diagram := self instantiate: MiTreeMapVisualization
]

{ #category : #accessing }
MiTreeMapVisualisationBrowser >> miSelectedItem [

	^ specModel entities mooseInterestingEntity
]
