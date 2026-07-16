Class {
	#name : 'MiArchitecturalMenuItemStrategy',
	#superclass : 'HDefaultMenuItemStrategy',
	#category : 'MooseIDE-ArchitecturalMap-menu',
	#package : 'MooseIDE-ArchitecturalMap',
	#tag : 'menu'
}

{ #category : 'public' }
MiArchitecturalMenuItemStrategy >> menuItemClassesFor: aShape [

	| clazz |
	clazz := self classFor: aShape.
	^ MiArchitecturalNodeMenuItem subclasses , clazz subclasses
	  , { HMiInspectMenuItem }
]
