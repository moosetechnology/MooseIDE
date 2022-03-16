"
I am a builder of a distribution map using HierarchicalMapModel.

I am responsible for :
- creating the parts for each container
- display the containers on a canvas
- color the parts according to their property
"
Class {
	#name : #MiDistributionMapBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'mapModel'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #hooks }
MiDistributionMapBuilder >> adjustLabel: aLabel ToWidth: width [

	| sizeOfNewText font text |
	font := aLabel font.
	text := aLabel text.
	aLabel textWidth > width ifFalse: [ ^ self ].
	sizeOfNewText := 1.
	[ (font widthOfString: text from: 1 to: sizeOfNewText) < width ] 
		whileTrue: [ sizeOfNewText := sizeOfNewText + 1 ].
	aLabel text: (text truncateTo: sizeOfNewText - 1),'.'
]

{ #category : #building }
MiDistributionMapBuilder >> build [
	rootNode := HNode new
		            addAll:
			            ((mapModel orderOuterNodes: self elements) collect: [ 
					             :e | self buildNodeFromEntity: e ]);
		            yourself.
	self buildLegend.
	self renderIn: self container.
	^ self container
]

{ #category : #hooks }
MiDistributionMapBuilder >> buildCompositeEmptyNodeIn: shape [

	| node box rect |
	node := shape model.

	rect := shape children encompassingRectangle.
	box := RSBox new
		       model: node;
		       width: self elementWidth;
		       height: self elementWidth;
		       color: (self colorFor: node);
		       border: (RSBorder new
				        width: 1;
				        capSquare;
				        joinMiter;
				        color: Smalltalk ui theme borderColor translucent;
				        yourself);
		       yourself.
	shape add: box.
	box pushBack.
	shape schildren: #(  ).

	shape propertyAt: #background put: box
]

{ #category : #hooks }
MiDistributionMapBuilder >> buildCompositeFullNodeIn: shape [

	| childrenShapes node titleGroup title titleBox children boxChildren titleRadius boxChildrenRadius list |
	node := shape model.
	titleGroup := self nodeStyler labelAndIconFor: node.

	titleBox := RSBox new
		           extent: titleGroup extent;
		            color: Color transparent;
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
	children := childrenShapes asShape padding: 3.
	childrenShapes ifEmpty: [ children extent: self emptyBoxExtent].
	childrenShapes do: [ :child | child model position: child position ].
	title width: children width.
	
	titleBox width: children width.
	self adjustLabel: (titleGroup at: 1) ToWidth: children width. 

	boxChildren := RSBox new
		               color: Color transparent;
		               yourself.
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
		border: (RSBorder new
				 width: 1;
				 color: Smalltalk ui theme textColor;
				 yourself);
		fromRectangle: children encompassingRectangle.

	shape
		add: title;
		add: boxChildren;
		add: children.
	shape adjustToChildren
]

{ #category : #building }
MiDistributionMapBuilder >> buildLegend [

	| legend |
	legend := RSLegend new
		          container: self canvas;
		          title: 'Dynamic tags';
		          onDemand: 'Legend';
		          legendDo: [ :l | 
			          l
				          border: RSBorder new;
				          color: Color white;
				          padding: 10 ];
		          yourself.
	mapModel dynamicTags do: [ :dt | 
		legend
			text: dt name
			withBoxColor: (self mapModel colorForDynamicTag: dt) ].
	legend build
]

{ #category : #building }
MiDistributionMapBuilder >> buildNodeFromEntity: anEntity [
	
	^ HNode new
		  name:
			  (String streamContents: [ :s | anEntity displayStringOn: s ]);
		  rawModel: anEntity;
		  addAll: ((self mapModel childrenFor: anEntity) collect: [ :n | 
					   HNode new
						   name: (String streamContents: [ :s | n displayStringOn: s ]);
						   rawModel: n;
						   yourself ]);
		  expand;
		  yourself
]

{ #category : #building }
MiDistributionMapBuilder >> childrenFor: node [

	| groups dts |
	dts := mapModel dynamicTags.
	groups := OrderedCollection new.
	dts size + 1 timesRepeat: [ groups add: OrderedCollection new ].
	node children do: [ :child | 
		(groups at: (1 + (mapModel indexOfDynamicTagFor: child rawModel))) 
			add: (self shapeFor: child) ].
	^ groups flatCollect: [ :child | child ] as: RSGroup.
]

{ #category : #building }
MiDistributionMapBuilder >> colorFor: node [

	node level > 1 ifTrue: [ ^ mapModel colorFor: node rawModel ].
	^ Color gray
]

{ #category : #hooks }
MiDistributionMapBuilder >> elementWidth [

	^ 10
]

{ #category : #accessing }
MiDistributionMapBuilder >> elements [

	^ mapModel entities
]

{ #category : #hooks }
MiDistributionMapBuilder >> emptyBoxExtent [

	^ 30@20
]

{ #category : #hooks }
MiDistributionMapBuilder >> layoutOn: aGroupOfShapes parent: shape [
	aGroupOfShapes ifEmpty: [ ^ self ].
	self relayout: aGroupOfShapes parent: shape.
	
	
]

{ #category : #accessing }
MiDistributionMapBuilder >> mapModel [

	^ mapModel
]

{ #category : #accessing }
MiDistributionMapBuilder >> mapModel: anObject [

	mapModel := anObject
]

{ #category : #accessing }
MiDistributionMapBuilder >> menuInteraction [
	^ menuInteraction ifNil: [ 
		menuInteraction := RSMenuActivable new
			menuDo: [ :menu :aShape | MiDMMenuItem 
				buildIn: menu 
				shape: aShape 
				visualization: self ];
			yourself 
	]
]

{ #category : #hooks }
MiDistributionMapBuilder >> nodeAnnouncer [
	"plug new events here"
	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		@ self nodeStyler popup;
		@ self menuInteraction;
		@ self highlightable;
		@ (HUpdateSelectionBox new);
		yourself.
	^ baseNode announcer
]

{ #category : #hooks }
MiDistributionMapBuilder >> relayout: aGroupOfShapes parent: shape [

	RSFlowLayout new
		gapSize: (shape level = 0
				 ifTrue: [ 10 ]
				 ifFalse: [ 3 ]);
		on: aGroupOfShapes
]

{ #category : #accessing }
MiDistributionMapBuilder >> renderIn: aCanvas [

	| rootShapes |
	aCanvas color: Smalltalk ui theme backgroundColor.
	rootShapes := rootNode children 
		collect: [:child | (self shapeFor: child) sparent: aCanvas ]
		as: RSGroup.
	aCanvas addAll: rootShapes.
	self layoutOn: rootShapes parent: rootNode
]

{ #category : #accessing }
MiDistributionMapBuilder >> shapeFor: node [

	| shape |
	shape := RSComposite new
		model: node;
		announcer: self nodeAnnouncer;
		yourself.
	
	(node level = 1) 
		ifTrue: [ self buildCompositeFullNodeIn: shape ]
		ifFalse: [ self buildCompositeEmptyNodeIn: shape ].
	
	^ shape 
]
