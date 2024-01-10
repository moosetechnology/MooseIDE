"
A visualization of a RSDSM inside a MooseIDE browser
"
Class {
	#name : #MiDependencyStructuralMatrixVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'viewModel',
		'lastSCCShapes',
		'lastHighlighted',
		'lastUnhighlighted'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #coloring }
MiDependencyStructuralMatrixVisualization >> cellColor: tuple [
	^viewModel colorForTuple: tuple
]

{ #category : #coloring }
MiDependencyStructuralMatrixVisualization >> cellShowSCCColor: tuple [
	^viewModel showSCCColorForTuple: tuple
]

{ #category : #initialization }
MiDependencyStructuralMatrixVisualization >> createDSM: aRSCanvas [
	| dsm entities |
	"change legend by adding #noLegend to RSCanvasController new
	and add RSLegend new ..."
	
	entities := viewModel nodesOrdered.
	entities ifEmpty: [ ^self ].
	
	aRSCanvas addInteraction: RSCanvasController new.
	dsm := MiRSDependencyStructuralMatrix new.
	dsm owner: self.
	dsm setShouldFeedY.
	dsm labelShapeX textBlock: [ :columnNode | viewModel displayValueForNode: columnNode].
	dsm labelShapeY textBlock: [ :rowNode | viewModel displayValueForNode: rowNode ].
	dsm container: aRSCanvas.
	dsm objects: entities.
	dsm color: [ :tuple | self cellColor: tuple ].

	dsm build.

	self setInteractions: dsm.

]

{ #category : #initialization }
MiDependencyStructuralMatrixVisualization >> initialize [

	super initialize.
	self script: [ :canvas | self createDSM: canvas ].
	
	"optimization cache"
	lastSCCShapes := nil -> #()
]

{ #category : #private }
MiDependencyStructuralMatrixVisualization >> sccShapesIncluding: aRSShape [
"Transcript
	show: '    ';
	show: (aRSShape model key model name) ;
	show: ' -> ';
	show: (aRSShape model value model name)."

	(lastSCCShapes key = aRSShape model key) ifFalse: [ 
		"Transcript show: ' - NOT found' ; cr."
		lastSCCShapes := aRSShape model key -> (aRSShape canvas deepShapesFromModels:
			(viewModel sccTuplesForTuple: aRSShape model)) ]
		"ifTrue: [ Transcript show: ' - found' ; cr ]".
	^ lastSCCShapes value
]

{ #category : #initialization }
MiDependencyStructuralMatrixVisualization >> setInteractions: dsm [
	|   |
	dsm shapes @ (RSPopup text: [:tuple | viewModel displayValueForTuple: tuple ]).

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
		(self shapeFor: tuple) color: (viewModel showSCCColorForTuple: tuple)
	]
]

{ #category : #accessing }
MiDependencyStructuralMatrixVisualization >> viewModel: aDSMModel [
	viewModel := aDSMModel
]
