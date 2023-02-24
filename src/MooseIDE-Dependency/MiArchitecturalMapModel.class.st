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
		'defaultChildrenQuery'
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

{ #category : #initialization }
MiArchitecturalMapModel >> allAssociationTypes [

	| mooseGroup |
	mooseGroup := entities asMooseGroup allUsing:
		              TEntityMetaLevelDependency.
	mooseGroup ifEmpty: [ ^ {  } ].
	^ (mooseGroup allEntityTypes flatCollectAsSet: [ :class | 
		   class allIncomingAssociationTypesIn: mooseGroup metamodel ])
		  asOrderedCollection
]

{ #category : #accessing }
MiArchitecturalMapModel >> associationTypes [

	^ settings getItemValue: #associationTypes
]

{ #category : #initialization }
MiArchitecturalMapModel >> associationTypesSetting [

	^ settings getItemValue: #associationTypes
]

{ #category : #accessing }
MiArchitecturalMapModel >> availableQueries [

	^ { self defaultChildrenQuery } , browser availableQueries
]

{ #category : #initialization }
MiArchitecturalMapModel >> browser: aBrowser [

	browser := aBrowser.
	self initializeSettings
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

	^ self childrenQuerySetting runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenQuerySetting [

	^ settings getItemValue: #childrenQuery
]

{ #category : #private }
MiArchitecturalMapModel >> colorFor: anEntity [

	^ Color gray
]

{ #category : #accessing }
MiArchitecturalMapModel >> defaultChildrenQuery [

	^ defaultChildrenQuery ifNil: [ 
		  defaultChildrenQuery := FQCollectScriptQuery script: [ :e | 
			                          e children ] ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities: anObject [

	entities := anObject.
	self updateSettings
]

{ #category : #initialization }
MiArchitecturalMapModel >> fetchTags [

	^ browser fetchTags
]

{ #category : #accessing }
MiArchitecturalMapModel >> initialize [

	super initialize
]

{ #category : #initialization }
MiArchitecturalMapModel >> initializeSettings [

	settings := super initializeSettings
						addItem: self itemShowBusEntities named: #showBusEntities;
						addItem: self itemChildrenQuery named: #childrenQuery;
						addItem: self itemTags named: #tags;
						addItem: self itemAssociationTypes named: #associationTypes;
		            yourself
]

{ #category : #initialization }
MiArchitecturalMapModel >> itemAssociationTypes [

	^ MiAbstractSettingItem buttonWithSelectableListSetting
		  possibleValues: self allAssociationTypes;
		  label: 'Links to show';
		  selectAll;
		  yourself
]

{ #category : #accessing }
MiArchitecturalMapModel >> itemChildrenQuery [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: self availableQueries;
		  setValue: self defaultChildrenQuery;
		  label: 'Children query';
		  help: 'The query giving all the children of any displayed entity';
		  yourself
]

{ #category : #accessing }
MiArchitecturalMapModel >> itemShowBusEntities [

	^ MiAbstractSettingItem checkboxSetting
		  setValue: true;
		  label: 'Show bus entities?';
		  help:
			  'If not checked, this will ignore entities in bus. Usefull when tags are added in the visualization.';
		  yourself
]

{ #category : #initialization }
MiArchitecturalMapModel >> itemTags [

	^ MiAbstractSettingItem buttonWithEditableListSetting
		  possibleValues: self fetchTags;
		  displayIcon: [ :tag | MiTagBrowserModel iconForTag: tag ];
		  display: [ :tag | tag name ];
		  label: 'Tags to add';
		  help: 'The tags you want to add to the visualization. They will be entities and inner elements are tagged entities';
		  yourself
]

{ #category : #keymaps }
MiArchitecturalMapModel >> openSettings [

	settings open
]

{ #category : #'accessing - tests' }
MiArchitecturalMapModel >> settings [
	^settings
]

{ #category : #initialization }
MiArchitecturalMapModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser run ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> showAllLinks [

	^ true
]

{ #category : #accessing }
MiArchitecturalMapModel >> showBusEntities [

	^ settings getItemValue: #showBusEntities
]

{ #category : #accessing }
MiArchitecturalMapModel >> tags [

	^ settings getItemValue: #tags
]

{ #category : #initialization }
MiArchitecturalMapModel >> toolName [

	^ browser title
]

{ #category : #updating }
MiArchitecturalMapModel >> updateSettings [

	(settings itemNamed: #associationTypes) possibleValues:
		self allAssociationTypes
]
