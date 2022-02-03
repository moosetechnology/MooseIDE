"
TODO
"
Class {
	#name : #MiCoUsageMapBuilder,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'godClass',
		'methods',
		'attributes',
		'miMethods',
		'miAttributes',
		'methodAttributeTester',
		'legendTagVisualization',
		'markManager'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #accessing }
MiCoUsageMapBuilder >> attributeNamed: aByteString [
	^ self miAttributes detect: [ :met | met name = aByteString ]
]

{ #category : #hooks }
MiCoUsageMapBuilder >> attributeShapeFor: att method: met [
	^ RSBox new
		model: att;
		width: (att numberOfUsesOn: met) * 5;
		color: (self markManager tagColorFrom: att tag);
		border: (RSBorder new color: Color black; joinMiter);
		addInteraction: self markManager;
		when: RSMouseEnter send: #highlight: to: self;
		when: RSMouseLeave send: #unhighlight: to: self;
		addInteraction: (RSMorphicPopupInteraction new
			morphBuilder: [:model | 
				self createAttributeTextMorphFor: model method: met ];
			yourself);
		yourself.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> attributes [
	^ attributes
]

{ #category : #accessing }
MiCoUsageMapBuilder >> attributes: aCollection [
	attributes := aCollection
]

{ #category : #accessing }
MiCoUsageMapBuilder >> canvasController [
	^ RSCanvasController simple
]

{ #category : #'popup - hooks' }
MiCoUsageMapBuilder >> createAttributeTextMorphFor: att method: met [
	^ (att asStringForMethod: met) asTextMorph
		backgroundColor: (Smalltalk ui theme backgroundColor alpha: 0.8);
		borderColor: Color black;
		borderWidth: 1;
		margins: 15;
		yourself
]

{ #category : #'popup - hooks' }
MiCoUsageMapBuilder >> createMethodTextMorphFor: model [
	^ model asString asTextMorph
		backgroundColor: (Smalltalk ui theme backgroundColor alpha: 0.8);
		borderColor: Color black;
		borderWidth: 1;
		margins: 15;
		yourself
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultLayout [
	^ RSFlowLayout new
		gapSize: 20;
		yourself
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultLegendTagVisualization [
	^ MiCoTagVisualization new
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultMarkManager [
	^ MiCoMarkManager new
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultMaxLabelWidth [
	^ 200
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultSortBlock [
	^ [ :met1 :met2 | 
		| size1 size2 |
		size1 := met1 usedAttributes size.
		size2 := met2 usedAttributes size.
		size1 = size2 
			ifTrue: [ met1 name < met2 name ]
			ifFalse: [ size1 > size2 ]
		 ].
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultTester [
	^ MiCoPharoMethodAttributeTester new
]

{ #category : #accessing }
MiCoUsageMapBuilder >> godClass [
	^ godClass
]

{ #category : #accessing }
MiCoUsageMapBuilder >> godClass: aClass [
	godClass := aClass.
	self attributes: aClass instVarNames.
	self methods: aClass methods.
]

{ #category : #highlighting }
MiCoUsageMapBuilder >> highlight: evt [
	| border attributeShapes | 
	attributeShapes := evt canvas deepShapesFromModel: evt shape model.
	evt canvas propertyAt: #highlighShapes put: attributeShapes.
	border := self selectedBoxBorder.
	attributeShapes do: [ :shape | shape border: border ].
	evt signalUpdate.
	
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initialize [
	super initialize.
	self
		attributes: #();
		methods: #();
		methodAttributeTester: self defaultTester;
		legendTag: self defaultLegendTagVisualization;
		markManager: self defaultMarkManager.
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeAttributes [
	miAttributes := self attributes collect: [ :att |
		MiCoAttribute new
			name: att asString;
			yourself ] as: OrderedCollection
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeMethods [
	miMethods := self methods collect: [ :met | 
		MiCoMethod new
			name: met selector;
			rawObject: met;
			yourself ] as: OrderedCollection.
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeReferences [
	self miMethods do: [ :met | 
		self miAttributes do: [ :att | | counter | 
			counter := self methodAttributeTester numberOfUsesOf: att on: met.
			counter > 0 ifTrue: [ 
				att method: met counter: counter.
				met addAttribute: att.
				 ].
			 ].
		 ].
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeValues [
	self 
		initializeAttributes;
		initializeMethods;
		initializeReferences.
	miMethods sort: self defaultSortBlock
	
]

{ #category : #hooks }
MiCoUsageMapBuilder >> labelShapeFor: met [
	| label |
	label := RSLabel new
		text: met name;
		color: Color black;
		yourself.
	self resizeLabelIfNecessary: label.
	^ label.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> legendTag [
	^ legendTagVisualization
]

{ #category : #accessing }
MiCoUsageMapBuilder >> legendTag: aMiCoTagVisualization [ 
	legendTagVisualization := aMiCoTagVisualization
]

{ #category : #accessing }
MiCoUsageMapBuilder >> markManager [
	^ markManager
]

{ #category : #accessing }
MiCoUsageMapBuilder >> markManager: aMiCoMarkManager [
	markManager := aMiCoMarkManager.
	markManager coUsageMap: self.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> maxLabelWidth [
	^ 200
]

{ #category : #accessing }
MiCoUsageMapBuilder >> methodAttributeTester [
	^ methodAttributeTester
]

{ #category : #accessing }
MiCoUsageMapBuilder >> methodAttributeTester: aMiCoMethodAttributeTester [
	methodAttributeTester := aMiCoMethodAttributeTester
]

{ #category : #hooks }
MiCoUsageMapBuilder >> methodBodyShapeFor: met [
	| attributesShapes |
	attributesShapes := met usedAttributes collect: [ :att | 
		self
			attributeShapeFor: att
			method: met ].
	RSFlowLayout on: attributesShapes.
	^ attributesShapes asGroup asShape
		padding: 10;
		color: (self markManager tagColorFrom: met tag);
		border: (RSBorder new color: Color black; joinMiter);
		yourself.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> methodNamed: aByteString [
	^ self miMethods detect: [ :met | met name = aByteString ]
]

{ #category : #hooks }
MiCoUsageMapBuilder >> methodShapeFor: met [
	| label body |
	label := self labelShapeFor: met.
	body := self methodBodyShapeFor: met.
	RSVerticalLineLayout new
		alignCenter;
		gapSize: 0;
		on: { label. body }.
	^ MiCoMethodShape new
		model: met;
		addAll: { label. body };
		adjustToChildren;
		addInteraction: self markManager;
		addInteraction: (RSMorphicPopupInteraction new
			morphBuilder: [:model | self createMethodTextMorphFor: model ];
			yourself);
		yourself
]

{ #category : #accessing }
MiCoUsageMapBuilder >> methods [
	^ methods
]

{ #category : #accessing }
MiCoUsageMapBuilder >> methods: aCollection [
	methods := aCollection
]

{ #category : #accessing }
MiCoUsageMapBuilder >> miAttributes [
	^ miAttributes
]

{ #category : #accessing }
MiCoUsageMapBuilder >> miMethods [
	^ miMethods
]

{ #category : #opening }
MiCoUsageMapBuilder >> open [
	| window morph scrollPane |
	true ifTrue: [ 
		^ super open
			extent: 1000@ 800;
			setLabel:  (godClass
				ifNil: [ 'Empty' ]
				ifNotNil: ['God Class - ', godClass name ]);
			yourself ].
	self build.
	morph := self canvas createMorph.
	morph extent: self canvas fixedShapes encompassingRectangle extent+50.
	window := SystemWindow new.
	scrollPane := ScrollPane new.
	scrollPane scroller addMorph: morph.
	window addMorph: scrollPane frame: (0@0 corner: 1@1).
	window extent: 1000@ 800.
	window openInWorld.
	window setLabel: (godClass
		ifNil: [ 'Empty' ]
		ifNotNil: ['God Class - ', godClass name ]).
	^ window
]

{ #category : #hooks }
MiCoUsageMapBuilder >> renderIn: aCanvas [
	self initializeValues.
	
	shapes := self miMethods collect: [ :met | self methodShapeFor: met ].
	aCanvas addAll: shapes.
	self defaultLayout on: shapes.
	self legendTag
		container: aCanvas;
		build.
	
	aCanvas addInteraction: self markManager.
	aCanvas @ self canvasController
]

{ #category : #hooks }
MiCoUsageMapBuilder >> resizeLabelIfNecessary: label [
	| maxWidth text scale mid1 mid2 flag |
	text := label text.
	maxWidth := self defaultMaxLabelWidth.
	maxWidth := self maxLabelWidth.
	label textWidth < maxWidth
		ifTrue: [ ^ self ].
	scale := maxWidth / label textWidth.
	mid1 := (text size / 2) asInteger -1.
	mid2 := mid1 + 1.
	flag := true.
	[ scale < 0.6 ] whileTrue: [ 
		| newText |
		newText := (text copyFrom: 1 to: mid1),'...',(text copyFrom: mid2 to: text size).
		label text: newText.
		scale := maxWidth / label textWidth.
		flag 
			ifTrue: [ mid1 := mid1 - 1 ]
			ifFalse: [ mid2 := mid2 + 1].
		flag := flag not.
	 ].
	label scaleBy: scale @ 1.
]

{ #category : #highlighting }
MiCoUsageMapBuilder >> selectedBoxBorder [
	^ RSBorder new 
		color: Color orange;
		width: 3;
		joinMiter;
		yourself.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> tagNamed: aString [ 
	^ self legendTag tagNamed: aString
]

{ #category : #highlighting }
MiCoUsageMapBuilder >> unhighlight: evt [
	| border attributeShapes key |
	key := #highlighShapes.
	attributeShapes := evt canvas propertyAt: key ifAbsent: [ #() ].
	border := RSBorder new color: Color black; joinMiter.
	attributeShapes do: [ :shape | shape border: border ].
	evt canvas removeKey: key.
	evt signalUpdate.
	
]

{ #category : #public }
MiCoUsageMapBuilder >> updateShapeColors [
	self canvas allChildren
		select: [ :shape | shape model notNil ]
		thenDo: [ :shape | shape color: (self markManager tagColorFrom: shape model tag) ].
	self canvas signalUpdate.
]
