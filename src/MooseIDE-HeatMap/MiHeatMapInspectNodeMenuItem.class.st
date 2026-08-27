Class {
	#name : 'MiHeatMapInspectNodeMenuItem',
	#superclass : 'MiHeatMapNodeMenuItem',
	#category : 'MooseIDE-HeatMap',
	#package : 'MooseIDE-HeatMap'
}

{ #category : 'execution' }
MiHeatMapInspectNodeMenuItem >> execute [

	MiInspectorBrowser inspect: shape model rawModel
]

{ #category : 'execution' }
MiHeatMapInspectNodeMenuItem >> iconName [

	^ #smallInspectIt
]

{ #category : 'execution' }
MiHeatMapInspectNodeMenuItem >> label [

	^ 'Inspect'
]

{ #category : 'execution' }
MiHeatMapInspectNodeMenuItem >> order [

	^ 42
]
