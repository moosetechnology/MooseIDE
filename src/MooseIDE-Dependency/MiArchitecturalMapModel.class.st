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
		'megamorphicTreshold'
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

{ #category : #settings }
MiArchitecturalMapModel >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableAssociationTypes [

	^ ((entities asMooseGroup select: #isQueryable) allEntityTypes
		   flatCollectAsSet: [ :class |
		   class allIncomingAssociationTypesIn: entities metamodel ])
		  asOrderedCollection
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableDoubleClickActions [

	^ {
		  MiExpandCollapseShapeCommand new.
		  MiInspectShapeCommand new.
		  (MiPropagateShapeCommand new
			   browser: browser;
			   yourself) }
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableLayouts [
	"all available layouts: 
	  RSLayout withAllSubclasses reject: [ :c | c isAbstract ]
	But some of them require specific configuration that we cannot easily specify here
	so we choose a subset of the simplest ones"

	^ {
		  RSFlowLayout.
		  RSCircleLayout.
		  RSGridLayout.
		  RSTreeLayout }
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableQueries [

	^ self currentApplication availableQueries
		  addFirst: self currentApplication defaultChildrenQuery;
		  yourself
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableTags [

	entities ifNotNil: [ :ents |
			ents ifNotEmpty: [
				^ ents anyOne mooseModel allTags sorted: #name ascending ] ].

	^ OrderedCollection new
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
MiArchitecturalMapModel >> colorFor: anEntity [

	^ Color gray
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

{ #category : #accessing }
MiArchitecturalMapModel >> defaultDoubleClickAction [

	^ self availableDoubleClickActions first
]

{ #category : #accessing }
MiArchitecturalMapModel >> defaultLayout [

	^ RSFlowLayout
]

{ #category : #accessing }
MiArchitecturalMapModel >> defaultMegamorphicTreshold [

	^ 10
]

{ #category : #settings }
MiArchitecturalMapModel >> directoriesVirtualNodes [

	^ settings getItemValue: #directoriesVirtualNodes
]

{ #category : #'as yet unclassified' }
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
	self updateSettings
]

{ #category : #accessing }
MiArchitecturalMapModel >> fetchTags [

	entities ifNotNil: [ :ents |
			ents ifNotEmpty: [
				^ ents anyOne mooseModel allTags sorted: #name ascending ] ].

	^ #(  )
]

{ #category : #settings }
MiArchitecturalMapModel >> hideReceivedEntities [

	^ hideReceivedEntities
]

{ #category : #initialization }
MiArchitecturalMapModel >> initializeSettings [

	associationTypes := self availableAssociationTypes.
	tags := OrderedCollection new.
	childrenQuery := self currentApplication defaultChildrenQuery.
	hideReceivedEntities := false.
	doubleClickAction := self defaultDoubleClickAction.
	layout := self defaultLayout.
	hideMegamorphicInvocations := false.
	megamorphicTreshold := self defaultMegamorphicTreshold.

	settings := super initializeSettings
		            addItem: self itemTimeoutDuration
		            named: #timeoutDuration;
		            addItem: self itemDirectoriesVirtualNodes
		            named: #directoriesVirtualNodes;
		            yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemDirectoriesVirtualNodes [

	^ MiAbstractSettingItem checkboxSetting
		  setValue: false ;
		  label: 'Directories are root nodes? (experimental)';
		  help:
			  'If checked the source files/directories containing entites are treated and showed in the map.
They are root nodes in the map';
		  yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemTimeoutDuration [
	"Default arbitrary timeout of 30s"

	^ MiTextSettingItem integerSetting
		  setValue: 30;
		  label: 'Timeout duration (seconds)';
		  help:
			  'How long to wait before interrupting the process. No value means no timeout.';
		  yourself
]

{ #category : #accessing }
MiArchitecturalMapModel >> layout [
	^ layout
]

{ #category : #accessing }
MiArchitecturalMapModel >> miSelectedItem [

	^self entities
]

{ #category : #'settings management' }
MiArchitecturalMapModel >> newMemento [

	^ MiArchitecturalMapSettingsMemento new
		  availableLayouts: self availableLayouts;
		  layout: layout;
		  availableAssociationTypes: self availableAssociationTypes;
		  associationTypes: associationTypes;
		  tags: tags;
		  availableTags: self availableTags;
		  hideReceivedEntities: hideReceivedEntities;
		  childrenQuery: childrenQuery;
		  availableDoubleClickActions: self availableDoubleClickActions;
		  doubleClickAction: doubleClickAction;
		  hideMegamorphicInvocations: hideMegamorphicInvocations;
		  megamorphicTreshold: megamorphicTreshold;
		  yourself
]

{ #category : #'settings management' }
MiArchitecturalMapModel >> newMementoForDefaultValues [

	^ MiArchitecturalMapSettingsMemento new
		  availableLayouts: self availableLayouts;
		  layout: self defaultLayout;
		  availableAssociationTypes: self availableAssociationTypes;
		  associationTypes: self availableAssociationTypes;
		  tags: self availableTags;
		  availableTags: self availableTags;
		  hideReceivedEntities: false;
		  childrenQuery: self currentApplication defaultChildrenQuery;
		  availableDoubleClickActions: self availableDoubleClickActions;
		  doubleClickAction: self defaultDoubleClickAction;
		  hideMegamorphicInvocations: false;
		  megamorphicTreshold: self defaultMegamorphicTreshold;
		  yourself
]

{ #category : #private }
MiArchitecturalMapModel >> recomputeRootNodes [
	"Assumes each entity has only one parent"

	| rootEntities |
	virtualEntities := Dictionary new.

	entities ifNil: [ ^ roots := #(  ) ].

	rootEntities := self computeRootEntities.

	roots := self directoriesVirtualNodes
		         ifTrue: [ self computeVirtualRoots: rootEntities ]
		         ifFalse: [ rootEntities ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> rootNodes [

	^roots
]

{ #category : #settings }
MiArchitecturalMapModel >> settings [
	^settings
]

{ #category : #settings }
MiArchitecturalMapModel >> settingsChanged: aBoolean [

	aBoolean ifFalse: [ ^self ].
	self recomputeRootNodes.
	browser runVisualization

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

{ #category : #settings }
MiArchitecturalMapModel >> tags [

	^ tags
]

{ #category : #settings }
MiArchitecturalMapModel >> timeoutDuration [

	^ settings getItemValue: #timeoutDuration
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

	self recomputeRootNodes.
	browser runVisualization
]

{ #category : #settings }
MiArchitecturalMapModel >> updateSettings [

	associationTypes := self availableAssociationTypes
]

{ #category : #private }
MiArchitecturalMapModel >> virtualEntity: aFileReference belowRoot: virtualRoot [

	aFileReference = virtualRoot rawEntity ifTrue: [ ^virtualRoot ].
	aFileReference = '.' asFileReference ifTrue: [ ^virtualRoot ].
	^virtualEntities keys
		detect: [ :virtualEntity | virtualEntity rawEntity = aFileReference ]
		ifNone: [ MiArchitecturalMapVirtualEntity new rawEntity: aFileReference ]
]
