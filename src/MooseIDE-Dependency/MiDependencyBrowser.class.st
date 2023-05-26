"
Shows dependencies between entities (using #queryIncomingDependencies and #queryOutgoingDependencies).

- Accepted entities: a MooseGroup.
- Highlight: Entites if present.
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
	#name : #MiDependencyBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Dependency-Dependency'
}

{ #category : #layout }
MiDependencyBrowser class >> defaultLayout [
	^ super defaultLayout
		add: #diagram;
		yourself
]

{ #category : #'world menu' }
MiDependencyBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiDependencyBrowser class >> menuIconName [

	^ #mooseTree
]

{ #category : #'world menu' }
MiDependencyBrowser class >> menuItem [

	^ #DependencyVisualisationBrowser
]

{ #category : #'world menu' }
MiDependencyBrowser class >> menuParent [

	^ self dependencyMenuRoot
]

{ #category : #'world menu' }
MiDependencyBrowser class >> menuPriority [

	^ 0
]

{ #category : #'instance creation' }
MiDependencyBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiDependencyBrowser class >> title [

	^ 'Dependency'
]

{ #category : #testing }
MiDependencyBrowser >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject anySatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ]
]

{ #category : #testing }
MiDependencyBrowser >> canHighlight [

	^ true
]

{ #category : #testing }
MiDependencyBrowser >> canTagEntities [ 
	self flag: 'Remove browser ? (issue #810)'.
	^false
]

{ #category : #actions }
MiDependencyBrowser >> followEntity: anEntity [

	diagram
		entities: (anEntity asMooseGroup select: [ :a | 
					 a usesFamixTrait: TEntityMetaLevelDependency ]);
		run
]

{ #category : #actions }
MiDependencyBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity asCollection
]

{ #category : #initialization }
MiDependencyBrowser >> initializePresenters [

	diagram := self instantiate: MiDependencyVisualization
]

{ #category : #accessing }
MiDependencyBrowser >> miSelectedItem [

	^ diagram selected ifNil: [ diagram entities ]
]
