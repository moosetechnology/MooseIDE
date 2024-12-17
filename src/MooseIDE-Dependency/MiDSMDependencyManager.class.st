"
I am an helper to manage dependencies for the DependencyStructuralMatrix browser
"
Class {
	#name : #MiDSMDependencyManager,
	#superclass : #Object,
	#instVars : [
		'dependencyDictionary',
		'miModel',
		'entities'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #'instance creation' }
MiDSMDependencyManager class >> on: aMiDSMModel [

	^self new
		miModel: aMiDSMModel ;
		yourself
]

{ #category : #enumerating }
MiDSMDependencyManager >> allDependencyPairsDo: aBlock [
	"Excute aBlock on all paira with non-empty dependencies
	 aBlock takes 3 arguments: fromEntity, toEntity, pairDependencies"

	dependencyDictionary keysAndValuesDo: [ :pair :pairDependencies |
		pairDependencies ifNotEmpty: [
			aBlock
				value: pair key
				value: pair value
				value: pairDependencies
		]
	]
]

{ #category : #enumerating }
MiDSMDependencyManager >> allPairsDo: aBlock [
	"Excute aBlock on all pairs
	 aBlock takes 3 arguments: fromEntity, toEntity, pairDependencies"

	dependencyDictionary keysAndValuesDo: [ :pair :pairDependencies |
		pairDependencies ifNotEmpty: [
			aBlock
				value: pair key
				value: pair value
				value: pairDependencies
		]
	]
]

{ #category : #initialization }
MiDSMDependencyManager >> computeDependencies: aCollection [
	"Could be optimized, when we open a detailed DSM, `miModel entities` is the union of entitiesX and entitiesY
	 But we only need dependencies from entitiesX to entitiesY, and not:
	 - from entitiesY to entitiesX
	 - from entitiesX to entitiesX
	 - from entitiesY to entitiesY"

	entities := aCollection select: [ :e | 
			 e usesFamixTrait: TEntityMetaLevelDependency ].

	dependencyDictionary := Dictionary new: entities size squared.

	entities do: [ :sourceEntity | 
		entities do: [ :targetEntity | 
			self
				dependencies: (self computeDependenciesFrom: sourceEntity to: targetEntity) 
				from: sourceEntity
				to: targetEntity
		]
	]
]

{ #category : #initialization }
MiDSMDependencyManager >> computeDependenciesFrom: entityX to: entityY [
	"generic algorithm to get all dependencies from entityX to entityY at the scope of entityY"

	^entityX queryAllOutgoingForDSM select: [ :dependency || opposites |
		dependency isAssociation ifTrue: [
			"Association so need to get the target because DSM is done between entities"
			opposites := dependency target.
			opposites isCollection
			ifTrue: [ opposites anySatisfy: [ :each | self entity: each belongsTo: entityY ]
			]
			ifFalse: [
				((opposites usesFamixTrait: FamixTParametricEntity) and:
				[ opposites genericization isNotNil ])
					ifTrue: [ opposites := opposites genericization genericEntity ].

				opposites 
					ifNotNil: [ self entity: opposites belongsTo: entityY ] 
					ifNil: [false]
			]
		]
		ifFalse: [ 
			"case of dependencies not coming from an association"
			dependency isStub
				ifTrue: [ false ]
				ifFalse: [ self entity: dependency belongsTo: entityY ]
		]
	]
]

{ #category : #accessing }
MiDSMDependencyManager >> dependencies: dependencies from: sourceEntity to: targetEntity [

	dependencyDictionary at: (sourceEntity -> targetEntity) put: dependencies
]

{ #category : #accessing }
MiDSMDependencyManager >> dependencyDictionary [

	^ dependencyDictionary
]

{ #category : #accessing }
MiDSMDependencyManager >> dependencyDictionary: anObject [

	dependencyDictionary := anObject
]

{ #category : #accessing }
MiDSMDependencyManager >> entities [

	^entities 
]

{ #category : #testing }
MiDSMDependencyManager >> entity: aCandidate belongsTo: anEntity [
	"test whether aDependentEntity can be scoped up to anEntity"

	^(aCandidate atScope: anEntity class) includes: anEntity
]

{ #category : #api }
MiDSMDependencyManager >> from: sourceEntity to: targetEntity [

	^dependencyDictionary at: (sourceEntity -> targetEntity) ifAbsent: [ ^#() ]
]

{ #category : #initialization }
MiDSMDependencyManager >> initialize [

	super initialize.

	"empty initialization just to get a working object
	 useful for tests"
	dependencyDictionary := Dictionary new
]

{ #category : #accessing }
MiDSMDependencyManager >> miModel [

	^ miModel
]

{ #category : #accessing }
MiDSMDependencyManager >> miModel: anObject [

	miModel := anObject
]

{ #category : #api }
MiDSMDependencyManager >> weightFrom: sourceEntity to: targetEntity [

	^(self from: sourceEntity to: targetEntity) size
]
