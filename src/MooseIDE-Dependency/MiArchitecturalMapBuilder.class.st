"
I am a builder of a hierarchical map using HierarchicalMapModel.

Nodes are colored according to properties.

I am responsible for :
- creating the nodes for each entity
- display the nodes on a canvas
- color the nodes according to their property
"
Class {
	#name : #MiArchitecturalMapBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'mapModel',
		'nodeMooseIDDict',
		'allEntities',
		'tagNodes',
		'nodesToAdd',
		'highlightShapes'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #adding }
MiArchitecturalMapBuilder >> addIncomingEntitiesFor: anHNode [

	"Add to the visualization incoming entities"

	| node incomingLinks |
	node := anHNode rawModel.
	node isTag ifTrue: [ 
		anHNode children do: [ :c | self addIncomingEntitiesFor: c ].
		^ self ].
	incomingLinks := node queryAllLocal: #in.
	incomingLinks do: [ :e | 
		| n |
		(e source parents intersection: node parents) ifEmpty: [ 
			n := self addNode: e source.
			n dependencyTo: anHNode ] ]
]

{ #category : #adding }
MiArchitecturalMapBuilder >> addIncomingsFor: anHNode [

	self addIncomingEntitiesFor: anHNode.
	nodesToAdd valuesDo: [ :node | rootNode add: node ].
	nodesToAdd := Dictionary new.
	self renderLinesIn: self container.
	self container signalUpdate
]

{ #category : #adding }
MiArchitecturalMapBuilder >> addNode: mooseEntity [

	| node parentNode |
	nodeMooseIDDict at: mooseEntity mooseID ifPresent: [ :n | ^ n ].
	node := HNode new
		        name:
			        (String streamContents: [ :s | 
					         mooseEntity displayStringOn: s ]);
		        rawModel: mooseEntity;
		        yourself.

	parentNode := self parentNodeFor: node.
	nodeMooseIDDict at: mooseEntity mooseID put: node.
	parentNode add: node.
	^ node
]

{ #category : #adding }
MiArchitecturalMapBuilder >> addOutgoingEntitiesFor: anHNode [

	"Add to the visualization outgoing entities"

	| node outgoingLinks |
	node := anHNode rawModel.
	node isTag ifTrue: [ 
		anHNode children do: [ :c | self addOutgoingEntitiesFor: c ].
		^ self ].
	outgoingLinks := node queryAllLocal: #out.
	outgoingLinks do: [ :e | 
		self addOutgoingNodes: e target asCollection from: anHNode ]
]

{ #category : #adding }
MiArchitecturalMapBuilder >> addOutgoingNodes: aCollection from: anHNode [

	| node |
	node := anHNode rawModel.
	aCollection do: [ :mooseEntity | 
		| n |
		(mooseEntity parents intersection: node parents) ifEmpty: [ 
			n := self addNode: mooseEntity.
			anHNode dependencyTo: n ] ]
]

{ #category : #adding }
MiArchitecturalMapBuilder >> addOutgoingsFor: anHNode [

	self addOutgoingEntitiesFor: anHNode.
	nodesToAdd valuesDo: [ :node | rootNode add: node ].
	nodesToAdd := Dictionary new.
	self renderLinesIn: self container.
	self container signalUpdate
]

{ #category : #building }
MiArchitecturalMapBuilder >> addTags [

	rootNode addAll: (mapModel tags collect: [ :e | 
					             self buildNodeFromTag: e ])
]

{ #category : #'public - hooks' }
MiArchitecturalMapBuilder >> borderFor: node [

	| border |
	border := RSBorder new
		          width: 2;
		          capSquare;
		          joinMiter;
		          color: Smalltalk ui theme borderColor translucent;
		          yourself.
	node hasChildren ifTrue: [ 
		^ border
			  color: Smalltalk ui theme textColor;
			  dashArray: #( 1 5 );
			  yourself ].
	^ border
]

{ #category : #building }
MiArchitecturalMapBuilder >> build [

	rootNode ifNotNil: [ 
		self updateWithModelSettings.
		^ self ].
	rootNode := HNode new.
	self addTags.
	mapModel showBusEntities ifTrue: [ 
		rootNode addAll: self createRootNodes ].
	self renderIn: self container.
	self updateWithModelSettings.
	^ self container
]

{ #category : #building }
MiArchitecturalMapBuilder >> buildNodeFromEntity: anEntity register: aBoolean [

	| node |
	nodeMooseIDDict at: anEntity mooseID ifPresent: [ ^ nil ].
	node := HNode new
		        name:
			        (String streamContents: [ :s | anEntity displayStringOn: s ]);
		        rawModel: anEntity;
		        style: MiHArchitecturalMapStyle new;
		        addAll:
			        (((self mapModel childrenFor: anEntity) sort: [ :c1 :c2 | 
					          c1 name < c2 name ])
				         collect: [ :e | 
					         anEntity == e ifFalse: [ 
							         self buildNodeFromEntity: e register: aBoolean ] ]
				         thenSelect: [ :e | e isNotNil ]);
		        collapse;
		        yourself.
	aBoolean ifTrue: [ 
		nodeMooseIDDict at: anEntity mooseID put: node.
		allEntities add: anEntity ].

	^ node
]

{ #category : #building }
MiArchitecturalMapBuilder >> buildNodeFromTag: aTag [

	| node |
	node := HNode new
		        name:
			        (String streamContents: [ :s | aTag displayStringOn: s ]);
		        rawModel: aTag;
		        addAll: (aTag taggedEntities
				         collect: [ :e | 
					         aTag == e ifFalse: [ 
							         self buildNodeFromEntity: e register: true ] ]
				         thenSelect: [ :e | e isNotNil ]);
		        color: aTag color;
		        collapse;
		        yourself.
	tagNodes add: node.
	^ node
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> childrenBlock [

	^ mapModel childrenBlock
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> colorFor: node [

	^ node color ifNil: [ Smalltalk ui theme baseColor ] 
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> cornerRadius [

	^ 3
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> createMultiTagBoxSized: aSize [

	| cp |
	cp := RSComposite new.
	cp addAll: ({ 
			 Color red.
			 Color cyan.
			 Color green.
			 Color yellow } collect: [ :color | 
			 RSBox new
				 size: aSize / 2;
				 color: color;
				 yourself ]).
	RSGridLayout new
		lineItemsCount: 2;
		gapSize: 0;
		on: cp children.
	cp adjustToChildren.
	cp border: (RSBorder new
			 color: Color black;
			 width: 1;
			 yourself).
	^ cp
]

{ #category : #building }
MiArchitecturalMapBuilder >> createRootNodes [

	^ (self elements
		   collect: [ :e | self buildNodeFromEntity: e register: true ]
		   thenReject: [ :e | e isNil ]) sort: [ :a :b | a name < b name ]
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> elements [

	^ mapModel entities
]

{ #category : #building }
MiArchitecturalMapBuilder >> groupTagElements: aTag [

	| classDict |
	classDict := Dictionary new.
	aTag children do: [ :e | 
		| c |
		c := classDict
			     at: e rawModel class
			     ifAbsent: [ OrderedCollection new ].
		c add: e.
		classDict at: e rawModel class put: c ].
	^ classDict values
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> highlightableLinkedShapes [

	^ highlightShapes ifNil: [ 
		  highlightShapes := RSHighlightable new
			                     highlightShapes: [ :shape | 
				                     | list |
				                     list := Set new.
				                     shape connectedLines do: [ :line | 
						                     shape = line from
							                     ifTrue: [ 
								                     list add:
										                     (line to propertyAt: #background) ]
							                     ifFalse: [ 
								                     list add:
										                     (line from propertyAt: #background) ] ].
				                     list asOrderedCollection ];
			                     when: RSHighlightEvent do: [ :evt | 
				                     | color |
				                     color := Color fromHexString: '9DD0B3'.
				                     highlightable
					                     record: evt shape
					                     selector: #color
					                     value: color ];
			                     when: RSUnHighlightEvent
			                     do: [ :evt | 
				                     highlightable
					                     restore: evt shape
					                     selector: #color ];
			                     yourself ]
]

{ #category : #initialization }
MiArchitecturalMapBuilder >> initialize [

	super initialize.
	nodeMooseIDDict := Dictionary new.
	allEntities := MooseGroup new.
	tagNodes := OrderedCollection new.
	nodesToAdd := Dictionary new
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> labelAndTagFor: node [

	| group entity |
	group := self nodeStyler labelAndIconFor: node.
	entity := node rawModel.
	(entity notNil and: [ entity isTag not and: [ entity isTagged ] ]) 
		ifTrue: [ 
			| tag |
			tag := entity allTags first.
			group addFirst: (RSCircle new
					 color: tag color;
					 radius: 7;
					 yourself) ].
	node children ifNotEmpty: [ 
		| tags |
		tags := Set new.
		node children do: [ :child | 
			child rawModel isTagged ifTrue: [ 
				tags add: child rawModel allTags first ] ].
		tags size = 1 ifTrue: [ 
			group addLast: (RSBox new
					 color: tags anyOne color;
					 size: 14;
					 yourself) ].
		tags size > 1 ifTrue: [ 
			group addLast: (self createMultiTagBoxSized: 14) ] ].
	RSHorizontalLineLayout new
		alignMiddle;
		on: group.
	^ group
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> mapModel [

	^ mapModel
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> mapModel: anObject [

	mapModel := anObject
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> menuItemStrategy [

	^ MiArchitecturalMenuItemStrategy new
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> nodeAnnouncer [

	"plug new events here"

	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		            @ self popup;
		            @
			            (HGhostDraggable new color:
					             Smalltalk ui theme caretColor);
		            @ self menuInteraction;
		            @ self highlightable;
		            @ self highlightableLinkedShapes;
		            @ RSNodeOnTopWhenPositionChanged new;
		            @ HUpdateSelectionBox new;
		            @ HResizeParentWhenChildMoves new;
		            yourself.
	^ baseNode announcer
]

{ #category : #adding }
MiArchitecturalMapBuilder >> parentNodeFor: anHNode [

	"Search for parent node in the node dictionary, add it if not present."

	| parentNode parent |
	parent := anHNode rawModel parents
		          ifEmpty: [ rootNode ]
		          ifNotEmpty: [ :parents | parents anyOne ].
	parentNode := nodeMooseIDDict at: parent mooseID ifAbsent: [ nil ].
	parentNode ifNotNil: [ ^ parentNode ].
	parentNode := HNode new
		              rawModel: parent;
		              name:
			              (String streamContents: [ :s | 
					               parent displayStringOn: s ]);
		              collapse;
		              yourself.

	nodesToAdd at: parent mooseID put: parentNode.
	nodeMooseIDDict at: parent mooseID put: parentNode.
	^ parentNode
]

{ #category : #initialization }
MiArchitecturalMapBuilder >> relayout: aGroupOfShapes parent: shape [
	
	shape layout ifNil: [ 
		RSFlowLayout new
			gapSize: 10;
			on: aGroupOfShapes. 
		^ self ].
	shape layout on: aGroupOfShapes.
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependencies [

	tagNodes do: [ :tagNode | self setDependenciesForTag: tagNode ].
	allEntities do: [ :e | self setDependenciesForEntity: e ]
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependenciesFor: aNode [

	| incoming |
	aNode rawModel class == FamixTag ifTrue: [ ^ self ].
	incoming := aNode rawModel queryAllLocal: #in.
	incoming do: [ :e | 
		(nodeMooseIDDict at: e source mooseID ifAbsent: [ nil ]) ifNotNil: [ 
			:hNode | hNode dependencyTo: aNode withModel: e ] ]
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependenciesForEntity: anEntity [

	| associationTypes |
	associationTypes := mapModel associationTypes.

	associationTypes do: [ :at | 
		| assocs |
		assocs := anEntity queryLocal: #in with: at.

		assocs do: [ :dep | 
			(mapModel noMegaMorphic and:
			[ dep isInvocation and:
			[ dep candidates size > mapModel megaMorphicSize ]])
			ifFalse: [ self setDependency: dep forEntity: anEntity ] ] ]
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependenciesForTag: aTagNode [

	aTagNode children do: [ :child | self setDependenciesFor: child ]
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependency: e forEntity: anEntity [

	^ nodeMooseIDDict at: e source mooseID ifPresent: [ :hNode | 
		  hNode
			  dependencyTo: (nodeMooseIDDict at: anEntity mooseID)
			  withModel: e ]
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> shapeFor: node [

	^ node asShape
]

{ #category : #building }
MiArchitecturalMapBuilder >> updateWithModelSettings [
	self setDependencies.
	mapModel showAllLinks
		ifFalse: [ rootNode hideAllLinks ]
		ifTrue: [ rootNode showAllLinks ].
	self rebuildLines: self canvas
]
