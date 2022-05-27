"
A visualization of a RSDSM inside a MooseIDE browser
"
Class {
	#name : #MiDSMVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'viewModel',
		'lastHighlighted',
		'lastUnhighlighted',
		'lastSCCShapes'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #coloring }
MiDSMVisualization >> cellColor: tuple [
	lastUnhighlighted key = tuple
	ifFalse: [ lastUnhighlighted := tuple -> (viewModel colorForX: tuple key y: tuple value) ].
	^lastUnhighlighted value
]

{ #category : #coloring }
MiDSMVisualization >> cellHighlightColor: tuple [
	lastHighlighted key = tuple
	ifFalse: [ lastHighlighted := tuple -> (viewModel highlightColorForX: tuple key y: tuple value) ].
	^lastHighlighted value
]

{ #category : #initialization }
MiDSMVisualization >> createDSM: aRSCanvas [
	| dsm entities sccHighlight |
	"change legend by adding #noLegend to RSCanvasController new
	and add RSLegend new ..."
	
	entities := viewModel entitiesOrdered.
	entities ifEmpty: [ ^self ].
	
	aRSCanvas addInteraction: RSCanvasController new.
	dsm := RSDSM new.
	dsm labelShapeX textBlock: #name.
	dsm labelShapeY textBlock: #name.
	dsm container: aRSCanvas.
	dsm objects: entities.
	dsm dependency: [ :entity | viewModel relationsForX: entity ].
	dsm color: [ :tuple | self cellColor: tuple ].

	dsm build.

	"dsm shapes @ (RSPopup text: [:tuple | tuple value name , ' -> ' , tuple key name ])."

	sccHighlight := RSHighlightable new.
	sccHighlight
		when: RSHighlightEvent do: [ :evt | evt shape color: (self cellHighlightColor: evt shape model) ].
	sccHighlight
		when: RSUnHighlightEvent do: [ :evt | evt shape color: (self cellColor: evt shape model) ].
	sccHighlight highlightShapes: [ :shape | self dependenciesShapesFor: shape ].
	dsm shapes @ sccHighlight
	
]

{ #category : #private }
MiDSMVisualization >> dependenciesShapesFor: aRSShape [
	(lastSCCShapes includes: aRSShape)
	ifFalse: [
		lastSCCShapes := aRSShape canvas
			deepShapesFromModels: (viewModel associationsSCCFor: (aRSShape model value))
	].
	^lastSCCShapes 
]

{ #category : #initialization }
MiDSMVisualization >> initialize [

	super initialize.
	self script: [ :canvas | self createDSM: canvas ].
	
	"optimization caches"
	lastHighlighted := nil -> nil.
	lastUnhighlighted := nil -> nil.
	lastSCCShapes := #()
]

{ #category : #accessing }
MiDSMVisualization >> viewModel: aDSMModel [
	viewModel := aDSMModel
]
