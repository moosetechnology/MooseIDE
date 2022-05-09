Class {
	#name : #MiDistributionMapModel,
	#superclass : #Object,
	#instVars : [
		'entities',
		'dynamicTags',
		'childrenBlock',
		'colorScale',
		'childrenQuery'
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

{ #category : #adding }
MiDistributionMapModel >> addDynamicTag: aTag [

	(dynamicTags includes: aTag) ifTrue: [ ^ self ].
	dynamicTags add: aTag
]

{ #category : #adding }
MiDistributionMapModel >> addDynamicTags: aCollection [

	dynamicTags addAll: aCollection
]

{ #category : #accessing }
MiDistributionMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiDistributionMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
MiDistributionMapModel >> childrenFor: anEntity [

	^ childrenQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiDistributionMapModel >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiDistributionMapModel >> childrenQuery: anObject [

	childrenQuery := anObject
]

{ #category : #querying }
MiDistributionMapModel >> colorFor: anEntity [
	
	| dt |
	dt :=  (self dynamicTagFor: anEntity).
	^ self colorForDynamicTag:  dt
]

{ #category : #querying }
MiDistributionMapModel >> colorForDynamicTag: aDynamicTag [

	self flag:
		'Model should have a color map and automatically handle colors.'.
	aDynamicTag color ifNotNil: [ :color | ^ color ].
	^ colorScale scale: aDynamicTag name
]

{ #category : #querying }
MiDistributionMapModel >> dynamicTagFor: anEntity [

	^ self dynamicTags
		  detect: [ :dt | dt isApplicableTo: anEntity ]
		  ifNone: [ MiNullDynamicTag new ]
]

{ #category : #accessing }
MiDistributionMapModel >> dynamicTags [

	^ dynamicTags
]

{ #category : #accessing }
MiDistributionMapModel >> dynamicTags: anObject [

	dynamicTags := anObject
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
MiDistributionMapModel >> indexOfDynamicTagFor: anEntity [

	dynamicTags doWithIndex: [ :dt :i | 
		(dt isApplicableTo: anEntity) ifTrue: [ ^ i ] ].
	^ 0
]

{ #category : #accessing }
MiDistributionMapModel >> initialize [

	super initialize.
	dynamicTags := OrderedCollection new.
	colorScale := RSQualitativeColorPalette new set312
]

{ #category : #querying }
MiDistributionMapModel >> numberOfchildrenWithProperty: aProp forNode: node [
	
	^ (childrenQuery runOn: node asMooseGroup) count: [ :child  |  aProp isApplicableTo: child]
]

{ #category : #querying }
MiDistributionMapModel >> orderOuterNodes: aCollectionOfNodes [ 
	| engine partVectors |
	aCollectionOfNodes ifEmpty: [^#()].

	partVectors :=  aCollectionOfNodes asOrderedCollection collect: [:node |
		MalSimilarityItem with: node
			andAll: (dynamicTags collect: [:aProp | self numberOfchildrenWithProperty: aProp forNode: node]) ].
	engine := MalClusterEngine with: partVectors.
	engine hierarchicalClusteringUsing: #completeLinkage.
	^ engine dendrogram orderLeafs collect: #item.
]
