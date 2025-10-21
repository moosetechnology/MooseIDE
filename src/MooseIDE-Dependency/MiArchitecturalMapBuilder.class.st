"
I am a builder of a hierarchical map using HierarchicalMapModel.

Nodes are colored according to properties.

I am responsible for :
- creating the nodes for each entity
- display the nodes on a canvas
- color the nodes according to their property
"
Class {
	#name : 'MiArchitecturalMapBuilder',
	#superclass : 'HSimpleVisualizationBuilder',
	#instVars : [
		'nodeMooseIDDict',
		'allEntities',
		'tagNodes',
		'nodesToAdd',
		'highlightShapes'
	],
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'adding' }
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

{ #category : 'adding' }
MiArchitecturalMapBuilder >> addIncomingsFor: anHNode [

	self addIncomingEntitiesFor: anHNode.
	nodesToAdd valuesDo: [ :node | rootNode add: node ].
	nodesToAdd := Dictionary new.
	self renderLinesIn: self container.
	self container signalUpdate
]

{ #category : 'adding' }
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

{ #category : 'adding' }
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

{ #category : 'adding' }
MiArchitecturalMapBuilder >> addOutgoingNodes: aCollection from: anHNode [

	| node |
	node := anHNode rawModel.
	aCollection do: [ :mooseEntity | 
		| n |
		(mooseEntity parents intersection: node parents) ifEmpty: [ 
			n := self addNode: mooseEntity.
			anHNode dependencyTo: n ] ]
]

{ #category : 'adding' }
MiArchitecturalMapBuilder >> addOutgoingsFor: anHNode [

	self addOutgoingEntitiesFor: anHNode.
	nodesToAdd valuesDo: [ :node | rootNode add: node ].
	nodesToAdd := Dictionary new.
	self renderLinesIn: self container.
	self container signalUpdate
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> addTags [

	rootNode addAll: (mapModel tags collect: [ :e | 
					             self buildNodeFromTag: e ])
]

{ #category : 'public - hooks' }
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

{ #category : 'building' }
MiArchitecturalMapBuilder >> build [

	rootNode ifNotNil: [
			self updateWithModelSettings.
			^ self ].
	rootNode := HNode new.
	self addTags.
	mapModel hideReceivedEntities ifFalse: [
		rootNode addAll: self createRootNodes ].

	"dependencies must be computed before rendering because some layout depend on them"
	self setDependencies.

	self renderIn: self container.
	self updateWithModelSettings.

	^ self container
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> buildChildrenNodesFrom: anEntity [

	^ ((self mapModel childrenFor: anEntity)
		   collect: [ :childEntity | self buildNodeFromEntity: childEntity ]
		   thenSelect: [ :childNode | childNode isNotNil ]) sort: [ :c1 :c2 | c1 name < c2 name ]
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> buildChildrenNodesFromTag: aTag [

	| nodes |
	nodes := (aTag taggedEntities collect: [ :taggedEntity | self buildNodeFromEntity: taggedEntity ]) reject: [ :childNode |
		         childNode isNil or: [ childNode parent isNotNil ] ].

	"When we open the architectural on tags it might be hard to distinguish the entities. For example I have a cas where I had 15 methods names #write tagged with the same tag. 
With Imen we propose to display also the name of the parent entity in the label to recognize better the entities when their parent is a tag"
	nodes do: [ :childNode |
		| entity |
		entity := childNode rawModel.
		childNode name: (String streamContents: [ :stream |
				 entity belongsTo ifNotNil: [ :parent |
					 stream
						 nextPutAll: parent name;
						 nextPut: $. ].
				 stream nextPutAll: entity name ]) ].

	^ nodes sort: [ :a :b | a name < b name ]
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> buildNodeFrom: aMooseEntity [

	^ aMooseEntity isTag
		  ifTrue: [ self buildNodeFromTag: aMooseEntity ]
		  ifFalse: [ self buildNodeFromEntity: aMooseEntity ]
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> buildNodeFromEntity: anEntity [

	| node |
	nodeMooseIDDict at: anEntity mooseID ifPresent: [ :n |
		n parent ifNil: [ ^ n ].
		^ nil ].

	node := HNode new
		        name: anEntity fullDisplayString;
		        rawModel: anEntity;
		        style: self nodeStyle;
		        addAll: (self buildChildrenNodesFrom: anEntity);
		        collapse;
		        yourself.

	nodeMooseIDDict at: anEntity mooseID put: node.
	allEntities add: anEntity.

	^ node
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> buildNodeFromTag: aTag [

	| node |
	node := HNode new
		        name: (String streamContents: [ :s | aTag displayStringOn: s ]);
		        rawModel: aTag;
		        style: self nodeStyle;
		        addAll: (self buildChildrenNodesFromTag: aTag);
		        color: aTag color;
		        collapse;
		        yourself.
	tagNodes add: node.
	^ node
]

{ #category : 'accessing' }
MiArchitecturalMapBuilder >> colorFor: node [

	^ node color ifNil: [ Smalltalk ui theme baseColor ] 
]

{ #category : 'accessing' }
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

{ #category : 'building' }
MiArchitecturalMapBuilder >> createRootNodes [

	^ (mapModel rootNodes
		   collect: [ :e | self buildNodeFrom: e ]
		   thenReject: [ :node | node isNil ]) sort: [ :a :b | a name < b name ]
]

{ #category : 'accessing' }
MiArchitecturalMapBuilder >> defaultNodeStyle [

	^MiArchitecturalMapStyle new
]

{ #category : 'accessing' }
MiArchitecturalMapBuilder >> elements [

	^ mapModel entities
]

{ #category : 'building' }
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

{ #category : 'accessing' }
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
					                     value: color ]
			                     for: self;
			                     when: RSUnHighlightEvent
			                     do: [ :evt | 
				                     highlightable
					                     restore: evt shape
					                     selector: #color ]
			                     for: self;
			                     yourself ]
]

{ #category : 'initialization' }
MiArchitecturalMapBuilder >> initialize [

	super initialize.
	nodeMooseIDDict := Dictionary new.
	allEntities := OrderedCollection new.
	tagNodes := OrderedCollection new.
	nodesToAdd := Dictionary new.
	self popup text: [ :model | self tooltipOf: model rawModel ]
]

{ #category : 'accessing' }
MiArchitecturalMapBuilder >> menuItemStrategy [

	^ MiArchitecturalMenuItemStrategy new
]

{ #category : 'hooks' }
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
		            @ HResizeParentWhenChildMoves new;
		            yourself.

	baseNode
		when: RSMouseDoubleLeftClick
		do: [ :event | mapModel doubleClickActOn: event shape ]
		for: self.

	^ baseNode announcer
]

{ #category : 'adding' }
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

{ #category : 'layout' }
MiArchitecturalMapBuilder >> relayout: aGroupOfShapes parent: shape [

	shape layout ifNil: [
			mapModel layout new on: aGroupOfShapes.
			^ self ].
	shape layout on: aGroupOfShapes
]

{ #category : 'interactions' }
MiArchitecturalMapBuilder >> selectRelatedTo: anEntity [ 

	| shape |
	shape := container nodes detect: [ :node | node model rawModel = anEntity ] ifNone: [ ^self ].
	container  setSelectedShapes:
		shape outgoingShapes , shape incomingShapes
]

{ #category : 'hooks' }
MiArchitecturalMapBuilder >> renderLinesIn: aCanvas [

	| label |

	super renderLinesIn: aCanvas.

	aCanvas lines do: [ :line |
		line model: (line from model allRawModelDependenciesIn: line to model)
	].

	self mapModel weightedLinks ifFalse: [ ^self ].

	label := RSLabeled new text: [ :dependencies | dependencies size asString ].
	label location
		middle.

	aCanvas lines do: [ :line |
		label onShape: line
	].
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> setDependencies [

	tagNodes do: [ :tagNode | self setDependenciesForTag: tagNode ].
	allEntities do: [ :e | self setDependenciesForEntity: e ]
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> setDependenciesForEntity: anEntity [

	anEntity isQueryable ifFalse: [ ^ self ].

	mapModel associationTypes do: [ :associationType |
			(anEntity queryLocal: #in with: associationType) do: [ :dependency |
					(mapModel shouldHideDependency: dependency) ifFalse: [
						self setDependency: dependency forEntity: anEntity ] ] ]
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> setDependenciesForTag: aTagNode [

	aTagNode children do: [ :child |
		child rawModel isTag ifFalse: [
			(child rawModel queryAllLocal: #in) do: [ :incommingDependency |
				(nodeMooseIDDict at: incommingDependency source mooseID ifAbsent: [ nil ]) ifNotNil: [ :hNode | hNode dependencyTo: child withModel: incommingDependency ] ] ] ]
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> setDependency: e forEntity: anEntity [

	e source ifNil: [ ^nil ].
	^ nodeMooseIDDict at: e source mooseID ifPresent: [ :hNode | 
		  hNode
			  dependencyTo: (nodeMooseIDDict at: anEntity mooseID)
			  withModel: e ]
]

{ #category : 'accessing' }
MiArchitecturalMapBuilder >> tooltipOf: entity [

	^ String streamContents: [ :s |
			  s << entity miDescription.

			  entity isTag ifFalse: [
					  entity tags ifNotEmpty: [ :tags |
							  s << '
Tags: '.
							  tags do: [ :tag | s << tag name ] separatedBy: [ s << ', ' ] ].

					  ((nodeMooseIDDict at: entity mooseID) allChildren
						   flatCollectAsSet: [ :child | child rawModel tags ])
						  ifNotEmpty: [ :tags |
								  s << '
Tags on children: '.
								  tags do: [ :tag | s << tag name ] separatedBy: [ s << ', ' ] ] ] ]
]

{ #category : 'building' }
MiArchitecturalMapBuilder >> updateWithModelSettings [
	"used to compute dependencies here, but they are needed by some layout (ex: TreeLayout)
	 so it was moved into #build method"

	mapModel showAllLinks
		ifFalse: [ rootNode hideAllLinks ]
		ifTrue: [ rootNode showAllLinks ].
	self rebuildLines: self canvas
]
