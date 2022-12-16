Class {
	#name : #MiArchitecturalMenuItemStrategy,
	#superclass : #HDefaultMenuItemStrategy,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #public }
MiArchitecturalMenuItemStrategy >> menuItemClassesFor: aShape [

	| clazz |
	clazz := self classFor: aShape.
	^ MiArchitecturalNodeMenuItem subclasses , clazz subclasses
	  , { MiArchitecturalInspectorMenuItem }
]
