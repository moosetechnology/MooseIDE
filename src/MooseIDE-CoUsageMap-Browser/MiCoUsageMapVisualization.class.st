"
TODO
"
Class {
	#name : #MiCoUsageMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'coUsageMap'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #brokerage }
MiCoUsageMapVisualization >> consume: aTag [
	| legendTag |
	legendTag := coUsageMap legendTag.
	legendTag tagsFromMooseModel: self owner classModel mooseModel.
	legendTag build.
	coUsageMap updateShapeColors.
]

{ #category : #highlighting }
MiCoUsageMapVisualization >> highlightShapes [
	^ #()
]

{ #category : #initialization }
MiCoUsageMapVisualization >> initialize [

	super initialize.
	self script: [ :canvas | canvas ]
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> remove: aTag [
	| canvas legendTag |
	canvas := coUsageMap canvas.
	legendTag := coUsageMap legendTag.
	
	"updating legend"
	legendTag tagsFromMooseModel: self owner classModel mooseModel.
	legendTag build.
	
	coUsageMap markManager removeTag: aTag.
	canvas signalUpdate.
]

{ #category : #running }
MiCoUsageMapVisualization >> run [
	| model |
	super run.
	model := self owner classModel.
	coUsageMap := MiCoUsageMapMooseBuilder new.
	coUsageMap container: self canvas.
	coUsageMap attributes: model attributes.
	coUsageMap methods: model methods.
	coUsageMap application: self owner application.
	self consume: nil.
	coUsageMap build.
]
