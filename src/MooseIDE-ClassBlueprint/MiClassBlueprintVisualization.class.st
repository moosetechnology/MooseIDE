Class {
	#name : 'MiClassBlueprintVisualization',
	#superclass : 'MiAbstractVisualization',
	#category : 'MooseIDE-ClassBlueprint',
	#package : 'MooseIDE-ClassBlueprint'
}

{ #category : 'running' }
MiClassBlueprintVisualization >> buildInCanvas: aCanvas [

	| currentType |
	currentType := owner specModel currentType ifNil: [ ^ self ].

	currentType blueprint
		canvas: aCanvas;
		build.

	^ aCanvas @ RSCanvasController new noLegend
]
