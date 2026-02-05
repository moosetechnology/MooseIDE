Class {
	#name : 'MiArchitecturalMenuItemStrategy',
	#superclass : 'HDefaultMenuItemStrategy',
	#category : 'MooseIDE-ArchitecturalMap-Menu',
	#package : 'MooseIDE-ArchitecturalMap',
	#tag : 'Menu'
}

{ #category : 'public' }
MiArchitecturalMenuItemStrategy >> menuItemClassesFor: aShape [

	| clazz |
	clazz := self classFor: aShape.
	^ MiArchitecturalNodeMenuItem subclasses , clazz subclasses
	  , { HMiInspectMenuItem }
]
