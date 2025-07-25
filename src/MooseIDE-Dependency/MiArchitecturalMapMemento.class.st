Class {
	#name : #MiArchitecturalMapMemento,
	#superclass : #MiMemento,
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
MiArchitecturalMapMemento class >> fromDefaultsHolder: aDefaultsHolder [

	^ self new
		  defaultsHolder: aDefaultsHolder;
		  layout: aDefaultsHolder layout;
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
MiArchitecturalMapMemento >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiArchitecturalMapMemento >> associationTypes: aCollection [

	associationTypes := aCollection
]

{ #category : #available }
MiArchitecturalMapMemento >> availableAssociationTypes [

	^ defaultsHolder availableAssociationTypes
]

{ #category : #available }
MiArchitecturalMapMemento >> availableDoubleClickActions [

	^ defaultsHolder availableDoubleClickActions
]

{ #category : #available }
MiArchitecturalMapMemento >> availableLayouts [

	^ defaultsHolder availableLayouts
]

{ #category : #available }
MiArchitecturalMapMemento >> availableTags [

	^ defaultsHolder availableTags
]

{ #category : #accessing }
MiArchitecturalMapMemento >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiArchitecturalMapMemento >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : #accessing }
MiArchitecturalMapMemento >> defaultsHolder: aSettingsDefaultHolder [

	defaultsHolder := aSettingsDefaultHolder
]

{ #category : #accessing }
MiArchitecturalMapMemento >> doubleClickAction [

	^ doubleClickCommand
]

{ #category : #accessing }
MiArchitecturalMapMemento >> doubleClickAction: aCommand [

	doubleClickCommand := aCommand
]

{ #category : #accessing }
MiArchitecturalMapMemento >> hideMegamorphicInvocations [

	^ hideMegamorphicInvocations
]

{ #category : #accessing }
MiArchitecturalMapMemento >> hideMegamorphicInvocations: aBoolean [

	hideMegamorphicInvocations := aBoolean
]

{ #category : #accessing }
MiArchitecturalMapMemento >> hideReceivedEntities [

	^ hideReceivedEntities
]

{ #category : #accessing }
MiArchitecturalMapMemento >> hideReceivedEntities: aBoolean [

	hideReceivedEntities := aBoolean
]

{ #category : #accessing }
MiArchitecturalMapMemento >> layout [

	^ layout
]

{ #category : #accessing }
MiArchitecturalMapMemento >> layout: aRSLayout [

	layout := aRSLayout
]

{ #category : #accessing }
MiArchitecturalMapMemento >> megamorphicTreshold [

	^ megamorphicTreshold
]

{ #category : #accessing }
MiArchitecturalMapMemento >> megamorphicTreshold: anInteger [

	megamorphicTreshold := anInteger
]

{ #category : #ui }
MiArchitecturalMapMemento >> settingsPresenters [

	^ super settingsPresenters
		  add: (MiLayoutSettingPresenter on: self);
		  add: ((MiQuerySettingPresenter on: self)
				   beForChildren;
				   yourself);
		  add: (MiAssociationTypesSettingPresenter on: self);
		  add: (MiMegamorphicInvocationsSettingPresenter on: self);
		  add: (MiTagsSettingPresenter on: self);
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

{ #category : #accessing }
MiArchitecturalMapMemento >> showDirectoriesAsRootNodes [

	^ showDirectoriesAsRootNodes
]

{ #category : #accessing }
MiArchitecturalMapMemento >> showDirectoriesAsRootNodes: aBoolean [

	showDirectoriesAsRootNodes := aBoolean
]

{ #category : #accessing }
MiArchitecturalMapMemento >> tags [

	^ tags
]

{ #category : #accessing }
MiArchitecturalMapMemento >> tags: aCollection [

	tags := aCollection
]
