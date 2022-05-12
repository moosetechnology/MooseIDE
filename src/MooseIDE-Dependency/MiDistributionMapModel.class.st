Class {
	#name : #MiDistributionMapModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'entities',
		'settings'
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

{ #category : #'accessing - tests' }
MiDistributionMapModel >> browser [

	^ browser
]

{ #category : #accessing }
MiDistributionMapModel >> browser: anObject [

	browser := anObject
]

{ #category : #accessing }
MiDistributionMapModel >> childrenFor: anEntity [

	^ self childrenQuerySetting runOn: anEntity asMooseGroup
]

{ #category : #settings }
MiDistributionMapModel >> childrenQuerySetting [
	^settings getItemValue: #childrenQuery
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
	^self colorForNoTagSetting
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

	^ (browser application itemsFor: FamixTag) asOrderedCollection 
		  sorted: [ :t1 :t2 | t1 name < t2 name ]
]

{ #category : #accessing }
MiDistributionMapModel >> indexOfTagFor: anEntity [

	self tagsSetting doWithIndex: [ :dt :i | 
		(dt isApplicableTo: anEntity) ifTrue: [ ^ i ] ].
	^ 0
]

{ #category : #initialization }
MiDistributionMapModel >> initialize [

	super initialize.
	self initializeSettings 

]

{ #category : #initialization }
MiDistributionMapModel >> initializeSettings [ 
	settings := MiSettingsPresenter new
		"addItem: self itemChildrenBlock 		named: #childrenBlock ;"
		addItem: self itemColorForNoTag	named: #colorForNoTag ;
		addItem: self itemChildrenQuery 	named: #childrenQuery ;
		addItem: self itemTags 				named: #tags ;
		yourself.
]

{ #category : #settings }
MiDistributionMapModel >> itemChildrenQuery [
	^MiAbstractSettingItem droplistSetting
		label: 'Children query' ;
		help: 'The query giving all the children of any displayed entity' ;
		yourself
]

{ #category : #settings }
MiDistributionMapModel >> itemColorForNoTag [

	| colors |
	colors := {Color black} , RSQualitativeColorPalette new set312 range.

	^ MiAbstractSettingItem droplistSetting
		  displayBlock: [ :color :listItem | 
			  listItem icon: (Morph new
						   color: color;
						   asFormOfSize: 20 @ 20).
			  color asHexString ];
		  possibleValues: colors;
		  setValue: colors anyOne;
		  label: 'Color for entities without property';
		  help:
		  'Color to use when none of the properties apply to an entity';
		  yourself
]

{ #category : #settings }
MiDistributionMapModel >> itemTags [
	^MiAbstractSettingItem buttonWithEditableListSetting
		label: 'Tags' ;
		help: 'The tags used as properties to display.
If an entity has several tags, it will get the color of the first of its tags appearing in the list' ;
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
	aCollectionOfNodes ifEmpty: [^#()].

	partVectors :=  aCollectionOfNodes asOrderedCollection collect: [:node |
		MalSimilarityItem with: node
			andAll: (self tagsSetting collect: [:aProp | self numberOfchildrenWithProperty: aProp forNode: node]) ].
	engine := MalClusterEngine with: partVectors.
	engine hierarchicalClusteringUsing: #completeLinkage.
	^ engine dendrogram orderLeafs collect: #item.
]

{ #category : #settings }
MiDistributionMapModel >> resetChildrenQuerySetting [
	| settingQueries environmentQueries currentSelected |

	settingQueries := (settings itemNamed: #childrenQuery) possibleValues.
	environmentQueries := self fetchChildrenQueries.

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

	(settings itemNamed: #tags) setValue: environmentTags.

]

{ #category : #settings }
MiDistributionMapModel >> settings [

	self resetChildrenQuerySetting.
	self resetTagSetting.
	^ settings
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
