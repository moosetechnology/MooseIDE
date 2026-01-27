Class {
	#name : 'MiClassBlueprintVisualization',
	#superclass : 'MiAbstractVisualization',
	#category : 'MooseIDE-ClassBlueprint',
	#package : 'MooseIDE-ClassBlueprint'
}

{ #category : 'initialization' }
MiClassBlueprintVisualization >> buildInCanvas: aCanvas [

	type ifNil: [ ^ self ].

	blueprint := type blueprint.
	blueprint canvas: aCanvas.
	blueprint build.

	^ aCanvas @ RSCanvasController new noLegend
]
