Class {
	#name : 'MiSystemComplexityMenuItemStrategy',
	#superclass : 'HDefaultMenuItemStrategy',
	#category : 'MooseIDE-Visualization-System Complexity',
	#package : 'MooseIDE-Visualization',
	#tag : 'System Complexity'
}

{ #category : 'public' }
MiSystemComplexityMenuItemStrategy >> menuItemClassesFor: aShape [

	| clazz |
	clazz := self classFor: aShape.
	^ clazz subclasses , { HMiInspectMenuItem }
]
