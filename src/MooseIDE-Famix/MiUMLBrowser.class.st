"
Shows UML of the received entities.

- Accepted entities: a TypeGroup or entities using TType.
- Highlight: Entities if present
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
	#name : #MiUMLBrowser,
	#superclass : #MiAbstractVisualizationBrowser,
	#category : #'MooseIDE-Famix-UML'
}

{ #category : #'world menu' }
MiUMLBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiUMLBrowser class >> menuIconName [

	^ #mooseUml
]

{ #category : #'world menu' }
MiUMLBrowser class >> menuItem [

	^ #UMLVisualisationBrowser
]

{ #category : #'world menu' }
MiUMLBrowser class >> menuParent [

	^ self oldBrowserMenuRoot
]

{ #category : #'world menu' }
MiUMLBrowser class >> menuPriority [

	^ self menuOldBrowsersPriority + 2
]

{ #category : #'instance creation' }
MiUMLBrowser class >> newModel [

	^ MiUMLModel new
]

{ #category : #'instance creation' }
MiUMLBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiUMLBrowser class >> title [

	^ 'UML'
]

{ #category : #testing }
MiUMLBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ 
		  anObject asMooseSpecializedGroup isKindOf: FamixTypeGroup ]
]

{ #category : #testing }
MiUMLBrowser >> canTagEntities [

	^ false
]

{ #category : #actions }
MiUMLBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel
		entities: anEntity asMooseSpecializedGroup;
		unselectAll.
	mainPresenter
		rootEntities: specModel entities;
		run
]

{ #category : #highlighting }
MiUMLBrowser >> highlightEntity: anEntity [

	mainPresenter highlightEntities: anEntity asCollection
]

{ #category : #initialization }
MiUMLBrowser >> initializePresenters [

	mainPresenter := self instantiate: MiUMLVisualization
]

{ #category : #accessing }
MiUMLBrowser >> miSelectedItem [

	^ specModel selected ifNil: [ specModel entities ]
]

{ #category : #accessing }
MiUMLBrowser >> selected: anEntity [

	specModel selected: anEntity
]
