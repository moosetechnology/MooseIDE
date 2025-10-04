"
Roassal visaulization for `MiAPIBrowser`
"
Class {
	#name : 'MiAPIVisualization',
	#superclass : 'MiAbstractVisualization',
	#instVars : [
		'builder'
	],
	#category : 'MooseIDE-API-Browser-browser',
	#package : 'MooseIDE-API-Browser',
	#tag : 'browser'
}

{ #category : 'running' }
MiAPIVisualization >> buildInCanvas: aCanvas [

	aCanvas @ RSCanvasController new noLegend.

	builder := MiAPIMapBuilder new
		mapModel: owner specModel;
		container: aCanvas;
		yourself.
	builder build
]

{ #category : 'accessing' }
MiAPIVisualization >> miSelectedItem [

	^ self canvas selectedShapes
		reject: #isLine
		thenCollect: [ :shape | shape model rawModel ]
]
