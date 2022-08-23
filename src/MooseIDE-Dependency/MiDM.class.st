"
I am a visualization, using a builder to draw a distribution map [1] on my canvas.

[1] S. Ducasse, T. Girba and A. Kuhn, ""Distribution Map,"" 2006 22nd IEEE International Conference on Software Maintenance, 2006, pp. 203-212, doi: 10.1109/ICSM.2006.22.
"
Class {
	#name : #MiDM,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #highlighting }
MiDM >> highlightShapes [
	
]

{ #category : #running }
MiDM >> run [

	super run.
	builder := MiDistributionMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself.
	builder build.
	builder rootNode expandChildren.
	self canvas
		zoomToFit;
		zoomToFit
]
