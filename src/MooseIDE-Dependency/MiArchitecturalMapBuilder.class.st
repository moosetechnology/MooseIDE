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
		'nodesToAdd'
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
		rootNode addAll: (self elements
				 collect: [ :e | self buildNodeFromEntity: e register: true ]
				 thenReject: [ :e | e isNil ]) ].
	self renderIn: self container.
	self updateWithModelSettings.
	^ self container
]

{ #category : #hooks }
MiArchitecturalMapBuilder >> buildCompositeEmptyNodeIn: shape [

	| node box rect entity group |
	node := shape model.
	entity := node rawModel.
	group := self labelAndTagFor: node.
	shape addAll: group.
	rect := shape children encompassingRectangle.
	box := RSBox new
		       model: node;
		       position: rect floatCenter;
		       extent: rect extent + 10;
		       cornerRadius: self fullCornerRadius;
		       color: (self colorFor: node);
		       border: (self borderFor: node);
		       yourself.
	shape add: box.
	box pushBack.
	shape schildren: #(  ).

	shape
		propertyAt: #background put: box;
		adjustToChildren
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> buildCompositeFullNodeIn: shape [

	| childrenShapes node titleGroup title titleBox children boxChildren titleRadius boxChildrenRadius list |
	node := shape model.
	titleGroup := self labelAndTagFor: node.
	titleBox := RSBox new
		            extent: titleGroup extent + 10;
		            color: ((self colorFor: node) alpha: 0.7);
		            position: titleGroup position;
		            yourself.
	title := RSComposite new
		         add: titleBox;
		         addAll: titleGroup;
		         adjustToChildren;
		         yourself.
	shape propertyAt: #background put: titleBox.
	childrenShapes := self childrenFor: node.
	self layoutOn: childrenShapes parent: node.

	shape schildren: childrenShapes.
	childrenShapes do: [ :child | child sparent: shape ].
	children := childrenShapes asShape padding: 6.
	childrenShapes do: [ :child | child model position: child position ].
	title width < children width
		ifTrue: [ 
			titleBox width: children width.
			title adjustToChildren ]
		ifFalse: [ children width: title width ].
	boxChildren := self boxChildrenFor: node.
	titleRadius := self topCornerRadius.
	boxChildrenRadius := self bottomCornerRadius.
	list := { 
		        title.
		        children }.
	self nodeStyler position = #below ifTrue: [ 
		titleRadius := self bottomCornerRadius.
		boxChildrenRadius := self topCornerRadius.
		list := { 
			        children.
			        title } ].
	RSVerticalLineLayout new
		gapSize: 0;
		on: list.
	titleBox cornerRadius: titleRadius.
	boxChildren
		cornerRadius: boxChildrenRadius;
		fromRectangle: children encompassingRectangle.

	shape
		add: title;
		add: boxChildren;
		add: children.
	shape adjustToChildren
]

{ #category : #building }
MiArchitecturalMapBuilder >> buildCompositeFullTagIn: shape [

	| childrenShapes node titleGroup title titleBox children boxChildren titleRadius boxChildrenRadius list childrenGroups childrenShapesGroups |
	node := shape model.
	childrenGroups := self groupTagElements: node.
	titleGroup := self nodeStyler labelAndIconFor: node.
	titleBox := RSBox new
		            extent: titleGroup extent + 10;
		            color: ((self colorFor: node) alpha: 0.7);
		            position: titleGroup position;
		            yourself.
	title := RSComposite new
		         add: titleBox;
		         addAll: titleGroup;
		         adjustToChildren;
		         yourself.
	title when: RSMouseDoubleClick do: [ :e | node expandCollapse ].
	shape propertyAt: #background put: titleBox.
	childrenShapesGroups := RSGroup new.
	childrenShapes := RSGroup new.
	childrenGroups do: [ :group | 
		| cs |
		cs := group collect: [ :child | self shapeFor: child ] as: RSGroup.
		childrenShapes addAll: cs ].

	self layoutOn: childrenShapes parent: node.

	shape schildren: childrenShapes.
	childrenShapes do: [ :child | child sparent: shape ].


	children := childrenShapes asShape padding: 6.
	childrenShapes do: [ :child | child model position: child position ].
	title width < children width
		ifTrue: [ 
			titleBox width: children width.
			title adjustToChildren ]
		ifFalse: [ children width: title width ].
	boxChildren := self boxChildrenFor: node.
	titleRadius := self topCornerRadius.
	boxChildrenRadius := self bottomCornerRadius.
	list := { 
		        title.
		        children }.
	self nodeStyler position = #below ifTrue: [ 
		titleRadius := self bottomCornerRadius.
		boxChildrenRadius := self topCornerRadius.
		list := { 
			        children.
			        title } ].
	RSVerticalLineLayout new
		gapSize: 0;
		on: list.
	titleBox cornerRadius: titleRadius.
	boxChildren
		color: (self colorFor: node);
		cornerRadius: boxChildrenRadius;
		fromRectangle: children encompassingRectangle.

	shape
		add: title;
		add: boxChildren;
		add: children.
	shape adjustToChildren
]

{ #category : #building }
MiArchitecturalMapBuilder >> buildNodeFromEntity: anEntity register: aBoolean [

	| node |
	nodeMooseIDDict at: anEntity mooseID ifPresent: [ ^ nil ].
	node := HNode new
		        name:
			        (String streamContents: [ :s | anEntity displayStringOn: s ]);
		        rawModel: anEntity;
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
MiArchitecturalMapBuilder >> menuInteraction [
	^ menuInteraction ifNil: [ 
		menuInteraction := RSMenuActivable new
			menuDo: [ :menu :aShape | MiArchitecturalMenuItem 
				buildIn: menu 
				shape: aShape 
				visualization: self ];
			yourself 
	]
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

{ #category : #accessing }
MiArchitecturalMapBuilder >> renderIn: aCanvas [
	| rootShapes |
	aCanvas color: Smalltalk ui theme backgroundColor.
	shapes := RSGroup new.
	rootShapes := (rootNode children sort: [ :c1 :c2 | c1 name < c2 name])
		collect: [:child | (self shapeFor: child) sparent: aCanvas ]
		as: RSGroup.
	aCanvas schildren: rootShapes.
	aCanvas addAll: rootShapes.
	aCanvas @ self menuInteraction.
	rootNode when: HNodeAddedEvent do: [ :evt | | newShape |
		newShape := (self shapeFor: evt newChild) sparent: aCanvas.
		newShape position: aCanvas camera position.
		rootShapes add: newShape.
		aCanvas add: newShape.
		 ].
	self renderLinesIn: aCanvas.
	self layoutOn: rootShapes parent: rootNode.
	
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
		
		assocs do: [ :e | 
			nodeMooseIDDict at: e source mooseID ifPresent: [ :hNode |
				hNode
					dependencyTo: (nodeMooseIDDict at: anEntity mooseID)
					withModel: e ] ] ]
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependenciesForTag: aTagNode [

	aTagNode children do: [ :child | self setDependenciesFor: child ]
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> shapeFor: node [

	| shape |
	shape := RSComposite new
		         model: node;
		         announcer: self nodeAnnouncer;
		         yourself.

	(node isExpanded and: [ node hasChildren ])
		ifTrue: [ 
			node rawModel isTag
				ifTrue: [ self buildCompositeFullTagIn: shape ]
				ifFalse: [ self buildCompositeFullNodeIn: shape ] ]
		ifFalse: [ self buildCompositeEmptyNodeIn: shape ].

	node
		removeInteractionIfPresent: self class;
		when: HNodeAddedEvent do: [ :evt | self rebuildRootShape: shape ];
		when: HCollapseEvent do: [ :evt | self rebuildShape: shape ];
		when: HExpandEvent do: [ :evt | self rebuildRootShape: shape ];
		when: HNodeChangedEvent do: [ :evt | self rebuildShape: shape ].
	shapes add: shape.
	^ shape
]

{ #category : #building }
MiArchitecturalMapBuilder >> updateWithModelSettings [
	self setDependencies.
	mapModel showAllLinks
		ifFalse: [ rootNode hideAllLinks ]
		ifTrue: [ rootNode showAllLinks ].
	self rebuildLines: self canvas
]
