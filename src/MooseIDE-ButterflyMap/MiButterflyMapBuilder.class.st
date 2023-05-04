Class {
	#name : #MiButterflyMapBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'mapModel',
		'incomingGroups',
		'outgoingGroups',
		'centralNode',
		'centralShape',
		'butterfly'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #adding }
MiButterflyMapBuilder >> addLevel [

	butterfly addLevel.
	self updateShapes
]

{ #category : #adding }
MiButterflyMapBuilder >> addNodesFor: aShape [

	butterfly generateChildrenFor: aShape.
	self updateShapes
]

{ #category : #building }
MiButterflyMapBuilder >> build [

	centralNode := self buildNodeFromEntity: self mapModel currentEntity.
	rootNode := HNode new
		            add: centralNode;
		            yourself.
	self buildButterflyNodes.
	super build
]

{ #category : #building }
MiButterflyMapBuilder >> buildButterflyNodes [

	| node |
	node := centralNode rawModel.
	centralNode color: (Color fromHexString: '4EC8B0').
	centralShape := (self shapeFor: centralNode) sparent: self container.
	butterfly := ButterflyTree new
		             root: centralShape;
		             yourself.

	butterfly lBlock: [ :e | 
		(self mapModel leftEntitiesFor: e model rawModel) collect: [ :c | 
			| hNode shape |
			hNode := self buildNodeFromEntity: c.
			rootNode add: hNode.
			hNode dependencyTo: e model.
			shape := self shapeFor: hNode.
			shape sparent: self container.
			shape ] ].
	butterfly rBlock: [ :e | 
		(self mapModel rightEntitiesFor: e model rawModel) collect: [ :p | 
			| hNode shape |
			hNode := self buildNodeFromEntity: p.
			rootNode add: hNode.
			e model dependencyTo: hNode.
			shape := self shapeFor: hNode.
			shape sparent: self container.
			shape ] ].
	butterfly addLevel
]

{ #category : #building }
MiButterflyMapBuilder >> buildNodeFromEntity: anEntity [

	| node |
	node := HNode new
		        name:
			        (String streamContents: [ :s | anEntity displayStringOn: s ]);
		        addAll: ((self mapModel childrenFor: anEntity)
				         collect: [ :e | 
					         anEntity == e ifFalse: [ self buildNodeFromEntity: e ] ]
				         thenSelect: [ :e | e isNotNil ]);
		        color: (Smalltalk ui theme baseColor alpha: 0.7);
		        rawModel: anEntity;
		        collapse;
		        yourself.
	^ node
]

{ #category : #rendering }
MiButterflyMapBuilder >> buildShapes [

	| allShapes leftLayers rightLayers layout layoutLeft |
	incomingGroups := OrderedCollection new.
	outgoingGroups := OrderedCollection new.
	leftLayers := butterfly leftTree layers.
	rightLayers := butterfly rightTree layers.
	(layout := RSVerticalLineLayout new) alignRight.
	layoutLeft := RSVerticalLineLayout new alignLeft; yourself.
	allShapes := OrderedCollection new.
	leftLayers do: [ :layer | 
		allShapes addAll: layer.
		layout on: layer.
		incomingGroups add: layer ].

	rightLayers do: [ :layer |
		allShapes addAll: layer.
		layoutLeft on: layer.
		outgoingGroups add: layer ].
	^ allShapes
]

{ #category : #accessing }
MiButterflyMapBuilder >> centralNode [

	^ centralNode
]

{ #category : #accessing }
MiButterflyMapBuilder >> centralNode: anObject [

	centralNode := anObject
]

{ #category : #building }
MiButterflyMapBuilder >> colorFor: node [

	^ node color ifNil: [ Color fromHexString: '6DAFDC' ] ifNotNil: [ :color | color ]
]

{ #category : #building }
MiButterflyMapBuilder >> initialize [

	super initialize.
	self linkStyler: (HLinkStyler new
			 lineBuilder:
				 (RSLineBuilder arrowedLineWithOffset: 0.5)
					 withHorizontalAttachPoint;
			 yourself).
	shapes := RSGroup new.
	incomingGroups := OrderedCollection new.
	outgoingGroups := OrderedCollection new
]

{ #category : #rendering }
MiButterflyMapBuilder >> layoutButterfly [

	RSHorizontalLineLayout new
		alignMiddle;
		horizontalGap: 250;
		on: incomingGroups reversed , { centralShape } , outgoingGroups
]

{ #category : #accessing }
MiButterflyMapBuilder >> mapModel [

	^ mapModel
]

{ #category : #accessing }
MiButterflyMapBuilder >> mapModel: anObject [

	mapModel := anObject
]

{ #category : #accessing }
MiButterflyMapBuilder >> menuInteraction [
	^ menuInteraction ifNil: [
		menuInteraction := RSMenuActivable new
			menuDo: [ :menu :aShape | MiButterflyMenuItem 
				buildIn: menu 
				shape: aShape 
				visualization: self ];
			yourself 
	]
]

{ #category : #hooks }
MiButterflyMapBuilder >> nodeAnnouncer [

	"plug new events here"

	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		            @ self popup;
		            @ RSDraggable new;
		            @ self menuInteraction;
		            @ self highlightable;
		            @ RSNodeOnTopWhenPositionChanged new;
		            @ HUpdateSelectionBox new;
		            @ HResizeParentWhenChildMoves new;
		            yourself.
	^ baseNode announcer
]

{ #category : #removing }
MiButterflyMapBuilder >> removeLevel [
	
	
	butterfly removeLevel.
	self updateShapes.
]

{ #category : #removing }
MiButterflyMapBuilder >> removeNode: aShape [

	butterfly remove: aShape.
	self updateShapes
]

{ #category : #removing }
MiButterflyMapBuilder >> removeNodesFor: aShape [

	butterfly removeChildrenFor: aShape.
	self updateShapes
]

{ #category : #rendering }
MiButterflyMapBuilder >> renderIn: aCanvas [

	aCanvas color: Smalltalk ui theme backgroundColor.
	"RSZoomToFitCanvasInteraction new animatedZoomToFit: aCanvas."
	aCanvas @ self menuInteraction.
	self updateShapes
]

{ #category : #rendering }
MiButterflyMapBuilder >> renderLinesIn: aCanvas [
	
	self lineBuilder
		canvas: aCanvas;
		shapes: aCanvas nodes;
		connectFromAll: #dependentsFromLinks
]

{ #category : #updating }
MiButterflyMapBuilder >> updateCentralNode: anEntity [ 
	
	self mapModel currentEntity: anEntity.
	self build
]

{ #category : #rendering }
MiButterflyMapBuilder >> updateShapes [

	| allShapes leftLayers rightLayers layout rightLayout |
	incomingGroups := OrderedCollection new.
	outgoingGroups := OrderedCollection new.

	leftLayers := butterfly leftTree layers.
	rightLayers := butterfly rightTree layers.
	layout := RSVerticalLineLayout new
		          alignRight;
		          yourself.
	rightLayout := RSVerticalLineLayout new
		               alignLeft;
		               yourself.
	allShapes := OrderedCollection new.
	leftLayers do: [ :layer | 
		allShapes addAll: layer.
		layout on: layer.
		incomingGroups add: layer ].

	rightLayers do: [ :layer | 
		allShapes addAll: layer.
		rightLayout on: layer.
		outgoingGroups add: layer ].

	self addInteractions: allShapes , { centralShape }.
	self container addAll: allShapes , { centralShape }.
	self container schildren: allShapes , { centralShape }.
	self renderLinesIn: self container.
	self layoutButterfly.
	self container signalUpdate.
	self container zoomToFit
]
