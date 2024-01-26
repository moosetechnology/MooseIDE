Class {
	#name : #MiClassBlueprintVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'blueprint',
		'type'
	],
	#category : #'MooseIDE-ClassBlueprint'
}

{ #category : #running }
MiClassBlueprintVisualization >> run [ 
	super run.
	self script: [ :canvas | 
			blueprint := type blueprint.
			blueprint canvas: canvas.
			blueprint build.
			canvas @ RSCanvasController new noLegend ]
]

{ #category : #running }
MiClassBlueprintVisualization >> type [
	^ type
]

{ #category : #running }
MiClassBlueprintVisualization >> type: anObject [

	type := anObject
]
