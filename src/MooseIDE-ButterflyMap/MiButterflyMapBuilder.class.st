Class {
	#name : #MiButterflyMapBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'mapModel',
		'incomingShapes',
		'outgoingShapes',
		'centralNode',
		'centralShape'
	],
	#category : #'MooseIDE-ButterflyMap'
}

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

	| incomingNodes node outgoingNodes |
	node := centralNode rawModel.
	incomingNodes := (node queryAll: #in) collect: [ :assoc | 
		                 | newNode source |
		                 source := assoc source isCollection
			                           ifTrue: [ assoc source first ]
			                           ifFalse: [ assoc source ].
		                 newNode := self buildNodeFromEntity: source.
		                 rootNode add: newNode.
		                 newNode dependencyTo: centralNode.
		                 incomingShapes add:
			                 ((self shapeFor: newNode) sparent: self container) ].
	outgoingNodes := (node queryAll: #out) collect: [ :assoc | 
		                 | newNode target |
		                 target := assoc target isCollection
			                           ifTrue: [ assoc target first ]
			                           ifFalse: [ assoc target ].
		                 newNode := self buildNodeFromEntity: target.
		                 rootNode add: newNode.
		                 centralNode dependencyTo: newNode.
		                 outgoingShapes add:
			                 ((self shapeFor: newNode) sparent: self container) ]
]

{ #category : #building }
MiButterflyMapBuilder >> buildNodeFromEntity: anEntity [

	| node |
	node := HNode new
		        name:
			        (String streamContents: [ :s | anEntity displayStringOn: s ]);
		        rawModel: anEntity;
		        collapse;
		        yourself.
	^ node
]

{ #category : #building }
MiButterflyMapBuilder >> initialize [

	super initialize.
	self linkStyler: (HLinkStyler new
			 lineBuilder:
				 RSLineBuilder horizontalBezier withHorizontalAttachPoint;
			 yourself).
	shapes := RSGroup new.
	incomingShapes := RSGroup new.
	outgoingShapes := RSGroup new
]

{ #category : #accessing }
MiButterflyMapBuilder >> mapModel [

	^ mapModel
]

{ #category : #accessing }
MiButterflyMapBuilder >> mapModel: anObject [

	mapModel := anObject
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

{ #category : #rendering }
MiButterflyMapBuilder >> renderIn: aCanvas [

	| rootShapes |
	aCanvas color: Smalltalk ui theme backgroundColor.
	centralShape := (self shapeFor: centralNode) sparent: aCanvas.
	rootShapes := incomingShapes , { centralShape } , outgoingShapes.
	RSVerticalLineLayout new
		on: outgoingShapes;
		on: incomingShapes.
	aCanvas schildren: rootShapes.
	aCanvas addAll: rootShapes.
	aCanvas @ self menuInteraction.
	rootNode when: HNodeAddedEvent do: [ :evt | 
		| newShape |
		newShape := (self shapeFor: evt newChild) sparent: aCanvas.
		newShape position: aCanvas camera position.
		rootShapes add: newShape.
		aCanvas add: newShape.
		aCanvas signalUpdate ].
	self renderLinesIn: aCanvas.
	RSHorizontalLineLayout new
		horizontalGap: 150;
		alignMiddle;
		on: { 
				incomingShapes.
				centralShape.
				outgoingShapes }
]
