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
		'availableAssociationTypes',
		'weightedLinks',
		'associationTypesMode',
		'tagsMode'
	],
	#category : 'MooseIDE-ArchitecturalMap',
	#package : 'MooseIDE-ArchitecturalMap'
}

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> associationTypes [

	^ associationTypes
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> associationTypes: aCollection [

	associationTypes := aCollection
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> associationTypesMode [

	^ associationTypesMode
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> associationTypesMode: aSymbol [

	associationTypesMode := aSymbol
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

{ #category : 'ston persistence' }
MiArchitecturalMapSettingsConfiguration >> fromSton: stonReader [
	"The children query was saved as code (see #stonOn:), we compile it back"

	stonReader parseMapDo: [ :name :value |
		self
			instVarNamed: name
			put: ((name = #childrenQuery and: [ value isString ])
					 ifTrue: [ self class compiler evaluate: value ]
					 ifFalse: [ value ]) ]
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
				   label: 'Show the weight of links';
				   help:
					   'Show how many dependencies are included in a link';
				   state: weightedLinks;
				   whenStateChangedDo: [ :boolean |
					   self weightedLinks: boolean ];
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

{ #category : 'ston persistence' }
MiArchitecturalMapSettingsConfiguration >> stonOn: stonWriter [
	"The children query holds a block that STON cannot write.
	We save it as code, using FQScriptQuery>>#storeOn:, and keep its name
	so that the reloaded query is equal to the one in the settings droplist"

	stonWriter writeObject: self streamMap: [ :map |
		self class instVarNames do: [ :name |
			| value |
			value := self instVarNamed: name.
			(name = #childrenQuery and: [ value isNotNil ]) ifTrue: [
				value := '(' , value storeString , ') name: '
				         , value name storeString , '; yourself' ].
			map at: name asSymbol put: value ] ]
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> tags [

	^ tags
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> tags: aCollection [

	tags := aCollection
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> tagsMode [

	^ tagsMode
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> tagsMode: aSymbol [

	tagsMode := aSymbol
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> weightedLinks [

	^weightedLinks
]

{ #category : 'accessing' }
MiArchitecturalMapSettingsConfiguration >> weightedLinks: aBoolean [

	weightedLinks := aBoolean
]
