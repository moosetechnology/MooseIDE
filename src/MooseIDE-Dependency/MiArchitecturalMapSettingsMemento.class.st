Class {
	#name : #MiArchitecturalMapSettingsMemento,
	#superclass : #Object,
	#instVars : [
		'associationTypes',
		'availableAssociationTypes',
		'tags',
		'availableTags',
		'childrenQuery',
		'hideReceivedEntities',
		'doubleClickCommand',
		'availableDoubleClickActions',
		'availableLayouts',
		'layout',
		'hideMegamorphicInvocations',
		'megamorphicTreshold'
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
MiArchitecturalMapSettingsMemento >> availableDoubleClickActions [

	^ availableDoubleClickActions
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> availableDoubleClickActions: aCollection [

	availableDoubleClickActions := aCollection
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> availableLayouts [

	^ availableLayouts
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> availableLayouts: aCollection [

	availableLayouts := aCollection
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
MiArchitecturalMapSettingsMemento >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : #'as yet unclassified' }
MiArchitecturalMapSettingsMemento >> doubleClickAction [

	^ doubleClickCommand
]

{ #category : #'as yet unclassified' }
MiArchitecturalMapSettingsMemento >> doubleClickAction: aCommand [

	doubleClickCommand := aCommand
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> hideMegamorphicInvocations [

	^ hideMegamorphicInvocations
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> hideMegamorphicInvocations: aBoolean [

	hideMegamorphicInvocations := aBoolean
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> hideReceivedEntities [

	^ hideReceivedEntities
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> hideReceivedEntities: aBoolean [

	hideReceivedEntities := aBoolean
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> layout [

	^ layout
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> layout: aRSLayout [

	layout := aRSLayout
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> megamorphicTreshold [

	^ megamorphicTreshold
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> megamorphicTreshold: anInteger [

	megamorphicTreshold := anInteger
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> tags [

	^ tags
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> tags: aCollection [

	tags := aCollection
]
