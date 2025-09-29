"
I am an helper to manage dependencies for the DependencyStructuralMatrix browser
"
Class {
	#name : #MiDSMDependencyManager,
	#superclass : #Object,
	#instVars : [
		'dependencyDictionary',
		'miModel',
		'entitiesX',
		'entitiesY'
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

{ #category : #testing }
MiDSMDependencyManager >> association: associations isTo: entity [
	"need to get the target because DSM is done between entities"

	| target |

	target := associations target.
	^target isCollection
		ifTrue: [
			"the association is an Invocation and the target-s are the candidates"
			target anySatisfy: [ :each | self entity: each belongsTo: entity ]
		]
		ifFalse: [
			((target usesFamixTrait: FamixTParametricEntity) and:
			[ target genericization isNotNil ])
				ifTrue: [ target := target genericization genericEntity ].

			target 
				ifNotNil: [ self entity: target belongsTo: entity ] 
				ifNil: [false]
		]
		
]

{ #category : #initialization }
MiDSMDependencyManager >> computeDependenciesFrom: entityX to: entityY [
	"generic algorithm to get all dependencies from entityX to entityY at the scope of entityY"

	^entityX queryAllOutgoingForDSM select: [ :dependency |
		entityY isPackage
			ifFalse: [ self dependency: dependency isTo: entityY ]
			ifTrue: [ self dependency: dependency isToPackage: entityY ]
	].

]

{ #category : #initialization }
MiDSMDependencyManager >> computeDependenciesWithX: aCollectionX withY: aCollectionY [
	"Could be optimized, when we open a detailed DSM, `miModel entities` is the union of entitiesX and entitiesY
	 But we only need dependencies from entitiesX to entitiesY, and not:
	 - from entitiesY to entitiesX
	 - from entitiesX to entitiesX
	 - from entitiesY to entitiesY"

	entitiesX := aCollectionX select: [ :e | 
			 e usesFamixTrait: TEntityMetaLevelDependency ].
	entitiesY := aCollectionY select: [ :e | 
			 e usesFamixTrait: TEntityMetaLevelDependency ].

	dependencyDictionary := Dictionary new: entitiesX size * entitiesY size .

	entitiesX do: [ :sourceEntity | 
		entitiesY do: [ :targetEntity | 
			self
				recordDependencies: (self computeDependenciesFrom: sourceEntity to: targetEntity) 
				from: sourceEntity
				to: targetEntity
		]
	]
]

{ #category : #testing }
MiDSMDependencyManager >> dependency: dependency isTo: entity [

	^dependency isAssociation ifTrue: [ self association: dependency isTo: entity ]
		ifFalse: [ 
			"case of dependencies not coming from an association"
			dependency isStub
				ifTrue: [ false ]
				ifFalse: [ self entity: dependency belongsTo: entity ]
		]

]

{ #category : #testing }
MiDSMDependencyManager >> dependency: dependency isToPackage: aPackage [
	"dependencies to sub-packages are added to their parent package"

	^(self dependency: dependency isTo: aPackage)
		or: [
			aPackage children anySatisfy: [ :child |
				child isPackage and:
				[ self dependency: dependency isToPackage: child ]
		]
	]
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

	^(entitiesX union: entitiesY)
]

{ #category : #accessing }
MiDSMDependencyManager >> entitiesX [

	^entitiesX 
]

{ #category : #accessing }
MiDSMDependencyManager >> entitiesY [

	^entitiesY 
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

{ #category : #accessing }
MiDSMDependencyManager >> recordDependencies: dependencies from: sourceEntity to: targetEntity [

	dependencyDictionary at: (sourceEntity -> targetEntity) put: dependencies
]

{ #category : #api }
MiDSMDependencyManager >> weightFrom: sourceEntity to: targetEntity [

	^(self from: sourceEntity to: targetEntity) size
]
