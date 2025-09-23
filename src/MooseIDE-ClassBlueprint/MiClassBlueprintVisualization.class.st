Class {
	#name : #MiClassBlueprintVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'blueprint',
		'type'
	],
	#category : #'MooseIDE-ClassBlueprint'
}

{ #category : #initialization }
MiClassBlueprintVisualization >> buildInCanvas: aCanvas [

	type ifNil: [ ^ self ].

	blueprint := type blueprint.
	blueprint canvas: aCanvas.
	blueprint build.

	^ aCanvas @ RSCanvasController new noLegend
]

{ #category : #running }
MiClassBlueprintVisualization >> type [

	^ type
]

{ #category : #running }
MiClassBlueprintVisualization >> type: anObject [

	type := anObject
]
