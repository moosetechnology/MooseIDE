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
	#name : 'MiDistributionMapBrowser',
	#superclass : 'MiAbstractVisualizationBrowser',
	#category : 'MooseIDE-DistributionMap',
	#package : 'MooseIDE-DistributionMap'
}

{ #category : 'accessing' }
MiDistributionMapBrowser class >> mapClass [

	^ MiDistributionMapVisualization
]

{ #category : 'world menu' }
MiDistributionMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiDistributionMapBrowser class >> menuItem [

	^ #DMBrowser
]

{ #category : 'world menu' }
MiDistributionMapBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 5
]

{ #category : 'instance creation' }
MiDistributionMapBrowser class >> newModel [

	^ MiDistributionMapModel new
]

{ #category : 'instance creation' }
MiDistributionMapBrowser class >> open [

	<script>
	^ super open
]

{ #category : 'specs' }
MiDistributionMapBrowser class >> preferredExtent [

	^ 850 @ 520
]

{ #category : 'specs' }
MiDistributionMapBrowser class >> title [

	^ 'Distribution map'
]

{ #category : 'adding' }
MiDistributionMapBrowser >> addDynamicTags: aCollection [

	aCollection do: [ :dt | self specModel addDynamicTag: dt ].
	"settings refreshTagList"
]

{ #category : 'actions' }
MiDistributionMapBrowser >> availableQueries [

	^ (self application itemsFor: FQAbstractQuery) asOrderedCollection 
		  select: [ :q | q isValid ]
]

{ #category : 'window control' }
MiDistributionMapBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self
]

{ #category : 'testing' }
MiDistributionMapBrowser >> canFollowEntity: aCollection [

	| uniqType confirm |
	aCollection isCollection ifFalse: [ ^ false ].

	"for example, this allows to open on an empty collection
	 (to propagate entities later)"
	aCollection ifEmpty: [ ^ true ].

	aCollection size > self specModel tooManyEntities ifTrue: [
			confirm := UIManager default confirm:
				           'DistributionMap uses an algorithm in O^2.
Propagating many entities to it will result in lengthy computation.
Are you sure you want to continue ?'.
			confirm ifFalse: [ ^ false ] ].

	uniqType := aCollection anyOne class.
	(aCollection allSatisfy: [ :e | e class = uniqType ]) ifFalse: [
			confirm := UIManager default confirm:
				           'DistributionMap is intend to work on _one_ kind of entity (and their direct ''children'').
You are propagating several different kinds of entities.
Are you sure you want to continue ?
(That might result in unecessary lengthy computation)'.
			confirm ifFalse: [ ^ false ] ].

	^ true
]

{ #category : 'testing' }
MiDistributionMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : 'initialization' }
MiDistributionMapBrowser >> canvas [

	^ mainPresenter canvas
]

{ #category : 'actions' }
MiDistributionMapBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel
		entities: anEntity asMooseGroup;
		initializeSettings.
	self runVisualization
]

{ #category : 'initialization' }
MiDistributionMapBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 3;
			 add: mainPresenter;
			 yourself)
]

{ #category : 'initialization' }
MiDistributionMapBrowser >> initializePresenters [

	mainPresenter := self class mapClass owner: self.
	self initializeLayout
]

{ #category : 'initialization' }
MiDistributionMapBrowser >> visualization [

	^ mainPresenter
]
