"
I am a browser that displays an architectural map.
Accepted entities: a MooseObject.

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
	#name : #MiArchitecturalMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalMapBrowser class >> mapClass [

	^ MiArchitecturalMapVisualization
]

{ #category : #'world menu' }
MiArchitecturalMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiArchitecturalMapBrowser class >> menuItem [

	^ #MiArchitecturalMapBrowser
]

{ #category : #'world menu' }
MiArchitecturalMapBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 1
]

{ #category : #'instance creation' }
MiArchitecturalMapBrowser class >> newModel [

	^ MiArchitecturalMapModel new
]

{ #category : #'instance creation' }
MiArchitecturalMapBrowser class >> open [
	<script>
	super open
]

{ #category : #specs }
MiArchitecturalMapBrowser class >> title [

	^ 'Architectural map'
]

{ #category : #specs }
MiArchitecturalMapBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #actions }
MiArchitecturalMapBrowser >> availableQueries [

	^ (self application itemsFor: FQAbstractQuery) asOrderedCollection 
		  select: [ :q | q isValid ]
]

{ #category : #actions }
MiArchitecturalMapBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #testing }
MiArchitecturalMapBrowser >> canPropagate [
	^true
]

{ #category : #testing }
MiArchitecturalMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> canvas [

	^ visualization canvas
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> fetchTags [

	^ (self application itemsFor: FamixTag) asOrderedCollection
]

{ #category : #actions }
MiArchitecturalMapBrowser >> followEntity: anEntity [

	specModel entities: anEntity asMooseGroup.
	self runVisualization
]

{ #category : #testing }
MiArchitecturalMapBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: visualization)
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiArchitecturalMapBrowser >> miSelectedItem [

	^visualization canvas selectedShapes
		ifEmpty: [ specModel entities mooseInterestingEntity ]
		ifNotEmpty: [ :selectedShapes |
			(selectedShapes collect: [:shape | shape model rawModel])
				asMooseGroup ]
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> run [

	visualization run
]

{ #category : #actions }
MiArchitecturalMapBrowser >> runVisualization [ 

	visualization run
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> setModelBeforeInitialization: aModel [

	super setModelBeforeInitialization: aModel.
	aModel browser: self
]

{ #category : #accessing }
MiArchitecturalMapBrowser >> settings [

	^specModel openSettings
]

{ #category : #'accessing - private tests' }
MiArchitecturalMapBrowser >> visualization [
	^visualization
]
