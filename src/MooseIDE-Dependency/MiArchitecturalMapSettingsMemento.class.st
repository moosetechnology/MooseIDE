Class {
	#name : #MiArchitecturalMapSettingsMemento,
	#superclass : #Object,
	#instVars : [
		'associationTypes',
		'availableAssociationTypes',
		'tags',
		'availableTags'
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

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> availableTags [

	^ availableTags
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> availableTags: aCollection [

	availableTags := aCollection
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> tags [

	^ tags
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> tags: aCollection [

	tags := aCollection
]
