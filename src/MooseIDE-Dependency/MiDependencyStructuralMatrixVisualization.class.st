"
A visualization of a RSDSM inside a MooseIDE browser
"
Class {
	#name : #MiDependencyStructuralMatrixVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'lastSCCShapes',
		'lastHighlighted',
		'lastUnhighlighted',
		'specModel'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #initialization }
MiDependencyStructuralMatrixVisualization >> buildInCanvas: aRSCanvas [
	| dsm |

	specModel orderedNodesX ifEmpty: [ ^self ].
	specModel orderedNodesY ifEmpty: [ ^self ].
	
	aRSCanvas addInteraction: RSCanvasController new.
	dsm := MiRSDependencyStructuralMatrix new.
	dsm owner: self.
	dsm setShouldFeedX.
	dsm labelShapeX textBlock: [ :dependingNode | specModel displayValueForNode: dependingNode].
	dsm labelShapeY textBlock: [ :dependedNode | specModel displayValueForNode: dependedNode ].
	dsm container: aRSCanvas.
	dsm objectsX: specModel orderedNodesX.
	dsm objectsY: specModel orderedNodesY.
	dsm color: [ :tuple | self cellColor: tuple ].

	dsm build.

	self setInteractions: dsm.

]

{ #category : #coloring }
MiDependencyStructuralMatrixVisualization >> cellColor: tuple [
	^specModel colorForTuple: tuple
]

{ #category : #coloring }
MiDependencyStructuralMatrixVisualization >> cellShowSCCColor: tuple [
	^specModel showSCCColorForTuple: tuple
]

{ #category : #accessing }
MiDependencyStructuralMatrixVisualization >> getTupleDependencyWeight: tuple [
	^ specModel getTupleDependencyWeight: tuple
]

{ #category : #initialization }
MiDependencyStructuralMatrixVisualization >> initialize [

	super initialize.

	"optimization cache"
	lastSCCShapes := nil -> #(  )
]

{ #category : #private }
MiDependencyStructuralMatrixVisualization >> sccShapesIncluding: aRSShape [

	"Returns all shapes involved in the same cycle as aRSShape.
	 lastSCCShapes is an optimization cache.
	 if aRSShape is part of the lastSSCShapes, do nothing. Otherwise, get all shapes of the tuples involved in a cycle with aRSShape model."
	
	(lastSCCShapes key = aRSShape model key) ifFalse: [ 
		"Transcript show: ' - NOT found' ; cr."
		lastSCCShapes := aRSShape model key -> (aRSShape canvas deepShapesFromModels:
			(specModel sccTuplesForTuple: aRSShape model)) ]
		"ifTrue: [ Transcript show: ' - found' ; cr ]".
	^ lastSCCShapes value
]

{ #category : #initialization }
MiDependencyStructuralMatrixVisualization >> setInteractions: dsm [
	|   |
	dsm shapes @ (RSPopup text: [:tuple | specModel displayValueForTuple: tuple ]).

	"sccHighlight := RSHighlightable new.
	sccHighlight
		when: RSHighlightEvent do: [ :evt | evt shape color: (self cellHighlightColor: evt shape model) ].
	sccHighlight
		when: RSUnHighlightEvent do: [ :evt | evt shape color: (self cellColor: evt shape model) ].
	sccHighlight highlightShapes: [ :shape | self sccShapesIncluding: shape ].
	currentCanvas @ sccHighlight"
	
	"RSInspectableInteraction reset.
	inspect := RSInspectableInteraction new.
	""highligtable := inspectable highlightable.
	highligtable highlightColor: Color green.""
	inspect inspectShapeBlock: [ :tuple | viewModel selected: tuple ].
	dsm shapes @ inspect"
]

{ #category : #utilities }
MiDependencyStructuralMatrixVisualization >> shapeFor: tuple [
	currentCanvas deepShapeFromModel: tuple
]

{ #category : #coloring }
MiDependencyStructuralMatrixVisualization >> showSCC: aCollection [
	aCollection do: [ :tuple |
		(self shapeFor: tuple) color: (specModel showSCCColorForTuple: tuple)
	]
]

{ #category : #accessing }
MiDependencyStructuralMatrixVisualization >> specModel [
	^ specModel
]

{ #category : #accessing }
MiDependencyStructuralMatrixVisualization >> specModel: aDSMModel [
	specModel := aDSMModel
]
