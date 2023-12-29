"
I am a model of a hierarchical map.
I am responsible for:
- holding a property list
- holding elements to display on the hierarchical map.
"
Class {
	#name : #MiArchitecturalMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'childrenBlock',
		'settings',
		'defaultChildrenQuery',
		'virtualEntities',
		'roots'
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
MiArchitecturalMapModel >> allAssociationTypes [

	| mooseGroup |
	mooseGroup := entities asMooseGroup allUsing:
		              TEntityMetaLevelDependency.
	mooseGroup ifEmpty: [ ^ {  } ].
	^ (mooseGroup allEntityTypes flatCollectAsSet: [ :class | 
		   class allIncomingAssociationTypesIn: mooseGroup metamodel ])
		  asOrderedCollection
]

{ #category : #settings }
MiArchitecturalMapModel >> associationTypes [

	^ settings getItemValue: #associationTypes
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableLayouts [
	"all available layouts: 
	  RSLayout withAllSubclasses reject: [ :c | c isAbstract ]
	But some of them require specific configuration that we cannot easily specify here
	so we choose a subset of the simplest ones"
	^{ RSFlowLayout . RSCircleLayout . RSGridLayout }
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableQueries [

	^ { self defaultChildrenQuery } , browser availableQueries
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenFor: anEntity [

	^virtualEntities
		at: anEntity
		ifPresent: [ :children | children ]
		ifAbsent: [ self childrenQuerySetting runOn: anEntity asMooseGroup ]
]

{ #category : #settings }
MiArchitecturalMapModel >> childrenQuerySetting [

	^ settings getItemValue: #childrenQuery
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
	"#virtualEntities is a Dictionnary where the keys are the virtual entities
	 and the values their children
	Here we compute virtual entities from the directories containing the real entities"

	| virtualRoot entityFile |

	virtualRoot := MiArchitecturalMapVirtualEntity new
		rawEntity: self currentMooseModel rootFolder asFileReference.

	rootEntities do: [ :entity |
		(entity hasSourceAnchor and:
		[ entity sourceAnchor isFileAnchor ])
			ifTrue: [
				entityFile := entity sourceAnchor fileName asFileReference.
				self addVirtualParent: entityFile parent child: entity upTo: virtualRoot
			]
	].

	^{ virtualRoot }
]

{ #category : #accessing }
MiArchitecturalMapModel >> defaultChildrenQuery [

	^ defaultChildrenQuery ifNil: [ 
		  defaultChildrenQuery := FQCollectScriptQuery script: [ :e | 
			                          e children ] ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> defaultLayout [
	^RSFlowLayout
]

{ #category : #settings }
MiArchitecturalMapModel >> directoriesVirtualNodes [

	^ settings getItemValue: #directoriesVirtualNodes
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities: anObject [

	entities := anObject.
	self recomputeRootNodes.
	self updateSettings
]

{ #category : #accessing }
MiArchitecturalMapModel >> fetchTags [

	^ browser fetchTags
]

{ #category : #initialization }
MiArchitecturalMapModel >> initializeSettings [

	settings := super initializeSettings
						addItem: self itemShowBusEntities named: #showBusEntities;
						addItem: self itemChildrenQuery named: #childrenQuery;
						addItem: self itemTags named: #tags;
						addItem: self itemAssociationTypes named: #associationTypes;
						addItem: self itemLayout named: #layout;
						addItem: self itemNoMegaMorphic named: #noMegaMorphic;
						addItem: self itemMegaMorphicSize named: #megaMorphicSize;
						addItem: self itemTimeoutDuration named: #timeoutDuration;
						addItem: self itemDirectoriesVirtualNodes named: #directoriesVirtualNodes;
						yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemAssociationTypes [

	^ MiAbstractSettingItem buttonWithSelectableListSetting
		  possibleValues: self allAssociationTypes;
		  label: 'Links to show';
		  selectAll;
		  yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemChildrenQuery [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: self availableQueries;
		  setValue: self defaultChildrenQuery;
		  label: 'Children query';
		  help: 'The query giving all the children of any displayed entity';
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
MiArchitecturalMapModel >> itemLayout [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: self availableLayouts;
		  setValue: self defaultLayout;
		  label: 'Layout to display entities';
		  help: 'You can change the layout of the entities (eg: circular or flow layout)';
		  yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemMegaMorphicSize [
	^MiTextSettingItem integerSetting
		setValue: 10 ;
		label: 'Mega-morphic limit' ;
		help: 'How many implementors of a method make it mega-morphic?' ;
		yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemNoMegaMorphic [

	^MiCheckboxSettingItem new
		setValue: false ;
		label: 'Ignore mega-morphic invocations?' ;
		help: 'In the dependencies, ignore invocations of mega-morphic methods' ;
		yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemShowBusEntities [

	^ MiAbstractSettingItem checkboxSetting
		  setValue: true;
		  label: 'Show bus entities?';
		  help:
			  'If not checked, this will ignore entities in bus. Usefull when tags are added in the visualization.';
		  yourself
]

{ #category : #settings }
MiArchitecturalMapModel >> itemTags [

	^ MiAbstractSettingItem buttonWithEditableListSetting
		  updateWith: [ self fetchTags ];
		  possibleValues: self fetchTags;
		  displayIcon: [ :tag | MiTagBrowserModel iconForTag: tag ];
		  display: [ :tag | tag name ];
		  label: 'Tags to add';
		  help:
			  'The tags you want to add to the visualization. They will be entities and inner elements are tagged entities';
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

{ #category : #settings }
MiArchitecturalMapModel >> layoutSetting [

	^ settings getItemValue: #layout
]

{ #category : #settings }
MiArchitecturalMapModel >> megaMorphicSize [
	^settings getItemValue: #megaMorphicSize
]

{ #category : #accessing }
MiArchitecturalMapModel >> miSelectedItem [

	^self entities
]

{ #category : #settings }
MiArchitecturalMapModel >> noMegaMorphic [

	^ settings getItemValue: #noMegaMorphic
]

{ #category : #settings }
MiArchitecturalMapModel >> openSettings [

	settings open
]

{ #category : #private }
MiArchitecturalMapModel >> recomputeRootNodes [
	"Assumes each entity has only one parent"

	| rootEntities |

	virtualEntities := Dictionary new.

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

{ #category : #accessing }
MiArchitecturalMapModel >> showAllLinks [

	^ true
]

{ #category : #settings }
MiArchitecturalMapModel >> showBusEntities [

	^ settings getItemValue: #showBusEntities
]

{ #category : #settings }
MiArchitecturalMapModel >> tags [

	^ settings getItemValue: #tags
]

{ #category : #settings }
MiArchitecturalMapModel >> timeoutDuration [

	^ settings getItemValue: #timeoutDuration
]

{ #category : #settings }
MiArchitecturalMapModel >> updateSettings [

	(settings itemNamed: #associationTypes) possibleValues:
		self allAssociationTypes
]

{ #category : #private }
MiArchitecturalMapModel >> virtualEntity: aFileReference belowRoot: virtualRoot [

	aFileReference = virtualRoot rawEntity ifTrue: [ ^virtualRoot ].
	aFileReference = '.' asFileReference ifTrue: [ ^virtualRoot ].
	^virtualEntities keys
		detect: [ :virtualEntity | virtualEntity rawEntity = aFileReference ]
		ifNone: [ MiArchitecturalMapVirtualEntity new rawEntity: aFileReference ]
]
