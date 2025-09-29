Class {
	#name : #MiDSMDependencyGraph,
	#superclass : #Object,
	#instVars : [
		'graph',
		'dependencies'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #buildGraph }
MiDSMDependencyGraph >> buildGraph [

	graph nodes: dependencies entities.

	self buildGraphEdges.

	"run tarjan to compute Strongly Connected Components"
	graph run
]

{ #category : #buildGraph }
MiDSMDependencyGraph >> buildGraphEdges [
	"We choose to say that there is a relation from column to line if column depends on line"

	graph
			edges: dependencies entities
			from: #yourself
			toAll: [ :sourceEntity | 
				dependencies entities select: [ :targetEntity | 
					(dependencies from: sourceEntity to: targetEntity) isNotEmpty 
				]
			]
]

{ #category : #accessing }
MiDSMDependencyGraph >> dependencies: aMiDSMDependencyManager [

	dependencies := aMiDSMDependencyManager 
]

{ #category : #accessing }
MiDSMDependencyGraph >> findNode: anEntity [

	^graph findNode: anEntity
]

{ #category : #accessing }
MiDSMDependencyGraph >> graph [

	^ graph
]

{ #category : #accessing }
MiDSMDependencyGraph >> graph: anObject [

	graph := anObject
]

{ #category : #'as yet unclassified' }
MiDSMDependencyGraph >> inCycle: fromEntity with: toEntity [

	^fromEntity cycleNodes
		includes: toEntity 
]

{ #category : #buildGraph }
MiDSMDependencyGraph >> initialize [

	super initialize.

	graph := AITarjan new.

]
