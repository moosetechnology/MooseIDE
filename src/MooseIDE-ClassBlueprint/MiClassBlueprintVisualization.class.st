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

{ #category : #initialization }
MiClassBlueprintVisualization >> initialize [

	super initialize.

	self script: [ :canvas | self buildInCanvas: canvas ]
]

{ #category : #running }
MiClassBlueprintVisualization >> type [

	^ type
]

{ #category : #running }
MiClassBlueprintVisualization >> type: anObject [

	type := anObject
]
