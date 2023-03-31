"
A MooseIDE browser showing a DSM (Dependency Structural Matrix).

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
- Arrrow keys to move the visualization around
- Scrolls bars to change the view's position
- M to collapse or expand the window
- I to zoom in
- O to zoom out
- Moouse Wheel to zoom in/out
- S to search entities by their name (several search can be applied)
- R to clear all searches
"
Class {
	#name : #MiDSMBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #specs }
MiDSMBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #diagram;
		  yourself
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuIconName [

	^ #mooseTree
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuItem [

	^ #DSMVisualisationBrowser
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuLabel [

	^ 'Dependency Structural Matrix'
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 4
]

{ #category : #'instance creation' }
MiDSMBrowser class >> newModel [
	^MiDSMBrowserModel new
]

{ #category : #'instance creation' }
MiDSMBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiDSMBrowser class >> title [

	^ 'DSM'
]

{ #category : #api }
MiDSMBrowser >> buildDSM [
	diagram run
]

{ #category : #testing }
MiDSMBrowser >> canFollowEntity: anObject [

	^specModel canFollowEntity: anObject
]

{ #category : #testing }
MiDSMBrowser >> canHighlight [

	^ true
]

{ #category : #accessing }
MiDSMBrowser >> diagram [

	^ diagram
]

{ #category : #actions }
MiDSMBrowser >> followEntity: anEntity [
	specModel followEntity: anEntity
]

{ #category : #actions }
MiDSMBrowser >> highlightEntity: anEntity [

	specModel highlightEntity: anEntity
]

{ #category : #initialization }
MiDSMBrowser >> initializePresenters [

	diagram := self instantiate: MiDSMVisualization.
	diagram viewModel: specModel
]

{ #category : #accessing }
MiDSMBrowser >> miSelectedItem [

	^specModel selectedEntities
]

{ #category : #api }
MiDSMBrowser >> showSCC: aCollection [
	diagram showSCC: aCollection 
]
