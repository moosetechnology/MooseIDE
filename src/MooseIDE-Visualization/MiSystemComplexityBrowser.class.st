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
	#name : 'MiSystemComplexityBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'MooseIDE-Visualization-System Complexity',
	#package : 'MooseIDE-Visualization',
	#tag : 'System Complexity'
}

{ #category : 'world menu' }
MiSystemComplexityBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ (self buildMenuItemIn: aBuilder) withSeparatorAfter
]

{ #category : 'world menu' }
MiSystemComplexityBrowser class >> menuItem [

	^ #SystemComplexityBrowser
]

{ #category : 'world menu' }
MiSystemComplexityBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 6
]

{ #category : 'instance creation' }
MiSystemComplexityBrowser class >> newModel [

	^ MiSystemComplexityModel new
]

{ #category : 'instance creation' }
MiSystemComplexityBrowser class >> open [

	<script>
	^ super open
]

{ #category : 'specs' }
MiSystemComplexityBrowser class >> title [

	^ 'System complexity'
]

{ #category : 'actions' }
MiSystemComplexityBrowser >> buildVisualization [

	self deprecated: 'Use runVisualization method instead' transformWith: '`@receiver buildVisualization' -> '`@receiver runVisualization'.
	self runVisualization 
]

{ #category : 'testing' }
MiSystemComplexityBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ anObject isCollection ]
]

{ #category : 'testing' }
MiSystemComplexityBrowser >> canTagEntities [ 
	self flag: 'No for now, but will need to be implemented'.
	^false
]

{ #category : 'actions' }
MiSystemComplexityBrowser >> followEntity: aMooseGroup [

	| newGroup |
	super followEntity: aMooseGroup.
	newGroup := (aMooseGroup select: [ :e | e isClass ]) asMooseGroup.

	newGroup ifEmpty: [
			self inform: 'System Complexity:
All received entities were rejected'.
			^ self ].

	newGroup size < aMooseGroup size ifTrue: [
			self inform: (String streamContents: [ :s |
						 s
							 << 'SystemComplexity:';
							 cr;
							 << (aMooseGroup size - newGroup size) asString;
							 << ' rejected entities.' ]) ].

	specModel entities: newGroup.
	self runVisualization
]

{ #category : 'initialization' }
MiSystemComplexityBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: mainPresenter;
			 yourself)
]

{ #category : 'initialization' }
MiSystemComplexityBrowser >> initializePresenters [

	mainPresenter := self instantiate: MiSystemComplexityVisualization.
	self initializeLayout
]
