"
This menu item inspects a node with a moose inspector.
"
Class {
	#name : #MiDMInspectNodeMenuItem,
	#superclass : #MiDMNodeMenuItem,
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #execution }
MiDMInspectNodeMenuItem >> execute [

	MiInspectorBrowser inspect: shape model rawModel
]

{ #category : #execution }
MiDMInspectNodeMenuItem >> iconName [
	^ #smallInspectIt
]

{ #category : #execution }
MiDMInspectNodeMenuItem >> label [
	^ 'Inspect'
]

{ #category : #execution }
MiDMInspectNodeMenuItem >> order [
	^ 42
]
