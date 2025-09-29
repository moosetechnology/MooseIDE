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
	#name : #MiDSMBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #'world menu' }
MiDSMBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
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

{ #category : #'instance creation' }
MiDSMBrowser class >> openWithX: entitiesX withY: entitiesY [

	^(super on: self newModel)
		withX: entitiesX withY: entitiesY;
		open;
		yourself

]

{ #category : #specs }
MiDSMBrowser class >> title [

	^ 'Dependency Structural Matrix'
]

{ #category : #api }
MiDSMBrowser >> buildDSM [
	mainPresenter run
]

{ #category : #testing }
MiDSMBrowser >> canFollowEntity: anObject [

	^ specModel canFollowEntity: anObject
]

{ #category : #testing }
MiDSMBrowser >> canTagEntities [ 
	^false
]

{ #category : #accessing }
MiDSMBrowser >> diagram [

	^ mainPresenter
]

{ #category : #actions }
MiDSMBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #initialization }
MiDSMBrowser >> initializePresenters [

	mainPresenter := self instantiate: MiDSMVisualization.
	mainPresenter specModel: specModel
]

{ #category : #'accessing - private tests' }
MiDSMBrowser >> mainPresenter: anObject [

	mainPresenter := anObject 
]

{ #category : #accessing }
MiDSMBrowser >> miSelectedItem [

	^ specModel miSelectedItem
]

{ #category : #api }
MiDSMBrowser >> showSCC: aCollection [
	mainPresenter showSCC: aCollection 
]

{ #category : #accessing }
MiDSMBrowser >> withX: entitiesX withY: entitiesY [
	specModel withX: entitiesX withY: entitiesY
]
