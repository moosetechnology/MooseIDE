"
I check that every MooseIDE model (class named Mi*Model in a MooseIDE-* package) inherits from MiAbstractModel (MiAbstractModel itself excepted).

Collaborators: MiAbstractModel; definitions inherited from MiAbstractArchitecturalRule.
Main API: #basicCheck: answers true for a model outside the MiAbstractModel hierarchy.
"
Class {
	#name : 'MiModelInheritanceRule',
	#superclass : 'MiAbstractArchitecturalRule',
	#category : 'MooseIDE-ArchitecturalRules',
	#package : 'MooseIDE-ArchitecturalRules'
}

{ #category : 'accessing' }
MiModelInheritanceRule class >> rationale [
	^ 'All MooseIDE models (classes named Mi*Model in a MooseIDE-* package) must inherit from MiAbstractModel, which defines the protocol for the displayed (#entities) and selected (#miSelectedItem) entities.'
]

{ #category : 'accessing' }
MiModelInheritanceRule class >> ruleName [
	^ 'MooseIDE model does not inherit from MiAbstractModel'
]

{ #category : 'manifest' }
MiModelInheritanceRule class >> uniqueIdentifierName [
	^ 'MiModelInheritanceRule'
]

{ #category : 'running' }
MiModelInheritanceRule >> basicCheck: aClass [
	^ (self isModel: aClass) and: [
		  aClass ~~ MiAbstractModel and: [ (aClass inheritsFrom: MiAbstractModel) not ] ]
]
