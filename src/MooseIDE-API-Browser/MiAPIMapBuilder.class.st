"
The builder for the MiAPIBrowser roassal visualization
"
Class {
	#name : 'MiAPIMapBuilder',
	#superclass : 'HSimpleVisualizationBuilder',
	#instVars : [
		'nodeStyle'
	],
	#category : 'MooseIDE-API-Browser-browser',
	#package : 'MooseIDE-API-Browser',
	#tag : 'browser'
}

{ #category : 'accessing' }
MiAPIMapBuilder >> browser [

	^mapModel browser
]

{ #category : 'building' }
MiAPIMapBuilder >> build [

	self buildNodes.
	self buildDependencies.

	super build.
	"self container shapes do: [ :shape |
		shape isLine ifFalse: [ shape popupText: shape model rawModel mooseName ] ]."

	self layoutNodes
]

{ #category : 'building' }
MiAPIMapBuilder >> buildDependencies [

	self ensureAllNodes do: [ :hnode |
		(self mapModel relatedEntities: hnode rawModel) do: [ :related |
			(self ensureNodeFromEntity: related) dependencyTo: hnode
		]
	]
]

{ #category : 'building' }
MiAPIMapBuilder >> buildNodes [

	rootNode  := HNode new
		addAll: self ensureAllNodes ;
		yourself.
]

{ #category : 'accessing' }
MiAPIMapBuilder >> defaultNodeStyle [

	^self browser defaultNodeStyle
]

{ #category : 'accessing' }
MiAPIMapBuilder >> ensureAllNodes [

	^self mapModel entities collect: [ :fmx | self ensureNodeFromEntity: fmx ]
]

{ #category : 'building' }
MiAPIMapBuilder >> ensureNodeFromEntity: anEntity [

	^ anEntity cacheAt: #p16APIHNode ifAbsentPut: [
			  anEntity removeCache: #highlightList.

			  HNode new
				  name: anEntity fullDisplayString;
				  rawModel: anEntity;
				  style: self nodeStyle;
				  yourself ]
]

{ #category : 'accessing - attributes' }
MiAPIMapBuilder >> hLinkFor: association [

	| hFrom hTo |

	hFrom := self ensureNodeFromEntity: association key.
	hTo := self ensureNodeFromEntity: association value.

	^hFrom dependencies
			detect: [ :hlink | (hlink from = hFrom) and: [ hlink to = hTo ] ]

]

{ #category : 'accessing - attributes' }
MiAPIMapBuilder >> highlightable [
	"this method is lazy, it executes once and then stores the RSInteraction in #highlightable"

	| nodeHighlightColor linkHighlightColor |
	nodeHighlightColor := Color fromHexString: '9DD0B3'.
	linkHighlightColor := Color red.

	^highlightable ifNil: [ 
		highlightable := RSHighlightable new
			highlightShapes: [ :shape | self shapesToHighlightFor: (self modelForShape: shape) ] ;

			when: RSHighlightEvent do: [ :evt |
				highlightable
					record: evt shape
					selector: #color
					value: (evt shape isNode
						ifTrue: [ nodeHighlightColor ]
						ifFalse: [ linkHighlightColor ]) ]
			for: self ;

			when: RSUnHighlightEvent do: [ :evt | 
				highlightable
					restore: evt shape
					selector: #color ]
			for: self ;

			yourself ]
]

{ #category : 'initialization' }
MiAPIMapBuilder >> initialize [ 

	super initialize.

	self popup text: [ :hnode | hnode rawModel mooseName ]
]

{ #category : 'building' }
MiAPIMapBuilder >> layoutNodes [

	| layout shapeLayers |
	shapeLayers := self mapModel layers collect: [ :layer |
			               self container shapesFromModels:
				               (layer collect: [ :fmx | fmx cacheAt: #p16APIHNode ]) ].

	layout := RSVerticalLineLayout new
		          alignCenter;
		          yourself.

	shapeLayers do: [ :sl | layout on: sl ].

	RSHorizontalLineLayout new
		alignMiddle;
		horizontalGap: 250;
		on: shapeLayers
]

{ #category : 'accessing - attributes' }
MiAPIMapBuilder >> linkShapes: associations [

	| linkShapes |
	
	linkShapes := self container shapes select: #isLine.

	^associations
		collect: [ :assoc || shapeFrom shapeTo |
			shapeFrom := self container shapeFromModel: (self ensureNodeFromEntity: assoc key).
			shapeTo := self container shapeFromModel: (self ensureNodeFromEntity: assoc value).

			(shapeFrom isNotNil and: [ shapeTo isNotNil ])
				ifTrue: [
					linkShapes
						detect: [ :link | (link from = shapeFrom) and: [ link to = shapeTo ] ]
						ifNone: [ nil ]
				]
				"ifFalse: [ nil ]"
		]
		thenReject: #isNil
]

{ #category : 'accessing' }
MiAPIMapBuilder >> modelForShape: aShape [

	^aShape model rawModel
]

{ #category : 'accessing - attributes' }
MiAPIMapBuilder >> nodeShapes: famixEntities [

	^ self canvas shapesFromModels:
		  (famixEntities collect: [ :fmx | fmx cacheAt: #p16APIHNode ])
]

{ #category : 'accessing' }
MiAPIMapBuilder >> nodeStyle [

	^ nodeStyle ifNil: [ nodeStyle := self defaultNodeStyle ]
]

{ #category : 'hooks' }
MiAPIMapBuilder >> renderLinesIn: aCanvas [

	self lineBuilder
		canvas: aCanvas;
		shapes: aCanvas nodes;
		connectFromAll: #dependentsFromLinks
]

{ #category : 'accessing - attributes' }
MiAPIMapBuilder >> shapesFromFamixModels: famixEntities [
	"note: both lists or sets, but we cannot use concatenation on sets :-(
	   so we make an OrderedCollection of it"

	^(self nodeShapes: (famixEntities reject: [ :fmx | fmx isAssociation ])) ,
	(self linkShapes: (famixEntities asOrderedCollection select: [ :fmx | fmx isAssociation ]))
	
]

{ #category : 'interactions' }
MiAPIMapBuilder >> shapesToHighlightFor: anEntity [

	^self shapesFromFamixModels: (self mapModel highlightList: anEntity)
]

{ #category : 'interactions' }
MiAPIMapBuilder >> updateTags [ 

	self browser updateTags 
]
