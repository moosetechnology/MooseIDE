Class {
	#name : 'MiArchitecturalMapSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
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
		'availableTags',
		'availableLayouts',
		'availableDoubleClickActions',
		'availableAssociationTypes'
	],
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> associationTypes [

	^ associationTypes
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> associationTypes: aCollection [

	associationTypes := aCollection
]

{ #category : 'available' }
MiArchitecturalMapSettingsConfiguration >> availableAssociationTypes [

	^ availableAssociationTypes
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> availableAssociationTypes: anObject [

	availableAssociationTypes := anObject
]

{ #category : 'available' }
MiArchitecturalMapSettingsConfiguration >> availableDoubleClickActions [

	^ availableDoubleClickActions
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> availableDoubleClickActions: anObject [

	availableDoubleClickActions := anObject
]

{ #category : 'available' }
MiArchitecturalMapSettingsConfiguration >> availableLayouts [

	^ availableLayouts
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> availableLayouts: anObject [

	availableLayouts := anObject
]

{ #category : 'available' }
MiArchitecturalMapSettingsConfiguration >> availableTags [

	^ availableTags
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> availableTags: anObject [

	availableTags := anObject
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> childrenQuery [

	^ childrenQuery
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> doubleClickAction [

	^ doubleClickCommand
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> doubleClickAction: aCommand [

	doubleClickCommand := aCommand
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> hideMegamorphicInvocations [

	^ hideMegamorphicInvocations
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> hideMegamorphicInvocations: aBoolean [

	hideMegamorphicInvocations := aBoolean
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> hideReceivedEntities [

	^ hideReceivedEntities
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> hideReceivedEntities: aBoolean [

	hideReceivedEntities := aBoolean
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> layout [

	^ layout
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> layout: aRSLayout [

	layout := aRSLayout
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> megamorphicTreshold [

	^ megamorphicTreshold
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> megamorphicTreshold: anInteger [

	megamorphicTreshold := anInteger
]

{ #category : 'ui' }
MiArchitecturalMapSettingsConfiguration >> settingsPresenters [

	^ super settingsPresenters
		  add: (MiLayoutSettingPresenter on: self);
		  add: ((MiQuerySettingPresenter on: self)
				   beForChildren;
				   yourself);
		  add: (MiAssociationTypesSettingPresenter on: self);
		  add: (MiMegamorphicInvocationsSettingPresenter on: self);
		  add: ((MiTagsSettingPresenter on: self)
				   label: 'Show these tags as entities:';
				   help:
					   'The selected tags will be represented as entities in the visualisation.
Inner elements will be the tagged entities';
				   yourself);
		  add: ((MiBooleanSettingPresenter on: self)
				   label: 'Hide received entities';
				   help:
					   'When showing tags, hide the received entities to show only the tagged entities';
				   state: hideReceivedEntities;
				   whenStateChangedDo: [ :boolean |
					   self hideReceivedEntities: boolean ];
				   yourself);
		  add: ((MiBooleanSettingPresenter on: self)
				   label: 'Show directories as root nodes (experimental)';
				   help:
					   'Experimental feature. Show the source files/directories containing entites as root nodes in the map';
				   state: showDirectoriesAsRootNodes;
				   whenStateChangedDo: [ :boolean |
					   self showDirectoriesAsRootNodes: boolean ];
				   yourself);
		  add: (MiDoubleClickSettingPresenter on: self);
		  yourself
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> showDirectoriesAsRootNodes [

	^ showDirectoriesAsRootNodes
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> showDirectoriesAsRootNodes: aBoolean [

	showDirectoriesAsRootNodes := aBoolean
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> tags [

	^ tags
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> tags: aCollection [

	tags := aCollection
]
