"
Shows the containment tree (direct relations for now) between entities, as a roassal visualization.

- Accepted entities: a MooseGroup.
- Highlight: Entities if present.
- Propagate: The selected entity if there is one.

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
	#name : #MiTreeVisualisationBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Dependency-Tree'
}

{ #category : #layout }
MiTreeVisualisationBrowser class >> defaultLayout [
	^ super defaultLayout
		add: #diagram;
		yourself
]

{ #category : #'world menu' }
MiTreeVisualisationBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiTreeVisualisationBrowser class >> menuIconName [

	^ #mooseTree
]

{ #category : #'world menu' }
MiTreeVisualisationBrowser class >> menuItem [

	^ #TreeVisualisationBrowser
]

{ #category : #'world menu' }
MiTreeVisualisationBrowser class >> menuParent [

	^ self dependencyMenuRoot
]

{ #category : #'world menu' }
MiTreeVisualisationBrowser class >> menuPriority [

	^ 2.0
]

{ #category : #'instance creation' }
MiTreeVisualisationBrowser class >> newModel [

	^ MiTreeVisualizationModel new
]

{ #category : #'instance creation' }
MiTreeVisualisationBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> title [
	^ 'Tree Visualisation'
]

{ #category : #testing }
MiTreeVisualisationBrowser >> canFollowEntity: anEntity [

	^ (anEntity usesFamixTrait: TEntityMetaLevelDependency) and: [ 
		  self needUpdate: anEntity ]
]

{ #category : #testing }
MiTreeVisualisationBrowser >> canHighlight [

	^ true
]

{ #category : #testing }
MiTreeVisualisationBrowser >> canTagEntities [ 
	self flag: 'Remove browser ? (issue #810)'.
	^false
]

{ #category : #actions }
MiTreeVisualisationBrowser >> followEntity: anEntity [

	specModel root: anEntity.
	diagram
		run;
		receiveEntity: anEntity
]

{ #category : #actions }
MiTreeVisualisationBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity asCollection
]

{ #category : #initialization }
MiTreeVisualisationBrowser >> initializePresenters [

	diagram := self instantiate: MiTreeVisualisation
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> miSelectedItem [

	^ specModel selected
]
