"
I am a browser that displays hierarchical visualization.

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
	#name : #MiHierarchicalVisualizationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Visualization-Hierarchical Visualization'
}

{ #category : #menu }
MiHierarchicalVisualizationBrowser class >> addToMiBrowsersMenu: aMenuGroupPresenter [

	"Do not appear in menu"

	
]

{ #category : #layout }
MiHierarchicalVisualizationBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #diagram;
		  yourself
]

{ #category : #'instance creation' }
MiHierarchicalVisualizationBrowser class >> open [

	<script>
	super open
]

{ #category : #specs }
MiHierarchicalVisualizationBrowser class >> title [

	^ 'Hierarchical Visualization'
]

{ #category : #testing }
MiHierarchicalVisualizationBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #actions }
MiHierarchicalVisualizationBrowser >> followEntity: anEntity [

	diagram entities: anEntity asCollection.
	diagram run
]

{ #category : #initialization }
MiHierarchicalVisualizationBrowser >> initializePresenters [

	diagram := self instantiate: MiHierarchicalVisualization.
	diagram childrenBlock: [ :el | 
		(el usesFamixTrait: TEntityMetaLevelDependency)
			ifTrue: [ el children ]
			ifFalse: [ {  } ] ]
]

{ #category : #accessing }
MiHierarchicalVisualizationBrowser >> miSelectedItem [
	^nil
]
