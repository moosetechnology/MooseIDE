"
Main builder for *CoUsageMap*.

I create a Roassal canvas with boxes,
Outer boxes are container, or representation of methods from a class
Inner boxes are content, or representation of attributes from a class used from a method.

Note: an attribute can be used by different methods.

Width of each attbute is the total number of uses of that attribute in all containers (or methods).

"
Class {
	#name : #MiCoUsageMapBuilder,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'highlightManager',
		'containerBox',
		'innerBox',
		'legendTagBuilder',
		'methodAttributeCounter',
		'methods',
		'miAttributes',
		'miMethods',
		'widthScale',
		'visualization',
		'menuManager',
		'strategies'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #accessing }
MiCoUsageMapBuilder >> application [

	^self specModel currentApplication
]

{ #category : #hooks }
MiCoUsageMapBuilder >> applyLayout [
	| canvas |
	canvas := self canvas.
	RSFlowLayout new
		maxWidth: canvas extent x * (1/ canvas camera scale);
		gapSize: 20;
		on: canvas nodes.
	
]

{ #category : #accessing }
MiCoUsageMapBuilder >> attributeNamed: aByteString [
	^ self miAttributes detect: [ :met | met name = aByteString ]
]

{ #category : #hooks }
MiCoUsageMapBuilder >> attributeShapeFor: att method: met [
	| height |
	height := self settings innerBoxHeight.
	^ RSBox new
		model: att;
		width: (widthScale scale: (att numberOfUses));
		height: height;
		color: (self tagColorFrom: att tag);
		border: (self highlightManager defaultBoxBorder);
		propertyAt: #method put: met;
		announcer: innerBox announcer;
		yourself.
]

{ #category : #public }
MiCoUsageMapBuilder >> automaticColor [
	self flag: 'to move to specModel'.
	self changeTagsDuring: [ 
		self miMethods 
			do:[:met | self automaticColorForMethod: met ].
	]
	
]

{ #category : #public }
MiCoUsageMapBuilder >> automaticColorForMethod: aMiCoMethod [
	| groupsByTag |
	groupsByTag := aMiCoMethod innerBoxes 
		groupedBy: [ :att | att tag ].
	groupsByTag ifEmpty: [
		 "nothing to compare" ^ self ].
	self strategies do: [ :strat |
		strat
			method: aMiCoMethod;
			groupsByTag: groupsByTag.
		strat computeTag ifNotNil: [ :tag | 
			self setTag: tag onAttribute: aMiCoMethod.
			^ self ].
	].
	self setTag: nil onAttribute: aMiCoMethod.
	
	
	
	
	
]

{ #category : #'private - testing' }
MiCoUsageMapBuilder >> buildForTest [
	self renderIn: self container job: MiJob new.
	^ self container
]

{ #category : #accessing }
MiCoUsageMapBuilder >> canvasController [
	^ RSCanvasController simple
]

{ #category : #private }
MiCoUsageMapBuilder >> changeTagsDuring: aBlockClosure [
	| lastTag |
	lastTag := self lastTagSelected.
	aBlockClosure value.
	self lastTagSelected: lastTag
]

{ #category : #accessing }
MiCoUsageMapBuilder >> conflictTag [
	^ self legendTagBuilder conflictTag
]

{ #category : #'popup - hooks' }
MiCoUsageMapBuilder >> createAttributeTextMorphFor: att method: met [
	^ (att asStringForMethod: met) asTextMorph
		backgroundColor: (Smalltalk ui theme backgroundColor alpha: 0.9);
		borderColor: Color black;
		borderWidth: 1;
		margins: 15;
		yourself
]

{ #category : #'popup - hooks' }
MiCoUsageMapBuilder >> createMethodTextMorphFor: model [
	^ model asString asTextMorph
		backgroundColor: (Smalltalk ui theme backgroundColor alpha: 0.9);
		borderColor: Color black;
		borderWidth: 1;
		margins: 15;
		yourself
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultHighlightManager [
	^ MiCoHighlightManager new
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultInnerSortBlock [
	^ [ :att1 :att2 :method | att1 name < att2 name ].
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultMarkManager [
	^ MiCoMenuManager new
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultMaxLabelWidth [
	^ 200
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultSettings [
	^ MiCoUsageMapSettings
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultSortBlock [
	^ [ :met1 :met2 | 
		| size1 size2 |
		size1 := met1 innerBoxes size.
		size2 := met2 innerBoxes size.
		size1 = size2 
			ifTrue: [ met1 name < met2 name ]
			ifFalse: [ size1 > size2 ]
		 ].
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultTagLegendBuilder [
	^ MiCoTagLegendBuilder new
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultTester [
	^ MiCoFromSettingsMethodAttributeTester new
]

{ #category : #accessing }
MiCoUsageMapBuilder >> getBoxFor: object [
	^(self getContainerBoxFor: object) ifNil: [ self getInnerBoxFor: object ]
]

{ #category : #accessing }
MiCoUsageMapBuilder >> getContainerBoxFor: object [
	^self miMethods
		detect: [ :box | box mooseEntity = object ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MiCoUsageMapBuilder >> getInnerBoxFor: object [
	^self miAttributes
		detect: [ :att | att mooseEntity = object ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MiCoUsageMapBuilder >> getOrCreateAttributeFor: object [
	^ (self getInnerBoxFor: object)
		ifNil: [ miAttributes add: (self newInnerBoxFor: object) ]
]

{ #category : #accessing }
MiCoUsageMapBuilder >> highlightManager [
	^ highlightManager
]

{ #category : #accessing }
MiCoUsageMapBuilder >> highlightManager: aMiCoHighlightManager [
	highlightManager := aMiCoHighlightManager
]

{ #category : #accessing }
MiCoUsageMapBuilder >> iconForTag: aTag [
	^self application iconForTag: aTag
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initialize [
	super initialize.

	strategies := (MiCoMarkStrategy subclasses collect: #new) sorted: [ :a :b | a order < b order ].
	self
		methods: #();
		methodAttributeCounter: self defaultTester;
		legendTagBuilder: self defaultTagLegendBuilder;
		menuManager: self defaultMarkManager;
		highlightManager: self defaultHighlightManager;
		initializeShapes
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeMethods [
	miMethods := self methods 
		collect: [ :met | self newContainerBoxFor: met ]
		as: OrderedCollection.
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeReferences [
	miAttributes := OrderedCollection new.

	self methodAttributeCounter settings: self settings.
	
	self miMethods do: [ :met | 
		| bag |
		bag := Bag withAll: (self methodAttributeCounter allAttributesFor: met).
		bag doWithOccurrences: [ :attribute :count | | att |
			count > 0 ifTrue: [ 
				att := self getOrCreateAttributeFor: attribute.
				met addInnerBox: att.
				att containerBox: met numberOfUses: count.
			].
		].
	]
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeScale [
	| allAttributesUses range scaleType cls |
	allAttributesUses := self miMethods flatCollect: [ :met | 
		met innerBoxes collect: [ :att | att numberOfUses ] ].
	cls := MiCoUsageMapSettings.
	range := cls innerBoxRange.
	scaleType := cls innerBoxScaleType.
	
	widthScale := (scaleType value: NSScale)
		range: {range first. range last}.
	allAttributesUses ifEmpty: [ ^ self ].
	widthScale domain: {allAttributesUses min. allAttributesUses max}.
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeShapes [
	"all this interaction will produce an announcer that we can reuse for new shapes"
	innerBox := RSBox new
		addInteraction: self menuManager;
		addInteraction: self highlightManager;
		addInteraction: (RSMorphicPopupInteraction new
			model: #yourself;
			morphBuilder: [:shape | 
				self 
					createAttributeTextMorphFor: shape model
					method: (shape propertyAt: #method) ];
			yourself).
	
	containerBox := RSComposite new
		addInteraction: self menuManager;
		addInteraction: self highlightManager;
		addInteraction: (RSMorphicPopupInteraction new
			morphBuilder: [:model | self createMethodTextMorphFor: model ];
			yourself);
		yourself.
	
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeValues [
	self
		initializeMethods;
		initializeReferences;
		initializeScale.
]

{ #category : #hooks }
MiCoUsageMapBuilder >> labelShapeFor: met [
	| label |
	label := RSLabel new
		text: met name;
		color: Color black;
		yourself.
	self resizeLabelIfNecessary: label.
	^ label
]

{ #category : #accessing }
MiCoUsageMapBuilder >> lastTagSelected [
	self flag: 'should be in specModel'.
	^self application tagSelectedInMooseModel: self specModel currentMooseModel
]

{ #category : #accessing }
MiCoUsageMapBuilder >> lastTagSelected: aTag [ 
	self application selectedTag: aTag
]

{ #category : #accessing }
MiCoUsageMapBuilder >> legendTagBuilder [
	^ legendTagBuilder
]

{ #category : #accessing }
MiCoUsageMapBuilder >> legendTagBuilder: aMiCoTagLegendBuilder [ 
	legendTagBuilder := aMiCoTagLegendBuilder.
	legendTagBuilder mapBuilder: self.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> maxLabelWidth [
	^ 200
]

{ #category : #accessing }
MiCoUsageMapBuilder >> menuManager [
	^ menuManager
]

{ #category : #accessing }
MiCoUsageMapBuilder >> menuManager: aMiCoMarkManager [
	menuManager := aMiCoMarkManager.
	menuManager mapBuilder: self.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> methodAttributeCounter [
	^ methodAttributeCounter
]

{ #category : #accessing }
MiCoUsageMapBuilder >> methodAttributeCounter: aMiCoMethodAttributeCounter [
	methodAttributeCounter := aMiCoMethodAttributeCounter
]

{ #category : #hooks }
MiCoUsageMapBuilder >> methodBodyShapeFor: met [
	| attributesShapes |
	attributesShapes := met innerBoxes collect: [ :att | 
		self
			attributeShapeFor: att
			method: met ].
	"RSFlowLayout on: attributesShapes."
	^ attributesShapes asGroup asShape
		padding: 10;
		color: (self tagColorFrom: met tag);
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
		announcer: containerBox announcer;
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

{ #category : #'instance creation' }
MiCoUsageMapBuilder >> newContainerBoxFor: anObject [
	"| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ]."
	^ MiCoContainerBox new
		mooseEntity: anObject;
		yourself
]

{ #category : #'instance creation' }
MiCoUsageMapBuilder >> newInnerBoxFor: anObject [
	| tags |
	tags := anObject allTagAssociations collect: [ :asso | asso tag ].
	tags := tags
		ifEmpty: [ nil ]
		ifNotEmpty: [ tags anyOne ].
	^ MiCoInnerBox new
		mooseEntity: anObject;
		yourself
]

{ #category : #events }
MiCoUsageMapBuilder >> quickTaggingOn: entity [ 
	self lastTagSelected
	ifNil: [ ^ self ].

	self setTag: self lastTagSelected onAttribute: entity

]

{ #category : #dependencies }
MiCoUsageMapBuilder >> release [
	super release.
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #hooks }
MiCoUsageMapBuilder >> renderAsync: aCanvas [
	[ :aJob | self renderIn: aCanvas job: aJob ] runAsRoassalJobOn: aCanvas.
	"[ :aJob | self renderIn: aCanvas job: aJob ] asJob run."
]

{ #category : #hooks }
MiCoUsageMapBuilder >> renderIn: aCanvas [
	self shouldUseProgressBar
		ifTrue: [ self renderAsync: aCanvas ]
		ifFalse: [ self renderIn: aCanvas job: MiJob new ].
	
]

{ #category : #hooks }
MiCoUsageMapBuilder >> renderIn: aCanvas job: aJob [
	aCanvas aaFast.
	aJob currentValue: 0; title: 'Reading entities'.
	self initializeValues.
	aJob currentValue: 50; title: 'Rendering entities'.
	shapes := self miMethods collect: [ :met | self methodShapeFor: met ].
	aCanvas addAll: shapes.
	
	aJob currentValue: 85; title: 'Applying layout'.
	self updateShapeLayout.
	aJob currentValue: 90; title: 'Adding decorations'.
	self legendTagBuilder
		container: aCanvas;
		build.
	aCanvas 
		when: RSExtentChangedEvent send: #applyLayout to: self;
		addInteraction: self highlightManager;
		addInteraction: self menuManager;
		addInteraction: self canvasController.
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

{ #category : #initialization }
MiCoUsageMapBuilder >> setTag: aTag onAttribute: aBox [
	"send to specModel through the MapVisualization"
	self flag: 'lastTagSelected should be in specModel'.
	self lastTagSelected: aTag.
	visualization setTag: aTag onEntity: aBox mooseEntity
]

{ #category : #accessing }
MiCoUsageMapBuilder >> settings [
	^visualization settings
]

{ #category : #testing }
MiCoUsageMapBuilder >> shouldUseProgressBar [
	^ true
]

{ #category : #public }
MiCoUsageMapBuilder >> sortShapes [
	| block children tBlock |
	block := self settings outerBoxSortBlockCompiled.
	tBlock := [ :a :b | block value: a model value: b model ].
	children := self canvas children.
	[ children sort: tBlock ]
	onErrorDo: [ :ex | 
		block := self defaultSortBlock.
		children sort: tBlock ].
	block := self settings innerBoxSortBlockCompiled.
	children do: [ :node |
		tBlock := [ :a :b | 
			block value: a model value: b model value: node model ].
		[ node attributeShapes sort: tBlock  ]
		onErrorDo: [ :ex |
			block := self defaultInnerSortBlock.
			node attributeShapes sort: tBlock ]
	]

]

{ #category : #accessing }
MiCoUsageMapBuilder >> specModel [
	^visualization specModel
]

{ #category : #accessing }
MiCoUsageMapBuilder >> strategies [
	^ strategies
]

{ #category : #accessing }
MiCoUsageMapBuilder >> tagColorFrom: tags [
	tags ifNil:  [ ^ Color colorFrom: 'f5f5f5' ].
	(tags isCollection and: [ tags isEmpty ]) ifTrue: [ ^ Color colorFrom: 'f5f5f5' ].
	(tags isCollection and: [ tags size = 1 ]) ifTrue: [ ^ self tagColorFrom: tags anyOne ].
	tags isCollection ifTrue: [ ^ Color black ].

	(tags isTag and: [ tags isHidden ]) ifTrue: [ ^ Color colorFrom: 'f5f5f5' ].
	tags isTag ifTrue: [ ^ tags color ].
	^ Error signal: 'A famixTag was expected'
]

{ #category : #accessing }
MiCoUsageMapBuilder >> tagNamed: aString [ 
	^ self legendTagBuilder tagNamed: aString
]

{ #category : #accessing }
MiCoUsageMapBuilder >> tags [
	^self specModel tagList
]

{ #category : #update }
MiCoUsageMapBuilder >> threshold75: aNumber [
	self assert: (aNumber between: 0 and: 100) description: 'use number between 0 and 100'.

	self strategies 
		detect: [ :strat | strat class = MiCo75PercentageMarkStrategy ]
		ifFound: [ :strat | strat threshold: aNumber / 100.0 ]
		ifNone: [  ]
]

{ #category : #update }
MiCoUsageMapBuilder >> updateChildren [
	| canvas |
	canvas := self canvas.
	canvas nodes copy do: #remove.
	self initializeValues.
	shapes := self miMethods collect: [ :met | self methodShapeFor: met ].
	canvas addAll: shapes.
	self sortShapes.
	self applyLayout.
	canvas signalUpdate.
]

{ #category : #update }
MiCoUsageMapBuilder >> updateInnerBoxSize [
	| range newScale scaleType |
	range := self settings innerBoxRange.
	scaleType := self settings innerBoxScaleType.
	widthScale ifNil: [ ^ self ].
	newScale := (scaleType value: NSScale)
		domain: widthScale domain;
		range: {range first. range last}.
	widthScale := newScale.
	self canvas nodes do: [ :node |
		| met body label |
		met := node model.
		label := node shapes first.
		node children size > 1 ifTrue: [ 
			body := node children second.
			body remove.
			body withAllChildren do: [ :each | each announcer: nil ] ].
		
		body := self methodBodyShapeFor: met.
		node add: body.
		RSVerticalLineLayout new
			alignCenter;
			gapSize: 0;
			on: { label. body }.
		node adjustToChildren.
	].
	self updateShapeLayout
]

{ #category : #update }
MiCoUsageMapBuilder >> updateLegend [

	visualization ifNil: [ ^ self ].

	legendTagBuilder removeOldLegend.
	legendTagBuilder build.
	self updateShapeColors.
]

{ #category : #update }
MiCoUsageMapBuilder >> updateShapeColors [
	self canvas allChildren
		select: [ :shape | shape model notNil ]
		thenDo: [ :shape | shape color: (self tagColorFrom: shape model tag) ].
	self canvas signalUpdate.
]

{ #category : #update }
MiCoUsageMapBuilder >> updateShapeLayout [
	| children |
	self sortShapes.
	children := self canvas nodes.
	children do: [ :child | 
		RSFlowLayout on: child attributeShapes.
		child children second adjustToChildren; padding: 10.
		RSVerticalLineLayout new
			alignCenter;
			gapSize: 0;
			on: child children.
		child adjustToChildren ].
	self applyLayout.
	self canvas signalUpdate.
]

{ #category : #public }
MiCoUsageMapBuilder >> updateTagColorFor: anEntity [
	| tagColor entityBox |
	tagColor := self tagColorFrom: anEntity allTags .
	entityBox := self getBoxFor: anEntity.
	(self canvas deepShapesFromModel: entityBox) 
		do: [ :shape | shape color: tagColor ].
	self canvas signalUpdate.

]

{ #category : #accessing }
MiCoUsageMapBuilder >> visualization [
	^ visualization
]

{ #category : #accessing }
MiCoUsageMapBuilder >> visualization: aMiCoUsageMapVisualization [

	visualization := aMiCoUsageMapVisualization.
]
