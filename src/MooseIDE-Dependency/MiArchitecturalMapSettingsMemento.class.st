Class {
	#name : #MiArchitecturalMapSettingsMemento,
	#superclass : #Object,
	#instVars : [
		'associationTypes',
		'tags',
		'childrenQuery',
		'hideReceivedEntities',
		'doubleClickCommand',
		'layout',
		'hideMegamorphicInvocations',
		'megamorphicTreshold',
		'showDirectoriesAsRootNodes',
		'defaultsHolder'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #'instance creation' }
MiArchitecturalMapSettingsMemento class >> fromDefaultsHolder: aDefaultsHolder [

	^ self new
		  defaultsHolder: aDefaultsHolder;
		  layout: aDefaultsHolder defaultLayout;
		  associationTypes: aDefaultsHolder availableAssociationTypes;
		  tags: aDefaultsHolder tags;
		  hideReceivedEntities: aDefaultsHolder hideReceivedEntities;
		  childrenQuery: aDefaultsHolder childrenQuery;
		  doubleClickAction: aDefaultsHolder doubleClickAction;
		  hideMegamorphicInvocations:
			  aDefaultsHolder hideMegamorphicInvocations;
		  megamorphicTreshold: aDefaultsHolder megamorphicTreshold;
		  showDirectoriesAsRootNodes:
			  aDefaultsHolder showDirectoriesAsRootNodes;
		  yourself
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> associationTypes: aCollection [

	associationTypes := aCollection
]

{ #category : #available }
MiArchitecturalMapSettingsMemento >> availableAssociationTypes [

	^ defaultsHolder availableAssociationTypes
]

{ #category : #available }
MiArchitecturalMapSettingsMemento >> availableDoubleClickActions [

	^ defaultsHolder availableDoubleClickActions
]

{ #category : #available }
MiArchitecturalMapSettingsMemento >> availableLayouts [

	^ defaultsHolder availableLayouts
]

{ #category : #available }
MiArchitecturalMapSettingsMemento >> availableTags [

	^ defaultsHolder availableTags
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> defaultsHolder: aSettingsDefaultHolder [

	defaultsHolder := aSettingsDefaultHolder
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> doubleClickAction [

	^ doubleClickCommand
]

{ #category : #accessing }
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
MiArchitecturalMapSettingsMemento >> showDirectoriesAsRootNodes [

	^ showDirectoriesAsRootNodes
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> showDirectoriesAsRootNodes: aBoolean [

	showDirectoriesAsRootNodes := aBoolean
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> tags [

	^ tags
]

{ #category : #accessing }
MiArchitecturalMapSettingsMemento >> tags: aCollection [

	tags := aCollection
]
