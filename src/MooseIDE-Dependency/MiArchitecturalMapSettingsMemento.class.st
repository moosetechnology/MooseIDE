Class {
	#name : #MiArchitecturalMapSettingsMemento,
	#superclass : #Object,
	#instVars : [
		'associationTypes',
		'availableAssociationTypes'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> associationTypes: aCollection [

	associationTypes := aCollection
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> availableAssociationTypes [

	^ availableAssociationTypes
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> availableAssociationTypes: aCollection [

	availableAssociationTypes := aCollection
]
