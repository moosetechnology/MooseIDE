Class {
	#name : #MiHierarchicalVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'rootNode',
		'builder',
		'childrenBlock',
		'visualizationTheme'
	],
	#category : #'MooseIDE-Visualization-Hierarchical Visualization'
}

{ #category : #accessing }
MiHierarchicalVisualization >> childrenBlock: aBlock [

	"a block with one parameter: entity that return the list of children of this entity"

	childrenBlock := aBlock
]

{ #category : #running }
MiHierarchicalVisualization >> entities: aCollection [

	rootNode children:
		(aCollection collect: [ :entity | self nodeFor: entity ])
]

{ #category : #highlighting }
MiHierarchicalVisualization >> highlightShapes [

]

{ #category : #initialization }
MiHierarchicalVisualization >> initialize [

	super initialize.
	rootNode := HNode new name: 'Root'.
	visualizationTheme := MiVisualizationTheme new

]

{ #category : #running }
MiHierarchicalVisualization >> mooseIconNameFor: anEntity [
	^self visualizationTheme mooseIconNameFor: anEntity
]

{ #category : #running }
MiHierarchicalVisualization >> nodeColor [

	^ Color
		  r: 0.68
		  g: 0.83
		  b: 0.97
		  alpha: 0.4
]

{ #category : #running }
MiHierarchicalVisualization >> nodeFor: entity [

	| node |
	node := HNode new
		name: entity name ;
		color: self nodeColor ;
		iconName: (self mooseIconNameFor: entity) ;
		yourself.

	node addAll: ((childrenBlock value: entity) collect: [ :child | 
			 (self nodeFor: child) collapse ]).
	^ node
]

{ #category : #running }
MiHierarchicalVisualization >> run [

	super run.
	builder := HSimpleVisualizationBuilder new
		nodeStyler: MiNodeStyler new ;
		rootNode: rootNode ;
		container: self canvas ;
		yourself.
	builder build.
	self canvas zoomToFit
]

{ #category : #accessing }
MiHierarchicalVisualization >> visualizationTheme [
	^visualizationTheme
]

{ #category : #accessing }
MiHierarchicalVisualization >> visualizationTheme: anObject [
	visualizationTheme := anObject
]
