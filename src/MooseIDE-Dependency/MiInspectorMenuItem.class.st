Class {
	#name : #MiInspectorMenuItem,
	#superclass : #HAbstractMenuItem,
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #accessing }
MiInspectorMenuItem >> canBeExecuted [

	^ shape isShape
]

{ #category : #accessing }
MiInspectorMenuItem >> execute [

	MiInspectorBrowser inspect: shape model rawModel
]

{ #category : #accessing }
MiInspectorMenuItem >> group [

	^ 100
]

{ #category : #accessing }
MiInspectorMenuItem >> iconName [
	^ #smallInspectIt
]

{ #category : #accessing }
MiInspectorMenuItem >> label [
	^ 'Inspect'
]

{ #category : #accessing }
MiInspectorMenuItem >> order [
	^ 100
]
