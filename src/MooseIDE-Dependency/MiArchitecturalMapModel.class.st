"
I am a model of a hierarchical map.
I am responsible for:
- holding a property list
- holding elements to display on the hierarchical map.
"
Class {
	#name : #MiArchitecturalMapModel,
	#superclass : #MiAbstractModel,
	#traits : 'MiTSpecModelWithSettings',
	#classTraits : 'MiTSpecModelWithSettings classTrait',
	#instVars : [
		'entities',
		'settings',
		'virtualEntities',
		'roots',
		'associationTypes',
		'tags',
		'childrenQuery',
		'hideReceivedEntities',
		'doubleClickAction',
		'layout',
		'hideMegamorphicInvocations',
		'megamorphicTreshold',
		'showDirectoriesAsRootNodes',
		'default'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTagIsDead [

	^ MiDynamicTag new
		  color: Color black ;
		  name: 'Is dead' ;
		  query: [ :e | e isDead ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTagIsStub [

	^ MiDynamicTag new
		  color: Color yellow ;
		  name: 'Is stub' ;
		  query: [ :e | e isStub ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTags [

	^ { 
		  self defaultDynamicTagIsStub .
		  self defaultDynamicTagIsDead }
]

{ #category : #settings }
MiArchitecturalMapModel class >> settingsCommandsOn: aMemento [

	^ OrderedCollection new
		  add: (MiLayoutSettingCommand forContext: aMemento);
		  add: (MiChildrenQuerySettingCommand forContext: aMemento);
		  add: (MiAssociationTypesSettingCommand forContext: aMemento);
		  add: (MiMegamorphicInvocationsSettingCommand forContext: aMemento);
		  add: (MiTagsSettingCommand forContext: aMemento);
		  add: (MiHideEntitiesSettingCommand forContext: aMemento);
		  add: (MiDirectoriesAsRootNodesSettingCommand forContext: aMemento);
		  add: (MiDoubleClickSettingCommand forContext: aMemento);
		  yourself
]

{ #category : #private }
MiArchitecturalMapModel >> addVirtualParent: aFileReference child: entity upTo: virtualRoot [
	"#virtualEntities is a Dictionnary where the keys are the virtual entities
	 and the values their children
	Here the virtual entities are fileReferences"

	| virtualEntity virtualChildren |
	virtualEntity := self virtualEntity: aFileReference belowRoot: virtualRoot.

	virtualChildren := virtualEntities
		at: virtualEntity
		ifAbsentPut: [ OrderedCollection new ].
	(virtualChildren includes: entity)
		ifFalse: [virtualChildren add: entity].

	virtualEntity = virtualRoot ifFalse: [
		self
			addVirtualParent: aFileReference parent
			child: virtualEntity
			upTo: virtualRoot ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenFor: anEntity [

	^ virtualEntities
		  at: anEntity
		  ifPresent: [ :children | children ]
		  ifAbsent: [
				  (childrenQuery rawRunOnEntity: anEntity) asArray reject: [ :each |
					  each == anEntity ] ]
]

{ #category : #private }
MiArchitecturalMapModel >> computeRootEntities [

	| nodesParent |
	nodesParent := Dictionary new.

	entities do: [ :parent |
		(self childrenFor: parent) do: [ :child |
			nodesParent at: child put: parent ] ].

	^entities select: [ :each |
		(nodesParent at: each ifAbsent: [ nil ]) isNil ]
]

{ #category : #private }
MiArchitecturalMapModel >> computeVirtualRoots: rootEntities [
	"#virtualEntities is a Dictionnary where the keys are the virtual entities and the values their children
	Here we compute virtual entities from the directories containing the real entities"

	| virtualRoot entityFile |
	virtualRoot := MiArchitecturalMapVirtualEntity new rawEntity:
		               self currentMooseModel rootFolder asFileReference.

	rootEntities do: [ :entity |
			(entity hasSourceAnchor and: [ entity sourceAnchor isFileAnchor ])
				ifTrue: [
						entityFile := entity sourceAnchor fileName asFileReference.
						self
							addVirtualParent: entityFile parent
							child: entity
							upTo: virtualRoot ] ].

	^ { virtualRoot }
]

{ #category : #settings }
MiArchitecturalMapModel >> doubleClickActOn: aShape [

	doubleClickAction
		context: aShape;
		execute
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities: aCollection [

	entities := aCollection.
	self recomputeRootNodes.
	self recomputeDefaultSettings
]

{ #category : #accessing }
MiArchitecturalMapModel >> hideReceivedEntities [

	^ hideReceivedEntities
]

{ #category : #initialization }
MiArchitecturalMapModel >> initializeSettings [

	default := MiArchitecturalMapSettingsDefaultHolder on: self.

	associationTypes := default associationTypes.
	tags := default tags.
	childrenQuery := self currentApplication defaultChildrenQuery.
	hideReceivedEntities := default hideReceivedEntities.
	doubleClickAction := default doubleClickAction.
	layout := default layout.
	hideMegamorphicInvocations := default hideMegamorphicInvocations.
	megamorphicTreshold := default megamorphicTreshold.
	showDirectoriesAsRootNodes := default showDirectoriesAsRootNodes
]

{ #category : #accessing }
MiArchitecturalMapModel >> layout [

	^ layout
]

{ #category : #accessing }
MiArchitecturalMapModel >> miSelectedItem [

	^ self entities
]

{ #category : #'settings management' }
MiArchitecturalMapModel >> newMemento [

	^ MiArchitecturalMapSettingsMemento new
		  defaultsHolder: default;
		  layout: layout;
		  associationTypes: associationTypes;
		  tags: tags;
		  hideReceivedEntities: hideReceivedEntities;
		  childrenQuery: childrenQuery;
		  doubleClickAction: doubleClickAction;
		  hideMegamorphicInvocations: hideMegamorphicInvocations;
		  megamorphicTreshold: megamorphicTreshold;
		  showDirectoriesAsRootNodes: showDirectoriesAsRootNodes;
		  yourself
]

{ #category : #'settings management' }
MiArchitecturalMapModel >> newMementoForDefaultValues [

	^ MiArchitecturalMapSettingsMemento fromDefaultsHolder:
		  default
]

{ #category : #'settings management' }
MiArchitecturalMapModel >> recomputeDefaultSettings [

	associationTypes := default availableAssociationTypes
]

{ #category : #private }
MiArchitecturalMapModel >> recomputeRootNodes [
	"Assumes each entity has only one parent"

	| rootEntities |
	virtualEntities := Dictionary new.

	entities ifNil: [ ^ roots := #(  ) ].

	rootEntities := self computeRootEntities.

	roots := showDirectoriesAsRootNodes
		         ifTrue: [ self computeVirtualRoots: rootEntities ]
		         ifFalse: [ rootEntities ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> rootNodes [

	^roots
]

{ #category : #settings }
MiArchitecturalMapModel >> shouldHideDependency: aFamixAssociation [

	^ hideMegamorphicInvocations and: [
			  aFamixAssociation isInvocation and: [
				  aFamixAssociation candidates size > megamorphicTreshold ] ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> showAllLinks [

	^ true
]

{ #category : #accessing }
MiArchitecturalMapModel >> tags [

	^ tags
]

{ #category : #'settings management' }
MiArchitecturalMapModel >> updateFromMemento: aMemento [

	associationTypes := aMemento associationTypes.
	tags := aMemento tags.
	hideReceivedEntities := aMemento hideReceivedEntities.
	childrenQuery := aMemento childrenQuery.
	doubleClickAction := aMemento doubleClickAction.
	layout := aMemento layout.
	hideMegamorphicInvocations := aMemento hideMegamorphicInvocations.
	megamorphicTreshold := aMemento megamorphicTreshold.
	showDirectoriesAsRootNodes := aMemento showDirectoriesAsRootNodes.

	self recomputeRootNodes.
	browser runVisualization
]

{ #category : #private }
MiArchitecturalMapModel >> virtualEntity: aFileReference belowRoot: virtualRoot [

	aFileReference = virtualRoot rawEntity ifTrue: [ ^virtualRoot ].
	aFileReference = '.' asFileReference ifTrue: [ ^virtualRoot ].
	^virtualEntities keys
		detect: [ :virtualEntity | virtualEntity rawEntity = aFileReference ]
		ifNone: [ MiArchitecturalMapVirtualEntity new rawEntity: aFileReference ]
]
