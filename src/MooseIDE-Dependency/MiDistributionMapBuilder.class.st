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
		'mapModel',
		'nodeStyle'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #building }
MiDistributionMapBuilder >> build [
	rootNode := HNode new
		            addAll:
			            ((mapModel orderOuterNodes: self elements) collect: [ 
					             :e | self buildNodeFromEntity: e ]);
		            yourself.
	self setColors.
	self buildLegend.
	self renderIn: self container.
	^ self container
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
	mapModel tagsSetting do: [ :dt | 
		legend
			text: dt name
			withBoxColor: (self mapModel colorForTag: dt) ].
	legend build
]

{ #category : #building }
MiDistributionMapBuilder >> buildNodeFromEntity: anEntity [

	^ HNode new
		  name:
			  (String streamContents: [ :s | anEntity displayStringOn: s ]);
		  rawModel: anEntity;
		  style: MiHDMStyle new;
		  layout: self nodeLayout;
		  addAll: ((self mapModel childrenFor: anEntity) collect: [ :n | 
					   HNode new
						   name: (String streamContents: [ :s | n displayStringOn: s ]);
						   style: MiHDMStyle new;
						   rawModel: n;
						   yourself ]);
		  expand;
		  yourself
]

{ #category : #building }
MiDistributionMapBuilder >> colorFor: node [
	
	node level > 1 ifTrue: [ ^ mapModel colorFor: node rawModel ].
	^ Color gray
]

{ #category : #accessing }
MiDistributionMapBuilder >> elements [

	^ mapModel entities
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
		@ self popup;
		@ self menuInteraction;
		@ self highlightable;
		@ (HUpdateSelectionBox new);
		yourself.
	^ baseNode announcer
]

{ #category : #hooks }
MiDistributionMapBuilder >> nodeLayout [

	^ RSFlowLayout new
		  gapSize: 3;
		  yourself
]

{ #category : #building }
MiDistributionMapBuilder >> setColors [

	rootNode children do: [ :c | 
		c children do: [ :cc | cc color: (self colorFor: cc) ] ]
]

{ #category : #accessing }
MiDistributionMapBuilder >> shapeFor: node [

	^ node asShape
]
