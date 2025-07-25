Class {
	#name : 'MooseRegenerateAllConcreteMetamodelsMenuCommand',
	#superclass : 'MooseAbstractMetamodelMenuCommand',
	#category : 'MooseIDE-Core-MenuBar',
	#package : 'MooseIDE-Core',
	#tag : 'MenuBar'
}

{ #category : 'accessing' }
MooseRegenerateAllConcreteMetamodelsMenuCommand class >> help [

	^ 'Does the same as "regenerate all metamodels" but excluding generators that are in a package with "Test" in the name.'
]

{ #category : 'accessing' }
MooseRegenerateAllConcreteMetamodelsMenuCommand class >> label [

	^ 'Regenerate all concrete metamodels'
]

{ #category : 'world menu' }
MooseRegenerateAllConcreteMetamodelsMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
]

{ #category : 'accessing' }
MooseRegenerateAllConcreteMetamodelsMenuCommand class >> menuPriority [

	^ super menuPriority + 1.5
]

{ #category : 'executing' }
MooseRegenerateAllConcreteMetamodelsMenuCommand >> execute [

	FamixMetamodelGenerator generateAllMetamodelsSuchAs: [ :generator | (generator package name includesSubstring: 'Test') not ]
]
