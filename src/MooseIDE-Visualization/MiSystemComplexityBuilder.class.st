Class {
	#name : 'MiSystemComplexityBuilder',
	#superclass : 'HSimpleVisualizationBuilder',
	#instVars : [
		'nodeMooseIDDict'
	],
	#category : 'MooseIDE-Visualization-System Complexity',
	#package : 'MooseIDE-Visualization',
	#tag : 'System Complexity'
}

{ #category : 'hooks' }
MiSystemComplexityBuilder >> addInteractionsToShape: aShape [

	| node |
	aShape announcer: self nodeAnnouncer.
	node := aShape model.
	node
		removeInteractionIfPresent: self class;
		when: HCollapseEvent do: [ :evt |
			self rebuildShape: aShape.
			self normalizeShapes.
			self relayout: self container nodes parent: rootNode ]
		for: self;
		when: HExpandEvent
		do: [ :evt | self rebuildRootShape: aShape ]
		for: self
]

{ #category : 'building' }
MiSystemComplexityBuilder >> build [

	self initializeRootNode.
	self setDependencies.
	self renderIn: self container.
	self buildLegend.
	^ self container
]

{ #category : 'building' }
MiSystemComplexityBuilder >> buildLegend [

	| legend box |
	legend := RSLegend new.
	legend withFrame.
	legend container: self container.
	legend onDemand.
	legend title: 'System complexity'.
	legend text: ' '.
	box := legend
		       polymetricWidth: mapModel widthMetric asWords
		       height: mapModel heightMetric asWords
		       box: 'Class'.
	self paintLegendBox: box.
	legend text: ' '.
	legend text: mapModel colorMetric asWords withFadingRamp: {
			(0 -> mapModel startColor).
			(1 -> mapModel endColor) }.
	legend text: ' '.
	legend text: 'Line = Inheritance'.
	legend build
]

{ #category : 'building' }
MiSystemComplexityBuilder >> buildNodeFromEntity: anEntity [

	| node |
	node := HNode new
		        rawModel: anEntity;
		        name: (self mapModel displayedName value: anEntity);
		        style: MiHSystemComplexityStyle new;
		        addAll:
			        ((anEntity children asOrderedCollection sort: [ :c1 :c2 |
					          c1 name < c2 name ]) collect: [ :e |
					         self buildNodeFromEntity: e ]);
		        collapse;
		        yourself.
	nodeMooseIDDict at: anEntity mooseID put: node.
	^ node
]

{ #category : 'building' }
MiSystemComplexityBuilder >> colorBlock [

	^ [ :e | mapModel colorMetric value: e rawModel ]
]

{ #category : 'public - hooks' }
MiSystemComplexityBuilder >> colorFor: node [
	^ Color fromHexString: '2980B9'
]

{ #category : 'building' }
MiSystemComplexityBuilder >> elements [

	^ self types entityStorage
]

{ #category : 'initialization' }
MiSystemComplexityBuilder >> initialize [

	super initialize.
	nodeMooseIDDict := Dictionary new
]

{ #category : 'building' }
MiSystemComplexityBuilder >> initializeRootNode [

	(rootNode := HNode new) addAll:
		(self elements collect: [ :e | self buildNodeFromEntity: e ])
]

{ #category : 'layout' }
MiSystemComplexityBuilder >> layoutOn: aGroupOfShapes parent: shape [

	aGroupOfShapes ifEmpty: [ ^ self ].

	self relayout: aGroupOfShapes parent: shape
]

{ #category : 'accessing - attributes' }
MiSystemComplexityBuilder >> menuItemStrategy [

	^ MiSystemComplexityMenuItemStrategy new
]

{ #category : 'hooks' }
MiSystemComplexityBuilder >> nodeAnnouncer [
	"plug new events here"

	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		            @ self popup;
		            @ self menuInteraction;
		            @
			            (HGhostDraggable new color:
					             Smalltalk ui theme caretColor);
		            @ RSNodeOnTopWhenPositionChanged new;
		            yourself.
	^ baseNode announcer
]

{ #category : 'building' }
MiSystemComplexityBuilder >> normalizeColor [

	| colorMetric scale |
	colorMetric := mapModel colorMetric.
	scale := self
		         normalizeMetric: colorMetric
		         threshold: mapModel colorMetricThreshold.
	scale range: {
			mapModel startColor.
			mapModel endColor }.
	self container nodes do: [ :each |
			(each propertyAt: #background) color:
				(scale scale: (colorMetric value: each model rawModel)) ]
]

{ #category : 'building' }
MiSystemComplexityBuilder >> normalizeHeight [

	| heightMetric scale |
	heightMetric := mapModel heightMetric.
	scale := self
		         normalizeMetric: heightMetric
		         threshold: mapModel heightMetricThreshold.
	scale range: { 20. 400 }.
	self container nodes do: [ :each |
			(each propertyAt: #background) height:
				(scale scale: (heightMetric value: each model rawModel)) ]
]

{ #category : 'building' }
MiSystemComplexityBuilder >> normalizeMetric: metric threshold: threshold [
	"When all elements are homogeneous, we want to show that the difference is small by making them look similar. They are considered homogeneous when the difference between the min and max values of the metric is below the threshold."

	| min max |
	"start by finding min and max"
	min := SmallInteger maxVal.
	max := 0.
	self container nodes do: [ :shape |
			| value |
			value := metric value: shape model rawModel.
			min := min min: value.
			max := max max: value ].

	"widen the domain by the difference if it is below the threshold, which reduces the effective range and thus makes the elements more similar"
	^ NSScale linear domain: (max - min > threshold
			   ifTrue: [
					   {
						   min.
						   max } ]
			   ifFalse: [
					   {
						   (min - max / 2 + min).
						   (max - min / 2 + max) } ])
]

{ #category : 'building' }
MiSystemComplexityBuilder >> normalizeShapes [

	self normalizeWidth.
	self normalizeHeight.
	self normalizeColor.
	self container nodes do: [ :canvasShape |
			canvasShape model isExpanded ifFalse: [
					RSVerticalLineLayout new alignCenter on: canvasShape children.
					canvasShape adjustToChildren ] ]
]

{ #category : 'building' }
MiSystemComplexityBuilder >> normalizeWidth [

	| widthMetric scale |
	widthMetric := mapModel widthMetric.
	scale := self
		         normalizeMetric: widthMetric
		         threshold: mapModel widthMetricThreshold.
	scale range: { 20. 400 }.
	self container nodes do: [ :each |
			(each propertyAt: #background) width:
				(scale scale: (widthMetric value: each model rawModel)) ]
]

{ #category : 'building' }
MiSystemComplexityBuilder >> paintLegendBox: aComposite [

	| actualBox |
	actualBox := (aComposite nodes reject: #isLabel) anyOne.
	actualBox
		color: (mapModel startColor alphaMixed: 0.5 with: mapModel endColor);
		borderWidth: 2
]

{ #category : 'hooks' }
MiSystemComplexityBuilder >> rebuildRootShape: shape [

	super rebuildRootShape: shape.
	self relayout: self container nodes parent: self rootNode
]

{ #category : 'layout' }
MiSystemComplexityBuilder >> relayout: aGroupOfShapes parent: shape [

	RSDominanceTreeLayout new
		childrenSortBlock: [ :shapeA :shapeB | shapeA model name < shapeB model name ];
		horizontalGap: 20;
		on: aGroupOfShapes
]

{ #category : 'building' }
MiSystemComplexityBuilder >> relayoutChildren: aGroupOfShapes parent: shape [

	shape layout ifNil: [
			RSFlowLayout new
				gapSize: 10;
				on: aGroupOfShapes.
			^ self ].
	shape layout on: aGroupOfShapes
]

{ #category : 'rendering' }
MiSystemComplexityBuilder >> renderIn: aCanvas [

	| rootShapes |
	aCanvas color: Smalltalk ui theme backgroundColor.

	rootShapes := self childrenShapes: aCanvas.
	shapes := rootShapes flatCollect: [ :s | s withAllSChildren ].
	self addInteractions: shapes.
	aCanvas schildren: rootShapes.
	aCanvas addAll: rootShapes.
	aCanvas @ self menuInteraction.
	rootNode
		when: HNodeAddedEvent
		do: [ :evt |
			| newShape |
			newShape := (self shapeFor: evt newChild) sparent: aCanvas.
			newShape position: aCanvas camera position.
			rootShapes add: newShape.
			aCanvas add: newShape.
			aCanvas signalUpdate ]
		for: self.

	self normalizeShapes.
	self renderLinesIn: aCanvas.
	self layoutOn: rootShapes parent: rootNode
]

{ #category : 'hooks' }
MiSystemComplexityBuilder >> renderLinesIn: aCanvas [

	| arrow |
	arrow := RSShapeFactory triangle.
	arrow extent: 10 @ 5.
	arrow := arrow asMarker.
	arrow offset: -2.5.
	RSLineBuilder orthoVertical
		shapes: aCanvas nodes;
		attachPoint: (RSVerticalAttachPoint new startOffset: 5);
		markerStart: arrow;
		connectFromAll: #dependentsFromLinks.
	aCanvas pushBackEdges
]

{ #category : 'building' }
MiSystemComplexityBuilder >> setDependencies [

	rootNode children do: [ :each | self setDependenciesFor: each ]
]

{ #category : 'building' }
MiSystemComplexityBuilder >> setDependenciesFor: aNode [

	aNode rawModel directSubclasses do: [ :e |
			nodeMooseIDDict
				at: e mooseID
				ifPresent: [ :hNode | aNode dependencyTo: hNode ] ]
]

{ #category : 'accessing' }
MiSystemComplexityBuilder >> types [

	^ self mapModel entities
]
