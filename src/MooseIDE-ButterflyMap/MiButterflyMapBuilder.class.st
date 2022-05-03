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
	self updateShapes.
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
	centralShape := (self shapeFor: centralNode) sparent: self container.
	butterfly := ButterflyTree new
		             root: centralShape;
		             yourself.

	butterfly lBlock: [ :e | 
		e model rawModel allClients collect: [ :c | 
			| hNode shape |
			hNode := self buildNodeFromEntity: c.
			rootNode add: hNode.
			hNode dependencyTo: e model.
			shape := self shapeFor: hNode.
			shape sparent: self container.
			shape ] ].
	butterfly rBlock: [ :e | 
		e model rawModel allProviders collect: [ :p | 
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
		        rawModel: anEntity;
		        collapse;
		        yourself.
	^ node
]

{ #category : #rendering }
MiButterflyMapBuilder >> buildShapes [

	| allShapes leftLayers rightLayers layout |
	incomingGroups := OrderedCollection new.
	outgoingGroups := OrderedCollection new.
	leftLayers := butterfly leftTree layers.
	rightLayers := butterfly rightTree layers.
	layout := RSVerticalLineLayout new.
	allShapes := OrderedCollection new.
	leftLayers do: [ :layer | 
		allShapes addAll: layer.
		layout on: layer.
		incomingGroups add: layer ].

	rightLayers do: [ :layer |
		allShapes addAll: layer.
		layout on: layer.
		outgoingGroups add: layer ].
	^ allShapes
]

{ #category : #building }
MiButterflyMapBuilder >> initialize [

	super initialize.
	self linkStyler: (HLinkStyler new
			 lineBuilder:
				 (RSLineBuilder arrowedLineWithOffset: 0.5) withHorizontalAttachPoint;
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
		@ self nodeStyler popup;
		@ (HGhostDraggable new 
			color: Smalltalk ui theme caretColor);
		@ self menuInteraction;
		@ self highlightable;
		@ (RSNodeOnTopWhenPositionChanged new);
		@ (HUpdateSelectionBox new);
		@ (HResizeParentWhenChildMoves new nodeStyler: self nodeStyler);
		yourself.
	^ baseNode announcer
	
]

{ #category : #adding }
MiButterflyMapBuilder >> removeLevel [
	
	1halt.
	butterfly removeLevel.
	self updateShapes.
	"[ :shape |
	shape model remove.
	shape connectedLines do: #remove.
	shape remove  ]"
	"mapModel level: mapModel level - 1.
	mapModel level traceCr.
	incomingGroups last do: [ :shape | 
		rootNode children remove: shape model.
		shape model removeAllLinks.
		mooseNodeDictLeft
			removeKey: shape model rawModel mooseID.
		shape connectedLines do: #remove.
		shape remove ].
	incomingGroups removeLast.

	outgoingGroups last do: [ :shape | 
		rootNode children remove: shape model.
		shape model removeAllLinks.
		mooseNodeDictRight
			removeKey: shape model rawModel mooseID.
		shape connectedLines do: #remove.
		shape remove ].
	outgoingGroups removeLast.
	self container signalUpdate"
]

{ #category : #rendering }
MiButterflyMapBuilder >> renderIn: aCanvas [

	| rootShapes |
	aCanvas color: Smalltalk ui theme backgroundColor.
	rootShapes := self buildShapes , { centralShape }.
	aCanvas schildren: rootShapes.
	aCanvas addAll: rootShapes.
	aCanvas @ self menuInteraction.
	self renderLinesIn: aCanvas.
	self layoutButterfly.
]

{ #category : #adding }
MiButterflyMapBuilder >> updateShapes [

	| allShapes leftLayers rightLayers layout |
	incomingGroups := OrderedCollection new.
	outgoingGroups := OrderedCollection new.
	leftLayers := butterfly leftTree layers.
	rightLayers := butterfly rightTree layers.
	layout := RSVerticalLineLayout new.
	allShapes := OrderedCollection new.
	leftLayers do: [ :layer | 
		allShapes addAll: layer.
		layout on: layer.
		incomingGroups add: layer ].

	rightLayers do: [ :layer | 
		allShapes addAll: layer.
		layout on: layer.
		outgoingGroups add: layer ].

	self container addAll: allShapes.
	self container schildren: allShapes , { centralShape }.
	self renderLinesIn: self container.
	self layoutButterfly
]
