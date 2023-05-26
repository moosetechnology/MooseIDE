"
I am a browser showing a System Complexity visualization on classes.
Accepted entities: a MooseGroup.

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
	#name : #MiSystemComplexityBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #'world menu' }
MiSystemComplexityBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self buildMenuItemIn: aBuilder) withSeparatorAfter
]

{ #category : #'world menu' }
MiSystemComplexityBrowser class >> menuItem [

	^ #SystemComplexityBrowser
]

{ #category : #'world menu' }
MiSystemComplexityBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 6
]

{ #category : #'instance creation' }
MiSystemComplexityBrowser class >> newModel [

	^ MiSystemComplexityModel new
]

{ #category : #'instance creation' }
MiSystemComplexityBrowser class >> open [

	<script>
	super open
]

{ #category : #specs }
MiSystemComplexityBrowser class >> title [

	^ 'System complexity'
]

{ #category : #actions }
MiSystemComplexityBrowser >> buildVisualization [

	visualization run
]

{ #category : #testing }
MiSystemComplexityBrowser >> canFollowEntity: anObject [

	^ anObject isKindOf: MooseGroup
]

{ #category : #testing }
MiSystemComplexityBrowser >> canTagEntities [ 
	self flag: 'No for now, but will need to be implemented'.
	^false
]

{ #category : #actions }
MiSystemComplexityBrowser >> followEntity: aMooseGroup [

	| newGroup |
	newGroup := aMooseGroup select: [ :e | e isClass ].
	newGroup size < aMooseGroup size ifTrue: [ 
		self inform:
			(aMooseGroup size - newGroup size) asString , ' rejected entities.' ].
	specModel entities: newGroup
]

{ #category : #actions }
MiSystemComplexityBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiSystemComplexityBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiSystemComplexityBrowser >> initializePresenters [

	visualization := self instantiate: MiSystemComplexityVisualization.
	self initializeLayout
]

{ #category : #accessing }
MiSystemComplexityBrowser >> miSelectedItem [

	^ specModel entities
]

{ #category : #actions }
MiSystemComplexityBrowser >> settings [
	
	specModel settings open
]
