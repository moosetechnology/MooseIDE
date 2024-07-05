Class {
	#name : #MiSystemComplexityMenuItemStrategy,
	#superclass : #HDefaultMenuItemStrategy,
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #public }
MiSystemComplexityMenuItemStrategy >> menuItemClassesFor: aShape [

	| clazz |
	clazz := self classFor: aShape.
	^ clazz subclasses , { MiArchitecturalInspectorMenuItem }
]
