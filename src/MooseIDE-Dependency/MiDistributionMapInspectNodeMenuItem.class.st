"
This menu item inspects a node with a moose inspector.
"
Class {
	#name : 'MiDistributionMapInspectNodeMenuItem',
	#superclass : 'MiDistributionMapNodeMenuItem',
	#category : 'MooseIDE-Dependency-DistributionMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'DistributionMap'
}

{ #category : 'execution' }
MiDistributionMapInspectNodeMenuItem >> execute [

	MiInspectorBrowser inspect: shape model rawModel
]

{ #category : 'execution' }
MiDistributionMapInspectNodeMenuItem >> iconName [
	^ #smallInspectIt
]

{ #category : 'execution' }
MiDistributionMapInspectNodeMenuItem >> label [
	^ 'Inspect'
]

{ #category : 'execution' }
MiDistributionMapInspectNodeMenuItem >> order [
	^ 42
]
