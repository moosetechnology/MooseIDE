"
I am a browser that displays a distribution map.
Accepted entities: any MooseEntity.

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
	#name : #MiDMBrowser,
	#superclass : #MiAbstractVisualizationBrowser,
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #accessing }
MiDMBrowser class >> mapClass [

	^ MiDMVisualization
]

{ #category : #'world menu' }
MiDMBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiDMBrowser class >> menuItem [

	^ #DMBrowser
]

{ #category : #'world menu' }
MiDMBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 5
]

{ #category : #'instance creation' }
MiDMBrowser class >> newModel [

	^ MiDistributionMapModel new
]

{ #category : #'instance creation' }
MiDMBrowser class >> open [
	<script>
	super open
]

{ #category : #specs }
MiDMBrowser class >> title [

	^ 'Distribution map'
]

{ #category : #specs }
MiDMBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #adding }
MiDMBrowser >> addDynamicTags: aCollection [

	aCollection do: [ :dt | self model addDynamicTag: dt ].
	"settings refreshTagList"
]

{ #category : #actions }
MiDMBrowser >> availableQueries [

	^ (self application itemsFor: FQAbstractQuery) asOrderedCollection 
		  select: [ :q | q isValid ]
]

{ #category : #initialization }
MiDMBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self
]

{ #category : #actions }
MiDMBrowser >> canFollowEntity: aCollection [

	| uniqType confirm |
	aCollection isCollection ifFalse: [ ^false ].

	"for example, this allows to open on an empty collection
	 (to propagate entities later)"
	aCollection ifEmpty: [ ^true ].

	(aCollection size > self model tooManyEntities)
		ifTrue: [ 
			confirm := UIManager default
				confirm: 'DistributionMap uses an algorithm in O^2.
Propagating many entities to it will result in lengthy computation.
Are you sure you want to continue ?'.
			confirm ifFalse: [ ^false ]
	].

	uniqType := aCollection anyOne class.
	(aCollection allSatisfy: [ :e | (e class = uniqType) ])
		ifFalse: [
			confirm := UIManager default
				confirm: 'DistributionMap is intend to work on _one_ kind of entity (and their direct ''children'').
You are propagating several different kinds of entities.
Are you sure you want to continue ?
(That might result in unecessary lengthy computation)'.
			confirm ifFalse: [ ^false ]
		].

	^true
]

{ #category : #testing }
MiDMBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiDMBrowser >> canvas [

	^ mainPresenter canvas
]

{ #category : #actions }
MiDMBrowser >> followEntity: anEntity [

	specModel entities: anEntity asMooseGroup.
	self runVisualization
]

{ #category : #testing }
MiDMBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiDMBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 3;
			 add: mainPresenter;
			 yourself)
]

{ #category : #initialization }
MiDMBrowser >> initializePresenters [

	mainPresenter := self class mapClass owner: self.
	self initializeLayout
]

{ #category : #initialization }
MiDMBrowser >> visualization [

	^ mainPresenter
]
