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
		'legendTagBuilder',
		'widthScale',
		'visualization',
		'menuManager',
		'innerBoxInteraction',
		'containerBoxInteraction'
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
MiCoUsageMapBuilder >> canvasController [
	^ RSCanvasController simple
]

{ #category : #accessing }
MiCoUsageMapBuilder >> colorFromTags: tags [
	tags ifNil:  [ ^ Color colorFrom: 'f5f5f5' ].
	(tags isCollection and: [ tags isEmpty ]) ifTrue: [ ^ Color colorFrom: 'f5f5f5' ].
	(tags isCollection and: [ tags size = 1 ]) ifTrue: [ ^ self colorFromTags: tags anyOne ].
	tags isCollection ifTrue: [ ^ Color black ].

	(tags isTag and: [ tags isHidden ]) ifTrue: [ ^ Color colorFrom: 'f5f5f5' ].
	tags isTag ifTrue: [ ^ tags color ].
	^ Error signal: 'A famixTag was expected'
]

{ #category : #hooks }
MiCoUsageMapBuilder >> containerBoxBodyShapeFor: containerBox [
	| attributesShapes |
	attributesShapes := containerBox innerBoxes collect: [ :innerBox | 
		self
			innerBoxShapeFor: innerBox
			containerBox: containerBox ].
	"RSFlowLayout on: attributesShapes."
	^ attributesShapes asGroup asShape
		padding: 10;
		color: (self colorFromTags: containerBox tag);
		border: (RSBorder new color: Color black; joinMiter);
		yourself.
]

{ #category : #hooks }
MiCoUsageMapBuilder >> containerBoxShapeFor: containerBox [
	| label body |
	label := self labelShapeFor: containerBox.
	body := self containerBoxBodyShapeFor: containerBox.
	RSVerticalLineLayout new
		alignCenter;
		gapSize: 0;
		on: { label. body }.
	^ MiCoContainerShape new
		model: containerBox;
		addAll: { label. body };
		adjustToChildren;
		announcer: containerBoxInteraction announcer;
		yourself
]

{ #category : #'popup - hooks' }
MiCoUsageMapBuilder >> createContainerBoxTextMorphFor: containerBox [
	^ containerBox asString asTextMorph
		backgroundColor: (Smalltalk ui theme backgroundColor alpha: 0.9);
		borderColor: Color black;
		borderWidth: 1;
		margins: 15;
		yourself
]

{ #category : #'popup - hooks' }
MiCoUsageMapBuilder >> createInnerBoxTextMorphFor: innerBox containerBox: containerBox [
	^ (innerBox asStringForContainerBox: containerBox) asTextMorph
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
MiCoUsageMapBuilder >> defaultMaxLabelWidth [
	^ 200
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultMenuManager [
	^ MiCoMenuManager new
]

{ #category : #default }
MiCoUsageMapBuilder >> defaultTagLegendBuilder [
	^ MiCoTagLegendBuilder new
]

{ #category : #accessing }
MiCoUsageMapBuilder >> highlightManager [
	^ highlightManager
]

{ #category : #accessing }
MiCoUsageMapBuilder >> highlightManager: aMiCoHighlightManager [
	highlightManager := aMiCoHighlightManager.
	highlightManager mapBuilder: self.
]

{ #category : #accessing }
MiCoUsageMapBuilder >> iconForTag: aTag [
	self flag: 'move to model?'.
	^self application iconForTag: aTag
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initialize [
	super initialize.

	self
		legendTagBuilder: self defaultTagLegendBuilder;
		menuManager: self defaultMenuManager;
		highlightManager: self defaultHighlightManager;
		initializeShapes
]

{ #category : #initialization }
MiCoUsageMapBuilder >> initializeShapes [
	"all this interaction will produce an announcer that we can reuse for new shapes"
	innerBoxInteraction := RSBox new
		addInteraction: self menuManager;
		addInteraction: self highlightManager;
		addInteraction: (RSMorphicPopupInteraction new
			model: #yourself;
			morphBuilder: [:shape | 
				self 
					createInnerBoxTextMorphFor: shape model
					containerBox: (shape propertyAt: #container) ];
			yourself).
	
	containerBoxInteraction := RSComposite new
		addInteraction: self menuManager;
		addInteraction: self highlightManager;
		addInteraction: (RSMorphicPopupInteraction new
			morphBuilder: [:model | self createContainerBoxTextMorphFor: model ];
			yourself);
		yourself.
	
]

{ #category : #hooks }
MiCoUsageMapBuilder >> innerBoxShapeFor: innerBox containerBox: containerBox [
	| height |
	height := self specModel innerBoxHeight.
	widthScale := self specModel widthScale.
	^ RSBox new
		model: innerBox;
		width: (widthScale scale: (innerBox numberOfUses));
		height: height;
		color: (self colorFromTags: innerBox tag);
		border: (self highlightManager defaultBoxBorder);
		propertyAt: #container put: containerBox;
		announcer: innerBoxInteraction announcer;
		yourself.
]

{ #category : #hooks }
MiCoUsageMapBuilder >> labelShapeFor: containerBox [
	| label |
	label := RSLabel new
		text: containerBox name;
		color: Color black;
		yourself.
	self resizeLabelIfNecessary: label.
	^ label
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
MiCoUsageMapBuilder >> menuManager: aMiCoMenuManager [
	menuManager := aMiCoMenuManager.
	menuManager mapBuilder: self.
]

{ #category : #dependencies }
MiCoUsageMapBuilder >> release [
	super release.
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #hooks }
MiCoUsageMapBuilder >> render [
	self renderIn: self canvas
]

{ #category : #hooks }
MiCoUsageMapBuilder >> renderIn: aCanvas [
	shapes := self specModel containerBoxes  collect: [ :containerEntity | self containerBoxShapeFor: containerEntity ].
	aCanvas addAll: shapes.
	
	self updateShapeLayout.
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

{ #category : #accessing }
MiCoUsageMapBuilder >> selectedInnerEntity [

	^visualization selectedInnerEntity
]

{ #category : #accessing }
MiCoUsageMapBuilder >> selectedInnerShape [
	| selectedEntity |
	selectedEntity := visualization selectedInnerEntity.
	self canvas children do: [:containerShape |
		containerShape innerBoxShapes
			detect: [ :innerShape |
				innerShape model mooseEntity = selectedEntity ]
			ifOne: [ :innerShape | ^innerShape ]
			ifNone: [ nil ]
		].

	Error signal: 'Shape of selected entity not found'
]

{ #category : #accessing }
MiCoUsageMapBuilder >> selectedInnerShape: anInnerShape [

	^visualization selectedInnerEntity: (anInnerShape ifNil: [ nil ] ifNotNil: [anInnerShape model mooseEntity])
]

{ #category : #accessing }
MiCoUsageMapBuilder >> settings [
self shouldNotImplement .
	^visualization settings
]

{ #category : #testing }
MiCoUsageMapBuilder >> shouldUseProgressBar [
	^ true
]

{ #category : #public }
MiCoUsageMapBuilder >> sortShapes [
	| block children tBlock |
	block := self specModel outerBoxSortBlockCompiled.
	tBlock := [ :a :b | block value: a model value: b model ].
	children := self canvas children.
	[ children sort: tBlock ]
	onErrorDo: [ :ex | 
		block := self specModel defaultSortBlock.
		children sort: tBlock ].
	block := self specModel innerBoxSortBlockCompiled.
	children do: [ :node |
		tBlock := [ :a :b | 
			block value: a model value: b model value: node model ].
		[ node innerBoxShapes sort: tBlock  ]
		onErrorDo: [ :ex |
			block := self specModel defaultInnerSortBlock.
			node innerBoxShapes sort: tBlock ]
	]

]

{ #category : #accessing }
MiCoUsageMapBuilder >> specModel [
	^visualization specModel
]

{ #category : #accessing }
MiCoUsageMapBuilder >> tagNamed: aString [ 
	^ self legendTagBuilder tagNamed: aString
]

{ #category : #accessing }
MiCoUsageMapBuilder >> tags [
	^self specModel tagList
]

{ #category : #public }
MiCoUsageMapBuilder >> updateBoxColor: aMiCoBox fromTags: tags [
	| tagColor |
	tagColor := self colorFromTags: tags.
	(self canvas deepShapesFromModel: aMiCoBox) 
		do: [ :shape | shape color: tagColor ].
	self canvas signalUpdate.

]

{ #category : #update }
MiCoUsageMapBuilder >> updateChildren [
	| canvas |
	canvas := self canvas.
	canvas nodes copy do: #remove.
	self initializeValues.
	shapes := self containerBoxes collect: [ :met | self containerBoxShapeFor: met ].
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
		
		body := self containerBoxBodyShapeFor: met.
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

	legendTagBuilder removeOldLegend.
	legendTagBuilder build.
	self updateShapeColors.
]

{ #category : #update }
MiCoUsageMapBuilder >> updateShapeColors [
	self canvas allChildren
		select: [ :shape | shape model notNil ]
		thenDo: [ :shape | shape color: (self colorFromTags: shape model tag) ].
	self canvas signalUpdate.
]

{ #category : #update }
MiCoUsageMapBuilder >> updateShapeLayout [
	| children |
	self sortShapes.
	children := self canvas nodes.
	children do: [ :child | 
		RSFlowLayout on: child innerBoxShapes.
		child children second adjustToChildren; padding: 10.
		RSVerticalLineLayout new
			alignCenter;
			gapSize: 0;
			on: child children.
		child adjustToChildren ].
	self applyLayout.
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
