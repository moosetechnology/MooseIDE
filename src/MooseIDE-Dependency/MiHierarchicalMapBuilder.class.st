"
I am a builder of a hierarchical map using HierarchicalMap.

Nodes are colored according to properties.

I am responsible for :
	- creating the nodes for each entity
	- display the nodes on a canvas
	- color the nodes according to their property
"
Class {
	#name : #MiHierarchicalMapBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'mapModel'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #building }
MiHierarchicalMapBuilder >> build [

	rootNode := HNode new
		            addAll:
			            (self elements collect: [ :e | 
					             self buildNodeFromEntity: e ]);
		            yourself.
	self buildLegend.
	super build
]

{ #category : #building }
MiHierarchicalMapBuilder >> buildLegend [
	| legend |
	legend := RSLegend new
		container: self canvas ;
		title: 'Dynamic tags' ;
		onDemand: 'Legend' ;
		yourself.
	mapModel dynamicTags do: [ :dt |
		legend text: dt name withBoxColor: (dt color)
	].
	legend build.

]

{ #category : #building }
MiHierarchicalMapBuilder >> buildNodeFromEntity: anEntity [

	^ HNode new
		  name:
			  (String streamContents: [ :s | anEntity displayStringOn: s ]);
		  rawModel: anEntity;
		  addAll:
			  ((self childrenBlock value: anEntity) collect: [ :e | self buildNodeFromEntity: e ]);
		  collapse;
		  yourself
]

{ #category : #accessing }
MiHierarchicalMapBuilder >> childrenBlock [

	^ mapModel childrenBlock
]

{ #category : #accessing }
MiHierarchicalMapBuilder >> colorFor: node [

	^ mapModel colorFor: node rawModel
]

{ #category : #accessing }
MiHierarchicalMapBuilder >> elements [

	^ mapModel entities
]

{ #category : #accessing }
MiHierarchicalMapBuilder >> mapModel [

	^ mapModel
]

{ #category : #accessing }
MiHierarchicalMapBuilder >> mapModel: anObject [

	mapModel := anObject
]
