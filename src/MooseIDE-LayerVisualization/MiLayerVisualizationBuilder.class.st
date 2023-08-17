Class {
	#name : #MiLayerVisualizationBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'mapModel',
		'visitHNodeCache',
		'description',
		'highlightShapes',
		'colorScale'
	],
	#category : #'MooseIDE-LayerVisualization-Roassal-builder'
}

{ #category : #building }
MiLayerVisualizationBuilder >> addNextLevelButton [

	| next |
	next := RSComposite new.
	next
		add: (RSLabel new
				 fontSize: 13;
				 text: 'ADD LEVEL';
				 color: Color black;
				 yourself);
		border: (RSBorder new
				 color: (Color fromHexString: '88888899');
				 yourself);
		color: (Color fromHexString: 'AAAAAA33').
	next @ (RSHighlightable new
		 highlightColor: (Color fromHexString: 'AAAAAA99');
		 yourself).
	next
		adjustToChildren;
		padding: 5.
	next translateBy: next width / 2 + 10 @ (next height / 2 + 10).
	self container add: next.

	next setAsFixed.

	next
		when: RSMouseClick
		do: [ 
			mapModel addLayer.
			self updateBuild ]
		for: self
]

{ #category : #building }
MiLayerVisualizationBuilder >> build [

	mapModel initializePartitioning.

	self visit: mapModel buildDescription.

	mapModel createLinksIn: visitHNodeCache.

	self addNextLevelButton.

	self renderIn: self container.
	^ self container
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> changeColorFor: class [


	^ nil
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> createAndStoreHNodeFor: anLVElement [

	| hn |
	hn := self createHNodeFor: anLVElement.
	visitHNodeCache at: anLVElement model put: hn.
	^ hn
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> createHNodeFor: anLVElement [

	| color class |
	class := anLVElement model.
	color := self changeColorFor: class.

	^ HNode new
		  name: anLVElement name;
		  rawModel: class;
		  color: (Color fromHexString: '80B1D3');
		  collapse;
		  yourself
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> createHNodeForPackage: aPackageElement [

	^ (self createHNodeFor: aPackageElement)
		  addAll: (aPackageElement children collect: [ :c | 
					   self createAndStoreHNodeFor: c ]);
		  yourself
]

{ #category : #accessing }
MiLayerVisualizationBuilder >> highlightable [

	^ highlightable ifNil: [ 
		  highlightable := RSHighlightable new
			                   highlightShapes: [ :shape | 
				                   | list |
				                   list := shape connectedLines copy.
				                   list add: (shape propertyAt: #background).
				                   list ];
			                   when: RSHighlightEvent do: [ :evt | 
				                   evt shape isNode
					                   ifTrue: [ 
						                   highlightable
							                   record: evt shape
							                   selector: #border
							                   value: (RSBorder new
									                    color: (Color fromHexString: 'FF7F00');
									                    width: 3;
									                    yourself) ]
					                   ifFalse: [ 
					                   highlightable
						                   record: evt shape
						                   selector: #color
						                   value: Color red ] ]
			                   for: self;
			                   when: RSUnHighlightEvent do: [ :evt | 
				                   evt shape isNode
					                   ifTrue: [ 
					                   highlightable
						                   restore: evt shape
						                   selector: #border ]
					                   ifFalse: [ 
					                   highlightable
						                   restore: evt shape
						                   selector: #color ] ]
			                   for: self;
			                   yourself ]
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> highlightableLinkedShapes [

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

{ #category : #initialization }
MiLayerVisualizationBuilder >> initialize [

	super initialize.
	colorScale := NSScale linear
		              domain: #( 1 5 );
		              range: { 
				              (Color fromHexString: 'E8E8E8').
				              (Color fromHexString: '7C7C7C') };
		              yourself
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> layoutHStyle [

	^ HBoxNodeStyle new
		  borderDashArray: #( 4 6 );
		  yourself
]

{ #category : #building }
MiLayerVisualizationBuilder >> layoutOn: aGroupOfShapes parent: shape [

	aGroupOfShapes ifEmpty: [ ^ self ].

	self relayout: (aGroupOfShapes reject: #isFixed) parent: shape
]

{ #category : #accessing }
MiLayerVisualizationBuilder >> mapModel [

	^ mapModel
]

{ #category : #accessing }
MiLayerVisualizationBuilder >> mapModel: anObject [

	mapModel := anObject
]

{ #category : #building }
MiLayerVisualizationBuilder >> nodeAnnouncer [

	"plug new events here"

	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		            @ self popup;
		            @ self menuInteraction;
		            @ self highlightable;
		            @ RSNodeOnTopWhenPositionChanged new;
		            @ HUpdateSelectionBox new;
		            @ self highlightableLinkedShapes;
		            yourself.
	^ baseNode announcer
]

{ #category : #accessing }
MiLayerVisualizationBuilder >> rebuildShape: aShape [

	super rebuildShape: aShape.
	rootNode children do: [ :child | child position: nil ].
	self layoutOn: self container nodes parent: rootNode.
	self container zoomToFit.
	self container signalUpdate
]

{ #category : #rendering }
MiLayerVisualizationBuilder >> renderLinesIn: aCanvas [

	self lineBuilder
		canvas: aCanvas;
		color: (Color red alpha: 0.7);
		shapes: shapes;
		connectFromAll: #dependentsFromLinks
]

{ #category : #building }
MiLayerVisualizationBuilder >> updateBuild [

	self container shapes do: #remove.
	description := mapModel buildDescription.
	self visit: description.
	mapModel createLinksIn: visitHNodeCache.
	self renderIn: self container.
	self container signalUpdate.
	^ self container
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> visit: aVisualizationModel [

	visitHNodeCache := Dictionary new.
	rootNode := aVisualizationModel acceptVisitor: self
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> visitBox: aMiNVBoxNode withRSLayout: aRoassalLayout [

	| hNode |
	hNode := HNode new
		         name: aMiNVBoxNode name;
		         layout: aRoassalLayout;
		         style: self layoutHStyle;
		         color: ((colorScale scale: aMiNVBoxNode depth) alpha: 0.5);
		         addAll:
			         (aMiNVBoxNode children collect: [ :c | 
					          c acceptVisitor: self ]);
		         yourself.
	aMiNVBoxNode expanded
		ifTrue: [ hNode expand ]
		ifFalse: [ hNode collapse ].
	^ hNode
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> visitFlowBox: aMiNVBoxNode [

	^ self visitBox: aMiNVBoxNode withRSLayout: RSFlowLayout
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> visitHorizontalBox: aMiNVBoxNode [

	^ self
		  visitBox: aMiNVBoxNode
		  withRSLayout: (RSHorizontalLineLayout new
				   gapSize: aMiNVBoxNode gapSize;
				   alignMiddle;
				   yourself)
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> visitPackageElement: aPackageElement [

	^ self createHNodeForPackage: aPackageElement
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> visitTypeElement: aMiLVTypeElement [

	^ self createAndStoreHNodeFor: aMiLVTypeElement
]

{ #category : #visiting }
MiLayerVisualizationBuilder >> visitVerticalBox: aMiNVBoxNode [

	^ self
		  visitBox: aMiNVBoxNode
		  withRSLayout: (RSVerticalLineLayout new
				   gapSize: aMiNVBoxNode gapSize;
				   alignCenter;
				   yourself)
]
