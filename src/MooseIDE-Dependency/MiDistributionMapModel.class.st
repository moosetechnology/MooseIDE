"
I am the model of the distribution map. I am responsible for tag managment, data storage and element sorting.
"
Class {
	#name : #MiDistributionMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'baseColor',
		'childrenQuery',
		'tags'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #accessing }
MiDistributionMapModel class >> defaultBaseColor [

	^ Color gray
]

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

	^ self currentApplication availableQueries
		  addFirst: self currentApplication childrenQuery;
		  yourself
]

{ #category : #accessing }
MiDistributionMapModel >> childrenFor: anEntity [

	| groups dts children |
	children := childrenQuery runOn: anEntity asMooseGroup.
	dts := tags.
	groups := OrderedCollection new.
	dts size + 1 timesRepeat: [ groups add: OrderedCollection new ].
	children do: [ :child |
		(groups at: 1 + (self indexOfTagFor: child)) add: child ].
	^ groups flatCollect: [ :child | child ] as: OrderedCollection
]

{ #category : #utilities }
MiDistributionMapModel >> collection: collection1 hasSameElementHas: collection2 [
	^((collection1 size = collection2 size)
	and: [ collection1 allSatisfy: [ :each | collection2 includes: each ] ])
]

{ #category : #querying }
MiDistributionMapModel >> colorFor: anEntity [

	^ self colorForTag: (self tagFor: anEntity)
]

{ #category : #querying }
MiDistributionMapModel >> colorForTag: aTag [

	^ aTag color ifNil: [ baseColor ]
]

{ #category : #'settings management' }
MiDistributionMapModel >> currentConfiguration [

	^ MiDistributionMapSettingsConfiguration new
		  baseColor: baseColor;
		  availableTags: self fetchTags;
		  tags: tags;
		  childrenQuery: childrenQuery;
		  yourself
]

{ #category : #'settings management' }
MiDistributionMapModel >> defaultConfiguration [

	^ MiDistributionMapSettingsConfiguration new
		  baseColor: self class defaultBaseColor;
		  availableTags: self fetchTags;
		  tags: self fetchTags;
		  childrenQuery: self defaultChildrenQuery;
		  yourself
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
	"If we ask the application, then we need the tag browser opened. So we asume a browser is opened on the entities of only one model and we ask the tags in the models of a random moose entity of the browser."

	entities isEmptyOrNil ifFalse: [
			^ entities anyOne mooseModel allTags asOrderedCollection sorted:
				  #name ascending ].

	^ #(  )
]

{ #category : #testing }
MiDistributionMapModel >> hasSettings [

	^ true
]

{ #category : #accessing }
MiDistributionMapModel >> indexOfTagFor: anEntity [

	tags doWithIndex: [ :dt :i |
		(dt isApplicableTo: anEntity) ifTrue: [ ^ i ] ].

	^ 0
]

{ #category : #initialization }
MiDistributionMapModel >> initializeSettings [

	baseColor := self class defaultBaseColor.
	childrenQuery := self defaultChildrenQuery.
	tags := self fetchTags
]

{ #category : #querying }
MiDistributionMapModel >> numberOfchildrenWithProperty: aProp forNode: node [

	^ (childrenQuery runOn: node asMooseGroup) count: [ :child |
		  aProp isApplicableTo: child ]
]

{ #category : #querying }
MiDistributionMapModel >> orderOuterNodes: aCollectionOfNodes [

	| engine partVectors |
	aCollectionOfNodes ifEmpty: [ ^ #(  ) ].

	partVectors := aCollectionOfNodes
		               collect: [ :node |
				               AISimilarityItem
					               with: node
					               andAll: (tags collect: [ :aProp |
							                self
								                numberOfchildrenWithProperty: aProp
								                forNode: node ]) ]
		               as: Array.

	engine := AISeriationEngine with: partVectors.

	^ engine orderDendrogramLeaves collect: #item
]

{ #category : #querying }
MiDistributionMapModel >> tagFor: anEntity [

	^ tags
		  detect: [ :dynamicTag | dynamicTag isApplicableTo: anEntity ]
		  ifNone: [ MiNullDynamicTag new ]
]

{ #category : #enumerating }
MiDistributionMapModel >> tagsDo: aBlock [
	"This method avoids breaking encapsulation"

	tags do: aBlock
]

{ #category : #accessing }
MiDistributionMapModel >> tooManyEntities [
	"some random value above which computing the DistributionMap takes too long.
	Not very brilliant, but solves https://github.com/moosetechnology/MooseIDE/issues/955"

	^100
]

{ #category : #'settings management' }
MiDistributionMapModel >> updateFromConfiguration: aConfiguration [

	baseColor := aConfiguration baseColor.
	tags := aConfiguration tags.
	childrenQuery := aConfiguration childrenQuery.

	browser runVisualization
]
