"
A visualization of a RSDSM inside a MooseIDE browser
"
Class {
	#name : #MiDSMVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #accessing }
MiDSMVisualization >> createDSM: aRSCanvas [
	| dsm entities |
	"change legend by adding #noLegend to RSCanvasController new
	and add RSLegend new ..."
	
	entities := model entitiesOrdered.
	entities ifEmpty: [ ^self ].
	
	aRSCanvas addInteraction: RSCanvasController new.
	dsm := RSDSM new.
	dsm labelShapeX textBlock: #name.
	dsm labelShapeY textBlock: #name.
	dsm container: aRSCanvas.
	dsm objects: entities.
	dsm dependency: [ :entity | model relationsForX: entity ].
	dsm color: [ :tuple | model colorForX: tuple key y: tuple value ].
	dsm build
]

{ #category : #initialization }
MiDSMVisualization >> initialize [

	super initialize.
	self script: [ :canvas | self createDSM: canvas ]
]

{ #category : #accessing }
MiDSMVisualization >> model: aModel [
	model := aModel
]
