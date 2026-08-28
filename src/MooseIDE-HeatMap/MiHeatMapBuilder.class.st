Class {
	#name : 'MiHeatMapBuilder',
	#superclass : 'MiAbstractHierarchicalMapBuilder',
	#category : 'MooseIDE-HeatMap-Tests',
	#package : 'MooseIDE-HeatMap',
	#tag : 'Tests'
}

{ #category : 'building' }
MiHeatMapBuilder >> build [

	rootNode := HNode new
		            addAll:
			            ((self elements asSortedCollection: [ :a :b |
					              a name < b name ]) collect: [ :e |
					             self buildNodeFromEntity: e ]);
		            yourself.
	self setColors.
	self buildLegend.
	self renderIn: self container.
	^ self container
]

{ #category : 'building' }
MiHeatMapBuilder >> buildLegend [

	| legend |
	legend := RSLegend new
		          container: self canvas;
		          title: 'Heat map';
		          onDemand: 'Legend';
		          legendDo: [ :l |
				          l
					          border: RSBorder new;
					          color: Color white;
					          padding: 10 ];
		          yourself.

	legend text: 'Value' withFadingRamp: {
			(0 -> mapModel startColor).
			(1 -> mapModel endColor) }.

	legend build
]

{ #category : 'building' }
MiHeatMapBuilder >> buildNodeFromEntity: anEntity [

	^ HNode new
		  name:
			  (String streamContents: [ :s | anEntity displayStringOn: s ]);
		  rawModel: anEntity;
		  style: MiHHeatMapStyle new;
		  layout: self nodeLayout;
		  addAll: ((self mapModel childrenFor: anEntity) collect: [ :n |
						   HNode new
							   name: (String streamContents: [ :s | n displayStringOn: s ]);
							   style: MiHHeatMapStyle new;
							   rawModel: n;
							   yourself ]);
		  expand;
		  yourself
]

{ #category : 'building' }
MiHeatMapBuilder >> colorValueFor: rawModel [
	"Defensive: a user-typed block may raise on some entities (missing method,
	 division by zero, etc). Never let that crash the whole visualization build;
	 fall back to a neutral value for that one entity."

	^ [ mapModel colorBlock value: rawModel ]
		  on: Error
		  do: [ :err | 0 ]
]

{ #category : 'building' }
MiHeatMapBuilder >> domainFor: values [
	"Widen a degenerate (all-equal) domain by +-0.5 so NSScale doesn't divide by zero;
	 no user-facing threshold setting, unlike MiSystemComplexityBuilder -- not requested."

	| min max |
	min := values inject: values first into: [ :a :b | a min: b ].
	max := values inject: values first into: [ :a :b | a max: b ].
	^ min = max
		  ifTrue: [
				  {
					  (min - 0.5).
					  (max + 0.5) } ]
		  ifFalse: [
				  {
					  min.
					  max } ]
]

{ #category : 'accessing' }
MiHeatMapBuilder >> menuItemStrategy [

	^ MiHeatMapMenuItemStrategy new
]

{ #category : 'hooks' }
MiHeatMapBuilder >> nodeAnnouncer [
	"plug new events here"

	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		            @ self popup;
		            @ self menuInteraction;
		            @ self highlightable;
		            yourself.
	^ baseNode announcer
]

{ #category : 'hooks' }
MiHeatMapBuilder >> nodeLayout [

	^ RSFlowLayout new
		  gapSize: 3;
		  yourself
]

{ #category : 'building' }
MiHeatMapBuilder >> setColors [
	"Colors only the leaf ('children') level, exactly like MiDistributionMapBuilder>>setColors --
	 the level-1 parent boxes are pure containers, never colored."

	| leafNodes values scale |
	leafNodes := rootNode children flatCollect: [ :c | c children ].
	leafNodes ifEmpty: [ ^ self ].
	values := leafNodes collect: [ :n | self colorValueFor: n rawModel ].
	scale := NSScale linear
		         domain: (self domainFor: values);
		         range: {
				         mapModel startColor.
				         mapModel endColor };
		         yourself.
	leafNodes
		with: values
		do: [ :node :value | node color: (scale scale: value) ]
]
