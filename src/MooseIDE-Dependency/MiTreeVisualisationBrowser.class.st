"
Shows the containment tree (direct relations for now) between entities, as a roassal visualization.

- Follow: Receives a MooseGroup.
- Highlight: Entities if present.
- Propagate: The selected entity if there is one.
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

{ #category : #actions }
MiTreeVisualisationBrowser >> followEntity: anEntity [

	model root: anEntity.
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

	^ model selected
]
