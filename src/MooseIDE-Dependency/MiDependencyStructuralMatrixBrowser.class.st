"
A MooseIDE browser showing a DSM (Dependency Structural Matrix).

- Accepted entities: a group of entities having dependencies between themselves.
- Highlight: <TODO>
- Propagate: <TODO>

Legend:
- A blue cell indicates that the column entity directly depends on the row entity.
- A pink cell indicates the same + there is a dependency cycle.
- When putting the mouse on a pink cell, it paints in red all the dependencies involved in this particular cycle (there may be more than one dependency cycle, so some other cells may remain pink).

Entities ordered on:
- number of dependents (row blue cells) + depending-on (column blue cells).
- if equal, number of depending-on (column blue cells).
- if also equal, then alphabetical order of name.

Controls:
- Mouse over a cell to highlight column and row (and its cycle)
- Double click on a cell to open a detailed DSM
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

{ #category : #testing }
MiDependencyStructuralMatrixBrowser >> hasSettings [
	^ true
]

{ #category : #initialization }
MiDependencyStructuralMatrixBrowser >> initializePresenters [

	mainPresenter := self instantiate: MiDependencyStructuralMatrixVisualization.
	mainPresenter specModel: specModel
]

{ #category : #'accessing - private tests' }
MiDependencyStructuralMatrixBrowser >> mainPresenter: anObject [

	mainPresenter := anObject 
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
