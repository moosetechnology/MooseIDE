"
A MooseIDE browser showing a DSM (Dependency Structural Matrix).

- Accepted entities: a group of entities having dependencies between themselves.
- Highlight: <TODO>
- Propagate: <TODO>

Legend:
- A blue cell indicates that the row entity directly depends on the column entity.
- A pink cell indicates the same + there is a dependency cycle.
- When putting the mouse on a pink cell, it paints in red all the dependencies involved in this particular cycle (there may be more than one dependency cycle, so some other cells may remain pink).

Entities ordered on:
- number of in-dependencies (column blue cells) + out-dependencies (row blue cells).
- if equal, number of out-dependencies (row blue cells).
- if also equal, then alphabetical order of name.

Controls:
- Mouse over to highlight common inner boxes
- Mouse click to keep the highlight
- right click over a box, to use the menu
- right click over the view to use the general menu
- command+click to use the last tag.

- Mouse left to drag
- Arrow keys to move the visualization around
- Scrolls bars to change the view's position
- M to collapse or expand the window
- I to zoom in
- O to zoom out
- Moouse Wheel to zoom in/out
- S to search entities by their name (several search can be applied)
- R to clear all searches
"
Class {
	#name : #MiDependencyStructuralMatrixBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #'world menu' }
MiDependencyStructuralMatrixBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiDependencyStructuralMatrixBrowser class >> menuIconName [

	^ #mooseTree
]

{ #category : #'world menu' }
MiDependencyStructuralMatrixBrowser class >> menuItem [

	^ #DSMVisualisationBrowser
]

{ #category : #'world menu' }
MiDependencyStructuralMatrixBrowser class >> menuLabel [

	^ 'Dependency Structural Matrix'
]

{ #category : #'world menu' }
MiDependencyStructuralMatrixBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 4
]

{ #category : #'instance creation' }
MiDependencyStructuralMatrixBrowser class >> newModel [
	^MiDependencyStructuralMatrixBrowserModel new
]

{ #category : #'instance creation' }
MiDependencyStructuralMatrixBrowser class >> open [

	<script>
	^ super open
]

{ #category : #'instance creation' }
MiDependencyStructuralMatrixBrowser class >> openWithX: nodesX withY: nodesY [

	^(super on: self newModel)
		withX: nodesX withY: nodesY;
		open;
		yourself

]

{ #category : #specs }
MiDependencyStructuralMatrixBrowser class >> title [

	^ 'Dependency Structural Matrix'
]

{ #category : #api }
MiDependencyStructuralMatrixBrowser >> buildDSM [
	mainPresenter run
]

{ #category : #testing }
MiDependencyStructuralMatrixBrowser >> canFollowEntity: anObject [

	^ specModel canFollowEntity: anObject
]

{ #category : #testing }
MiDependencyStructuralMatrixBrowser >> canTagEntities [ 
	^false
]

{ #category : #accessing }
MiDependencyStructuralMatrixBrowser >> diagram [

	^ mainPresenter
]

{ #category : #actions }
MiDependencyStructuralMatrixBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #initialization }
MiDependencyStructuralMatrixBrowser >> initializePresenters [

	mainPresenter := self instantiate: MiDependencyStructuralMatrixVisualization.
	mainPresenter specModel: specModel
]

{ #category : #accessing }
MiDependencyStructuralMatrixBrowser >> miSelectedItem [

	^ specModel miSelectedItem
]

{ #category : #api }
MiDependencyStructuralMatrixBrowser >> showSCC: aCollection [
	mainPresenter showSCC: aCollection 
]

{ #category : #accessing }
MiDependencyStructuralMatrixBrowser >> withX: nodesX withY: nodesY [
	specModel withX: nodesX withY: nodesY
]
