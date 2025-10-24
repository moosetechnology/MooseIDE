"
I am a model of a hierarchical map.
I am responsible for:
- holding a property list
- holding elements to display on the hierarchical map.
"
Class {
	#name : 'MiArchitecturalMapModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
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
		'weightedLinks'
	],
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'available' }
MiArchitecturalMapModel class >> availableLayouts [
	"RSLayout withAllSubclasses reject: [ :c | c isAbstract ]
But some of them require specific configuration that we cannot easily specify here so we choose a subset of the simplest ones"

	^ {
		  RSFlowLayout.
		  RSCircleLayout.
		  RSGridLayout.
		  RSTreeLayout.
		  MiForceBasedLayout }
]

{ #category : 'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTagIsDead [

	^ MiDynamicTag new
		  color: Color black ;
		  name: 'Is dead' ;
		  query: [ :e | e isDead ] ;
		  yourself
]

{ #category : 'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTagIsStub [

	^ MiDynamicTag new
		  color: Color yellow ;
		  name: 'Is stub' ;
		  query: [ :e | e isStub ] ;
		  yourself
]

{ #category : 'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTags [

	^ { 
		  self defaultDynamicTagIsStub .
		  self defaultDynamicTagIsDead }
]

{ #category : 'defaults' }
MiArchitecturalMapModel class >> defaultHideMegamorphicInvocations [

	^ false
]

{ #category : 'defaults' }
MiArchitecturalMapModel class >> defaultHideReceivedEntities [

	^ false
]

{ #category : 'defaults' }
MiArchitecturalMapModel class >> defaultLayout [

	^ RSFlowLayout
]

{ #category : 'defaults' }
MiArchitecturalMapModel class >> defaultMegamorphicTreshold [

	^ 10
]

{ #category : 'defaults' }
MiArchitecturalMapModel class >> defaultShowDirectoriesAsRootNodes [

	^ false
]

{ #category : 'defaults' }
MiArchitecturalMapModel class >> defaultTags [

	^ OrderedCollection new
]

{ #category : 'defaults' }
MiArchitecturalMapModel class >> weightedLinks [

	^ false
]

{ #category : 'private' }
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

{ #category : 'accessing' }
MiArchitecturalMapModel >> associationTypes [

	^ associationTypes
]

{ #category : 'available' }
MiArchitecturalMapModel >> availableAssociationTypes [

	entities ifNil: [ ^ OrderedCollection new ].

	^ ((entities select: #isQueryable) asMooseGroup allEntityTypes
		   flatCollectAsSet: [ :class |
		   class allIncomingAssociationTypesIn: entities metamodel ])
		  asOrderedCollection
]

{ #category : 'available' }
MiArchitecturalMapModel >> availableDoubleClickActions [

	^ {
		  MiExpandCollapseShapeCommand new.
		  MiInspectShapeCommand new.
		  (MiPropagateShapeCommand new
			   browser: browser;
			   yourself) }
]

{ #category : 'available' }
MiArchitecturalMapModel >> availableQueries [

	^ self currentApplication availableQueries
		  addFirst: self currentApplication childrenQuery;
		  yourself
]

{ #category : 'available' }
MiArchitecturalMapModel >> availableTags [

	entities isEmptyOrNil ifTrue: [ ^ OrderedCollection new ].

	^ entities anyOne mooseModel allTags sorted: #name ascending
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> childrenFor: anEntity [

	^ virtualEntities
		  at: anEntity
		  ifPresent: [ :children | children ]
		  ifAbsent: [
				  (childrenQuery rawRunOnEntity: anEntity) asArray reject: [ :each |
					  each == anEntity ] ]
]

{ #category : 'private' }
MiArchitecturalMapModel >> computeRootEntities [

	| nodesParent |
	nodesParent := Dictionary new.

	entities do: [ :parent |
		(self childrenFor: parent) do: [ :child |
			nodesParent at: child put: parent ] ].

	^entities select: [ :each |
		(nodesParent at: each ifAbsent: [ nil ]) isNil ]
]

{ #category : 'private' }
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

{ #category : 'settings management' }
MiArchitecturalMapModel >> currentConfiguration [

	^ MiArchitecturalMapSettingsConfiguration new
		  availableAssociationTypes: self availableAssociationTypes;
		  associationTypes: associationTypes;
		  availableDoubleClickActions: self availableDoubleClickActions;
		  doubleClickAction: doubleClickAction;
		  availableLayouts: self class availableLayouts;
		  layout: layout;
		  availableTags: self availableTags;
		  tags: tags;
		  hideReceivedEntities: hideReceivedEntities;
		  childrenQuery: childrenQuery;
		  hideMegamorphicInvocations: hideMegamorphicInvocations;
		  megamorphicTreshold: megamorphicTreshold;
		  showDirectoriesAsRootNodes: showDirectoriesAsRootNodes;
		  weightedLinks: weightedLinks;
		  yourself
]

{ #category : 'settings management' }
MiArchitecturalMapModel >> defaultConfiguration [

	^ MiArchitecturalMapSettingsConfiguration new
		  availableAssociationTypes: self availableAssociationTypes;
		  associationTypes: self availableAssociationTypes;
		  availableDoubleClickActions: self availableDoubleClickActions;
		  doubleClickAction: self defaultDoubleClickAction;
		  availableLayouts: self class availableLayouts;
		  layout: self class defaultLayout;
		  availableTags: self availableTags;
		  tags: self class defaultTags;
		  hideReceivedEntities: self class defaultHideReceivedEntities;
		  childrenQuery: self defaultChildrenQuery;
		  hideMegamorphicInvocations:
			  self class defaultHideMegamorphicInvocations;
		  megamorphicTreshold: self class defaultMegamorphicTreshold;
		  showDirectoriesAsRootNodes:
			  self class defaultShowDirectoriesAsRootNodes;
		  weightedLinks: self class weightedLinks;
		  yourself
]

{ #category : 'settings management' }
MiArchitecturalMapModel >> defaultDoubleClickAction [

	^ self availableDoubleClickActions first
]

{ #category : 'settings' }
MiArchitecturalMapModel >> doubleClickActOn: aShape [

	doubleClickAction
		context: aShape;
		execute
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> entities [

	^ entities
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> entities: aCollection [

	entities := aCollection.
	self recomputeRootNodes.
	self recomputeDefaultSettings
]

{ #category : 'testing' }
MiArchitecturalMapModel >> hasSettings [

	^ true
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> hideReceivedEntities [

	^ hideReceivedEntities
]

{ #category : 'initialization' }
MiArchitecturalMapModel >> initializeSettings [

	associationTypes := self availableAssociationTypes.
	tags := self class defaultTags.
	childrenQuery := self defaultChildrenQuery.
	hideReceivedEntities := self class defaultHideReceivedEntities.
	doubleClickAction := self defaultDoubleClickAction.
	layout := self class defaultLayout.
	hideMegamorphicInvocations := self class defaultHideMegamorphicInvocations.
	megamorphicTreshold := self class defaultMegamorphicTreshold.
	showDirectoriesAsRootNodes := self class defaultShowDirectoriesAsRootNodes.
	weightedLinks := self class weightedLinks 
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> layout [

	^ layout
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> miSelectedItem [

	^ self entities
]

{ #category : 'settings management' }
MiArchitecturalMapModel >> recomputeDefaultSettings [

	associationTypes := self availableAssociationTypes
]

{ #category : 'private' }
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

{ #category : 'accessing' }
MiArchitecturalMapModel >> rootNodes [

	^roots
]

{ #category : 'interactions' }
MiArchitecturalMapModel >> selectRelatedTo: anEntity [ 

	browser selectRelatedTo: anEntity 

]

{ #category : 'settings management' }
MiArchitecturalMapModel >> settingsPresenterExtent [

	^ 600 @ 600
]

{ #category : 'settings' }
MiArchitecturalMapModel >> shouldHideDependency: aFamixAssociation [

	^ hideMegamorphicInvocations and: [
			  aFamixAssociation isInvocation and: [
				  aFamixAssociation candidates size > megamorphicTreshold ] ]
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> showAllLinks [

	^ true
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> tags [

	^ tags
]

{ #category : 'settings management' }
MiArchitecturalMapModel >> updateFromConfiguration: aConfiguration [

	associationTypes := aConfiguration associationTypes.
	tags := aConfiguration tags.
	hideReceivedEntities := aConfiguration hideReceivedEntities.
	childrenQuery := aConfiguration childrenQuery.
	doubleClickAction := aConfiguration doubleClickAction.
	layout := aConfiguration layout.
	hideMegamorphicInvocations := aConfiguration hideMegamorphicInvocations.
	megamorphicTreshold := aConfiguration megamorphicTreshold.
	showDirectoriesAsRootNodes := aConfiguration showDirectoriesAsRootNodes.
	weightedLinks := aConfiguration weightedLinks.

	self recomputeRootNodes.
	browser runVisualization
]

{ #category : 'private' }
MiArchitecturalMapModel >> virtualEntity: aFileReference belowRoot: virtualRoot [

	aFileReference = virtualRoot rawEntity ifTrue: [ ^virtualRoot ].
	aFileReference = '.' asFileReference ifTrue: [ ^virtualRoot ].
	^virtualEntities keys
		detect: [ :virtualEntity | virtualEntity rawEntity = aFileReference ]
		ifNone: [ MiArchitecturalMapVirtualEntity new rawEntity: aFileReference ]
]

{ #category : 'accessing' }
MiArchitecturalMapModel >> weightedLinks [
	^ weightedLinks
]
