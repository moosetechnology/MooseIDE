"
I am a model of a hierarchical map.
I am responsible for:
- holding a property list
- holding elements to display on the hierarchical map.
"
Class {
	#name : #MiHierarchicalMapModel,
	#superclass : #Object,
	#instVars : [
		'entities',
		'dynamicTags',
		'childrenBlock',
		'colorScale',
		'childrenQuery',
		'showAllLinks',
		'associationTypes',
		'tags',
		'colorPalette',
		'assocTypeToColorDict'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel class >> defaultDynamicTagIsDead [

	^ MiDynamicTag new
		  color: Color black ;
		  name: 'Is dead' ;
		  query: [ :e | e isDead ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel class >> defaultDynamicTagIsStub [

	^ MiDynamicTag new
		  color: Color yellow ;
		  name: 'Is stub' ;
		  query: [ :e | e isStub ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel class >> defaultDynamicTags [

	^ { 
		  self defaultDynamicTagIsStub .
		  self defaultDynamicTagIsDead }
]

{ #category : #adding }
MiHierarchicalMapModel >> addDynamicTag: aTag [

	(dynamicTags includes: aTag) ifTrue: [ ^ self ].
	dynamicTags add: aTag
]

{ #category : #adding }
MiHierarchicalMapModel >> addDynamicTags: aCollection [

	dynamicTags addAll: aCollection
]

{ #category : #accessing }
MiHierarchicalMapModel >> assocTypeToColorDict [

	^ assocTypeToColorDict
]

{ #category : #accessing }
MiHierarchicalMapModel >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiHierarchicalMapModel >> associationTypes: aCollection [

	
	associationTypes := aCollection.
	assocTypeToColorDict := Dictionary new.
	aCollection doWithIndex: [ :type :i | 
		i <= colorPalette size
			ifTrue: [ assocTypeToColorDict at: type put: (colorPalette at: i) ]
			ifFalse: [ assocTypeToColorDict at: type put: Color random ] ]
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenFor: anEntity [

	^ childrenQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenQuery: anObject [

	childrenQuery := anObject
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> colorFor: anEntity [
	
	| dt |
	dt :=  (self dynamicTagFor: anEntity).
	^ self colorForDynamicTag:  dt
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> colorForDynamicTag: aDynamicTag [

	self flag:
		'Model should have a color map and automatically handle colors.'.
	aDynamicTag color ifNotNil: [ :color | ^ color ].
	^ colorScale scale: aDynamicTag name
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> dynamicTagFor: anEntity [

	^ self dynamicTags
		  detect: [ :dt | dt isApplicableTo: anEntity ]
		  ifNone: [ MiNullDynamicTag new ]
]

{ #category : #accessing }
MiHierarchicalMapModel >> dynamicTags [

	^ dynamicTags
]

{ #category : #accessing }
MiHierarchicalMapModel >> dynamicTags: anObject [

	dynamicTags := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiHierarchicalMapModel >> entities: anObject [

	entities := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> indexOfDynamicTagFor: anEntity [

	dynamicTags doWithIndex: [ :dt :i | 
		(dt isApplicableTo: anEntity) ifTrue: [ ^ i ] ].
	^ 0
]

{ #category : #accessing }
MiHierarchicalMapModel >> initialize [

	super initialize.
	showAllLinks := false.
	colorPalette := (RSQualitativeColorPalette new paired12) range asOrderedCollection.
	associationTypes := OrderedCollection new.
	tags := OrderedCollection new.
	dynamicTags := OrderedCollection new.
	colorScale := RSQualitativeColorPalette new set312
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> numberOfchildrenWithProperty: aProp forNode: node [
	
	^ (childrenQuery runOn: node asMooseGroup) count: [ :child  |  aProp isApplicableTo: child]
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> orderOuterNodes: aCollectionOfNodes [ 
	| engine partVectors |
	aCollectionOfNodes ifEmpty: [^#()].

	partVectors :=  aCollectionOfNodes asOrderedCollection collect: [:node |
		MalSimilarityItem with: node
			andAll: (dynamicTags collect: [:aProp | self numberOfchildrenWithProperty: aProp forNode: node]) ].
	engine := MalClusterEngine with: partVectors.
	engine hierarchicalClusteringUsing: #completeLinkage.
	^ engine dendrogram orderLeafs collect: #item.
]

{ #category : #accessing }
MiHierarchicalMapModel >> showAllLinks [

	^ showAllLinks
]

{ #category : #accessing }
MiHierarchicalMapModel >> showAllLinks: anObject [

	showAllLinks := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> tags [

	^ tags
]

{ #category : #accessing }
MiHierarchicalMapModel >> tags: anObject [

	tags := anObject
]
