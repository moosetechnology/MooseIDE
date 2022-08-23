"
A visualization of a RSDSM inside a MooseIDE browser
"
Class {
	#name : #MiDSMVisualization,
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
MiDSMVisualization >> cellColor: tuple [
	^viewModel colorForTuple: tuple
]

{ #category : #coloring }
MiDSMVisualization >> cellShowSCCColor: tuple [
	^viewModel showSCCColorForTuple: tuple
]

{ #category : #initialization }
MiDSMVisualization >> createDSM: aRSCanvas [
	| dsm entities |
	"change legend by adding #noLegend to RSCanvasController new
	and add RSLegend new ..."
	
	entities := viewModel nodesOrdered.
	entities ifEmpty: [ ^self ].
	
	aRSCanvas addInteraction: RSCanvasController new.
	dsm := MiRSDSM new.
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
MiDSMVisualization >> initialize [

	super initialize.
	self script: [ :canvas | self createDSM: canvas ].
	
	"optimization cache"
	lastSCCShapes := nil -> #()
]

{ #category : #private }
MiDSMVisualization >> sccShapesIncluding: aRSShape [
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
MiDSMVisualization >> setInteractions: dsm [
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
MiDSMVisualization >> shapeFor: tuple [
	currentCanvas deepShapeFromModel: tuple
]

{ #category : #coloring }
MiDSMVisualization >> showSCC: aCollection [
	aCollection do: [ :tuple |
		(self shapeFor: tuple) color: (viewModel showSCCColorForTuple: tuple)
	]
]

{ #category : #accessing }
MiDSMVisualization >> viewModel: aDSMModel [
	viewModel := aDSMModel
]
