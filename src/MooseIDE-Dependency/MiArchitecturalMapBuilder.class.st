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
		'tagNodes'
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
		e source belongsTo ~= node belongsTo ifTrue: [ 
			n := self addNode: e source.
			n dependencyTo: anHNode ] ]
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

	"Add to the visualization incoming entities"

	| node incomingLinks |
	node := anHNode rawModel.
	node isTag ifTrue: [ 
		anHNode children do: [ :c | self addOutgoingEntitiesFor: c ].
		^ self ].
	incomingLinks := node queryAllLocal: #out.
	incomingLinks do: [ :e | 
		self addOutgoingNodes: e target asCollection from: anHNode ]
]

{ #category : #adding }
MiArchitecturalMapBuilder >> addOutgoingNodes: aCollection from: anHNode [

	| node |
	node := anHNode rawModel.
	aCollection do: [ :mooseEntity | 
		| n |
		mooseEntity belongsTo ~= node belongsTo ifTrue: [ 
			n := self addNode: mooseEntity.
			anHNode dependencyTo: n ] ]
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
	rootNode := HNode new
		            addAll: (self elements collect: [ :e | 
					             self buildNodeFromEntity: e register: true ]);
		            yourself.
	self addTags.
	self setDependencies.
	self buildLegend.
	super build.
	self updateWithModelSettings
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> buildCompositeEmptyNodeIn: shape [
	| node box rect |
	node := shape model.
	shape addAll: (self nodeStyler labelAndIconFor: node).
	rect := shape children encompassingRectangle.
	box := RSBox new 
		model: node;
		position: rect floatCenter;
		extent: rect extent + 10;
		cornerRadius: self fullCornerRadius;
		color: (self colorFor: node);
		border: (self borderFor: node);
		yourself.
	
	box when: RSMouseDoubleClick do: [ :e | node expandCollapse  ] .
	shape add: box.
	box pushBack.
	shape schildren: #().
	
	shape 
		propertyAt: #background put: box;
		adjustToChildren
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> buildCompositeFullNodeIn: shape [
	| childrenShapes node titleGroup title titleBox children 
	boxChildren titleRadius boxChildrenRadius list |
	node := shape model.
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
	title when: RSMouseDoubleClick do: [ :e | node expandCollapse  ] .
	shape propertyAt: #background put: titleBox.
	childrenShapes := self childrenFor: node.
	self layoutOn: childrenShapes parent: node.
	
	shape schildren: childrenShapes.
	childrenShapes do: [ :child | child sparent: shape ].
	children := childrenShapes asShape
		padding: 6.
	childrenShapes do: [ :child | child model position: child position ].
	title width < children width
		ifTrue: [ titleBox width: children width. title adjustToChildren ]
		ifFalse: [ children width: title width ].
	boxChildren := self boxChildrenFor: node.
	titleRadius := self topCornerRadius.
	boxChildrenRadius := self bottomCornerRadius.
	list := { title. children }.
	self nodeStyler position = #below ifTrue: [ 
		titleRadius := self bottomCornerRadius.
		boxChildrenRadius := self topCornerRadius.
		list := { children. title }.
		 ].
	RSVerticalLineLayout new
		gapSize: 0;
		on: list.
	titleBox cornerRadius: titleRadius.
	boxChildren
		cornerRadius: boxChildrenRadius;
		fromRectangle: children encompassingRectangle.
	
	shape add: title; add: boxChildren; add: children.
	shape adjustToChildren.
	
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
MiArchitecturalMapBuilder >> buildLegend [

	| legend |
	legend := RSLegend new
		          container: self canvas;
		          title: 'Links';
		          onDemand: 'Legend';
		          legendDo: [ :l | 
			          l
				          border: RSBorder new;
				          color: Color white;
				          padding: 10 ];
		          yourself.
	mapModel assocTypeToColorDict keysAndValuesDo: [ :type :color | 
		legend text: type name withBoxColor: color ].
	legend build
]

{ #category : #building }
MiArchitecturalMapBuilder >> buildNodeFromEntity: anEntity [

	| node |
	node := HNode new
		        name:
			        (String streamContents: [ :s | anEntity displayStringOn: s ]);
		        rawModel: anEntity;
		        addAll: ((self mapModel childrenFor: anEntity)
				         collect: [ :e | 
					         anEntity == e ifFalse: [ self buildNodeFromEntity: e ] ]
				         thenSelect: [ :e | e isNotNil ]);
		        collapse;
		        yourself.
	nodeMooseIDDict at: anEntity mooseID put: node.
	allEntities add: anEntity.
	^ node
]

{ #category : #building }
MiArchitecturalMapBuilder >> buildNodeFromEntity: anEntity register: aBoolean [

	| node |
	node := HNode new
		        name:
			        (String streamContents: [ :s | anEntity displayStringOn: s ]);
		        rawModel: anEntity;
		        addAll: ((self mapModel childrenFor: anEntity)
				         collect: [ :e | 
					         anEntity == e ifFalse: [ self buildNodeFromEntity: e register: aBoolean ] ]
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
					         aTag == e ifFalse: [ self buildNodeFromEntity: e register: false ] ]
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

	^ node color ifNil: [ Color gray ] ifNotNil: [ :e | e ]
]

{ #category : #accessing }
MiArchitecturalMapBuilder >> cornerRadius [

	^ 3
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
	tagNodes := OrderedCollection new
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
	parent := anHNode rawModel belongsTo
		          ifNil: [ rootNode ]
		          ifNotNil: [ :p | p ].
	parentNode := nodeMooseIDDict at: parent mooseID ifAbsent: [ nil ].
	parentNode ifNotNil: [ ^ parentNode ].
	parentNode := HNode new
		              rawModel: parent;
		              name:
			              (String streamContents: [ :s | 
					               parent displayStringOn: s ]);
		              yourself.
	rootNode add: parentNode.
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

{ #category : #rendering }
MiArchitecturalMapBuilder >> renderLinesIn: aCanvas [

	super renderLinesIn: aCanvas.
	aCanvas lines do: [ :line |
		(line to model hasTagAncestor or: [ line to model rawModel isTag ]) ifTrue: [ line color: Color yellow ].
		(line from model hasTagAncestor or: [ line from model rawModel isTag ]) ifTrue: [ line color: Color cyan ] ]
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependencies [

	tagNodes do: [ :tagNode | self setDependenciesForTag: tagNode ]
]

{ #category : #building }
MiArchitecturalMapBuilder >> setDependenciesFor: aNode [

	| incoming |
	aNode rawModel class == FamixTag ifTrue: [ ^ self ].
	incoming := aNode rawModel queryAllLocal: #in.
	incoming do: [ :e | 
		(nodeMooseIDDict at: e source mooseID ifAbsent: [ nil ]) ifNotNil: [ 
			:hNode | hNode dependencyTo: aNode ] ]
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
