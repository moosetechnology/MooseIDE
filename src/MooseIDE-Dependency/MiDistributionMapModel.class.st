"
I am the model of the distribution map. I am responsible for tag managment, data storage and element sorting.
"
Class {
	#name : #MiDistributionMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'settings',
		'defaultChildrenQuery'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #'as yet unclassified' }
MiDistributionMapModel class >> defaultDynamicTagIsDead [

	^ MiDynamicTag new
		  color: Color black ;
		  name: 'Is dead' ;
		  query: [ :e | e isDead ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiDistributionMapModel class >> defaultDynamicTagIsStub [

	^ MiDynamicTag new
		  color: Color yellow ;
		  name: 'Is stub' ;
		  query: [ :e | e isStub ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiDistributionMapModel class >> defaultDynamicTags [

	^ { 
		  self defaultDynamicTagIsStub .
		  self defaultDynamicTagIsDead }
]

{ #category : #settings }
MiDistributionMapModel >> availableQueries [

	^ { self defaultChildrenQuery } , browser availableQueries
]

{ #category : #'accessing - tests' }
MiDistributionMapModel >> browser [

	^ browser
]

{ #category : #accessing }
MiDistributionMapModel >> browser: anObject [

	browser := anObject.

	self initializeSettings
]

{ #category : #accessing }
MiDistributionMapModel >> childrenFor: anEntity [

	| groups dts children |
	children := self childrenQuerySetting runOn: anEntity asMooseGroup.
	dts := self tagsSetting.
	groups := OrderedCollection new.
	dts size + 1 timesRepeat: [ groups add: OrderedCollection new ].
	children do: [ :child | 
		(groups at: 1 + (self indexOfTagFor: child)) add: child ].
	^ groups flatCollect: [ :child | child ] as: OrderedCollection
]

{ #category : #settings }
MiDistributionMapModel >> childrenQuerySetting [

	^ settings getItemValue: #childrenQuery
]

{ #category : #utilities }
MiDistributionMapModel >> collection: collection1 hasSameElementHas: collection2 [
	^((collection1 size = collection2 size)
	and: [ collection1 allSatisfy: [ :each | collection2 includes: each ] ])
]

{ #category : #querying }
MiDistributionMapModel >> colorFor: anEntity [
	
	| dt |
	dt :=  (self tagFor: anEntity).
	^ self colorForTag:  dt
]

{ #category : #settings }
MiDistributionMapModel >> colorForNoTagSetting [
	^settings getItemValue: #colorForNoTag
]

{ #category : #querying }
MiDistributionMapModel >> colorForTag: aTag [

	aTag color ifNotNil: [ :color | ^ color ].

	^ self colorForNoTagSetting
]

{ #category : #accessing }
MiDistributionMapModel >> defaultChildrenQuery [

	^ defaultChildrenQuery ifNil: [ 
		  defaultChildrenQuery := FQCollectScriptQuery script: [ :entity | 
			                          entity children ] ]
]

{ #category : #accessing }
MiDistributionMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiDistributionMapModel >> entities: anObject [

	entities := anObject
]

{ #category : #accessing }
MiDistributionMapModel >> fetchChildrenQueries [

	^(browser application itemsFor: FQAbstractQuery)
		  asOrderedCollection select: [ :query | query isValid ]
]

{ #category : #accessing }
MiDistributionMapModel >> fetchTags [

	^ ((browser application itemsFor: MiDynamicTag)
	   , (browser application itemsFor: FamixTag)) asOrderedCollection 
		  sorted: [ :t1 :t2 | t1 name < t2 name ]
]

{ #category : #accessing }
MiDistributionMapModel >> indexOfTagFor: anEntity [

	self tagsSetting doWithIndex: [ :dt :i | 
		(dt isApplicableTo: anEntity) ifTrue: [ ^ i ] ].
	^ 0
]

{ #category : #initialization }
MiDistributionMapModel >> initializeSettings [

	settings := super initializeSettings
		            "addItem: self itemChildrenBlock 		named: #childrenBlock ;"
		            addItem: self itemColorForNoTag
		            named: #colorForNoTag;
		            addItem: self itemChildrenQuery named: #childrenQuery;
		            addItem: self itemTags named: #tags;
		            yourself
]

{ #category : #settings }
MiDistributionMapModel >> itemChildrenQuery [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: self availableQueries;
		  setValue: self defaultChildrenQuery;
		  label: 'Children query';
		  help: 'The query giving all the children of any displayed entity';
		  yourself
]

{ #category : #settings }
MiDistributionMapModel >> itemColorForNoTag [

	^ MiAbstractSettingItem colorSetting
		  setValue: Color gray;
		  label: 'Color for entities without property';
		  help:
			  'Color to use when none of the properties apply to an entity';
		  yourself
]

{ #category : #settings }
MiDistributionMapModel >> itemTags [

	^ MiAbstractSettingItem buttonWithEditableListSetting
		  possibleValues: self fetchTags;
		  displayIcon: [ :tag | MiTagBrowserModel iconForTag: tag ];
		  display: [ :tag | tag name ];
		  label: 'Tags';
		  help: 'The tags used as properties to display.
If an entity has several tags, it will get the color of the first of its tags appearing in the list';
		  yourself
]

{ #category : #querying }
MiDistributionMapModel >> numberOfchildrenWithProperty: aProp forNode: node [
	
	^(self childrenQuerySetting runOn: node asMooseGroup)
	count: [ :child  |  aProp isApplicableTo: child]
]

{ #category : #querying }
MiDistributionMapModel >> orderOuterNodes: aCollectionOfNodes [

	| engine partVectors |
	aCollectionOfNodes ifEmpty: [ ^ #(  ) ].

	partVectors := aCollectionOfNodes collect: [ 
		               :node | 
		               AISimilarityItem
			               with: node
			               andAll: (self tagsSetting collect: [ :aProp | 
					                self
						                numberOfchildrenWithProperty: aProp
						                forNode: node ]) ] as: Array.
	engine := AIClusterEngine with: partVectors.
	engine hierarchicalClusteringUsing: #completeLinkage.
	^ engine dendrogram orderLeafs collect: #item
]

{ #category : #settings }
MiDistributionMapModel >> resetChildrenQuerySetting [
	| settingQueries environmentQueries currentSelected |

	settingQueries := (settings itemNamed: #childrenQuery) possibleValues.
	environmentQueries := self availableQueries.

	(self collection: environmentQueries hasSameElementHas: settingQueries)
	ifTrue: [ ^self ].

	currentSelected := self childrenQuerySetting.

	(settings itemNamed: #childrenQuery) possibleValues: environmentQueries.

	(environmentQueries includes: currentSelected)
	ifTrue: [ settings setItem: #childrenQuery value: currentSelected ]
	ifFalse: [ settings setItem: #childrenQuery value: environmentQueries anyOne ]

]

{ #category : #settings }
MiDistributionMapModel >> resetTagSetting [

	| settingTags environmentTags |
	settingTags := (settings itemNamed: #tags) getValue.
	environmentTags := self fetchTags.

	(self collection: environmentTags hasSameElementHas: settingTags) 
		ifTrue: [ ^ self ].

	(settings itemNamed: #tags) possibleValues: environmentTags.

]

{ #category : #settings }
MiDistributionMapModel >> settings [

	self resetChildrenQuerySetting.
	self resetTagSetting.
	^ settings
]

{ #category : #accessing }
MiDistributionMapModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser runVisualization ]
]

{ #category : #querying }
MiDistributionMapModel >> tagFor: anEntity [

	^ self tagsSetting
		  detect: [ :dt | dt isApplicableTo: anEntity ]
		  ifNone: [ MiNullDynamicTag new ]
]

{ #category : #settings }
MiDistributionMapModel >> tagsSetting [
	^settings getItemValue: #tags
]
