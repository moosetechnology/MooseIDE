"
A MooseIDE tool that focuses on dependencies between two sets of entities.
Can be used to show the API of used entities (on the right) that is required from using entities (on the left).
API usage focuses on method invocations.
The tool assumes that the two entity sets (users and used) are mutually exclusive

There are 6 columns:
- packages of using entities
- classes of using entities
- methods that are using the entities on the right
- methods used
- classes that are used
- packages that are used

In the settings, one can sets the name of the packages that are using or used entities.
Only entities with fully qualified name prefixed by these package names are shown.
Only entities that are invoved in an invocation from using packages to used packages are shown
"
Class {
	#name : 'MiAPIMapModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'mooseModel',
		'layers',
		'allInvocations',
		'accessedPrefix',
		'clientPrefix'
	],
	#category : 'MooseIDE-API-Browser-browser',
	#package : 'MooseIDE-API-Browser',
	#tag : 'browser'
}

{ #category : 'settings management' }
MiAPIMapModel class >> defaultAccessedPrefix [

	^'fr.inria...'
]

{ #category : 'settings management' }
MiAPIMapModel class >> defaultClientPrefix [

	^'fr.inria...'
]

{ #category : 'settings management' }
MiAPIMapModel class >> defaultConfiguration [

	^ MiAPIBrowserSettingsConfiguration new
		  accessedPrefix: self defaultAccessedPrefix ;
		  clientPrefix: self defaultClientPrefix ;
		  yourself
]

{ #category : 'accessing' }
MiAPIMapModel >> accessedPrefix [

	^accessedPrefix
]

{ #category : 'accessing' }
MiAPIMapModel >> accessedPrefix: aString [

	accessedPrefix := aString
]

{ #category : 'accessing' }
MiAPIMapModel >> allInvocations [

	allInvocations ifNotNil: [ ^allInvocations ].
	mooseModel ifNil: [ #() ].

	^allInvocations := mooseModel allInvocations select: [ :i |
		(self isClientEntity: i sender) and:
		[ self isAccessedEntity: i candidates anyOne ] ]

]

{ #category : 'dependencies' }
MiAPIMapModel >> calledMethods: anEntity [

	^self tgtMethodLayer select: [ :m |
		m incomingInvocations anySatisfy: [ :invok | invok source = anEntity ]
	]
]

{ #category : 'dependencies' }
MiAPIMapModel >> callingMethods: anEntity [

	^self srcMethodLayer select: [ :m |
		anEntity incomingInvocations anySatisfy: [ :invok | invok source = m ]
	]
]

{ #category : 'dependencies' }
MiAPIMapModel >> classDependents: anEntity [

	| methods |
	methods := self classMethods: anEntity.
	methods copy do: [ :m | methods addAll: (self pairedMethods: m) ].

	^methods 
]

{ #category : 'dependencies' }
MiAPIMapModel >> classMethods: anEntity [

	^(self srcMethodLayer select: [ :m | m parentType = anEntity ]) asSet ,
	(self tgtMethodLayer select: [ :m | m parentType = anEntity ])
	
]

{ #category : 'dependencies' }
MiAPIMapModel >> classParents: anEntity [

	^{anEntity . anEntity typeContainer}
]

{ #category : 'accessing' }
MiAPIMapModel >> clientPrefix [

	^clientPrefix
]

{ #category : 'accessing' }
MiAPIMapModel >> clientPrefix: aString [

	clientPrefix := aString
]

{ #category : 'settings management' }
MiAPIMapModel >> currentConfiguration [

	^ MiAPIBrowserSettingsConfiguration new
		  accessedPrefix: self accessedPrefix ;
		  clientPrefix: self clientPrefix ;
		  yourself
]

{ #category : 'settings management' }
MiAPIMapModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'accessing' }
MiAPIMapModel >> entities [

	^layers
		ifNil: [ #() ]
		ifNotNil: [layers flatten]
]

{ #category : 'highlighting' }
MiAPIMapModel >> entitiesHighlightList: anEntity [

	(self srcPackageLayer includes: anEntity) ifTrue: [ ^self srcPackageHighlightList: anEntity ].
	(self srcClassLayer   includes: anEntity) ifTrue: [ ^self srcClassHighlightList:   anEntity ].
	(self srcMethodLayer  includes: anEntity) ifTrue: [ ^self srcMethodHighlightList:  anEntity ].
	(self tgtMethodLayer  includes: anEntity) ifTrue: [ ^self tgtMethodHighlightList:  anEntity ].
	(self tgtClassLayer   includes: anEntity) ifTrue: [ ^self tgtClassHighlightList:   anEntity ].
	(self tgtPackageLayer includes: anEntity) ifTrue: [ ^self tgtPackageHighlightList: anEntity ].

	^#()
]

{ #category : 'testing' }
MiAPIMapModel >> hasSettings [

	^ true
]

{ #category : 'highlighting' }
MiAPIMapModel >> highlightList: anEntity [

	| entities |
	entities := self entitiesHighlightList: anEntity.
	entities addAll: (self linksBetween: entities).

	^entities
]

{ #category : 'initialization' }
MiAPIMapModel >> initialize [

	super initialize.

	self initializeSettings
]

{ #category : 'running' }
MiAPIMapModel >> initializeLayers [

	layers := { 1 . 2 . 3 . 4 . 5 . 6 }.

	layers at: 3 put: (self allInvocations collectAsSet: #source).
	layers at: 2 put: (self srcMethodLayer collectAsSet: #parentType).
	layers at: 1 put: (self srcClassLayer collectAsSet: #typeContainer).

	layers at: 4 put: (self allInvocations collectAsSet: [:invok | invok target anyOne]).
	layers at: 5 put: (self tgtMethodLayer collectAsSet: #parentType).
	layers at: 6 put: (self tgtClassLayer collectAsSet: #typeContainer).

]

{ #category : 'initialization' }
MiAPIMapModel >> initializeSettings [

	self updateFromConfiguration: self defaultConfiguration.
]

{ #category : 'dependencies' }
MiAPIMapModel >> invocationsBetween: entities [

	^(self allInvocations
		select: [ :invok |
			(entities includes: invok source) and:
			[ entities includes: invok target anyOne ]
		])
		collect: [ :invok |
			invok source -> invok target anyOne
		]
]

{ #category : 'accessing' }
MiAPIMapModel >> isAccessedEntity: anEntity [

	^anEntity mooseName beginsWith: self accessedPrefix 

]

{ #category : 'accessing' }
MiAPIMapModel >> isClientEntity: anEntity [

	^anEntity mooseName beginsWith: self clientPrefix

]

{ #category : 'accessing' }
MiAPIMapModel >> layers [

	^ layers
]

{ #category : 'accessing' }
MiAPIMapModel >> layers: anObject [

	layers := anObject
]

{ #category : 'dependencies' }
MiAPIMapModel >> linksBetween: entities [

	^(self invocationsBetween: entities) , (self ownershipBetween: entities)
]

{ #category : 'dependencies' }
MiAPIMapModel >> methodParents: anEntity [

	^{anEntity . anEntity parentType . anEntity parentType typeContainer}
]

{ #category : 'dependencies' }
MiAPIMapModel >> methodRelatedEntities: anEntity [

	^{ anEntity parentType } , (self pairedMethods: anEntity) asOrderedCollection 
]

{ #category : 'accessing' }
MiAPIMapModel >> mooseModel [

	^ mooseModel
]

{ #category : 'accessing' }
MiAPIMapModel >> mooseModel: anObject [

	mooseModel := anObject.
	"self runVisualization" 
]

{ #category : 'dependencies' }
MiAPIMapModel >> ownershipBetween: entities [

	^ entities
		  collect: [ :child |
				  | childParents |
				  childParents := child containers.
				  entities
					  detect: [ :parent |
						  child class ~= parent class and: [
							  childParents includes: parent ] ]
					  ifOne: [ :parent | parent -> child ]
					  ifNone: [ nil ] ]
		  thenReject: #isNil
]

{ #category : 'dependencies' }
MiAPIMapModel >> packageClasses: anEntity [

	^(self srcClassLayer select: [ :m | m typeContainer = anEntity ]) asSet ,
	(self tgtClassLayer select: [ :m | m typeContainer = anEntity ])
]

{ #category : 'dependencies' }
MiAPIMapModel >> pairedMethods: anEntity [

	^(self srcMethodLayer includes: anEntity)
		ifTrue: [ self calledMethods: anEntity ]
		ifFalse: [ self callingMethods: anEntity ]
]

{ #category : 'dependencies' }
MiAPIMapModel >> relatedEntities: anEntity [
	"only needs to return the 'depending' entities"

	(self srcClassLayer   includes: anEntity) ifTrue: [ ^{anEntity typeContainer} ].
	(self srcMethodLayer  includes: anEntity) ifTrue: [ ^{anEntity parentType} ].
	(self tgtMethodLayer  includes: anEntity) ifTrue: [ ^{anEntity parentType} , (self pairedMethods: anEntity) asOrderedCollection ].
	(self tgtClassLayer   includes: anEntity) ifTrue: [ ^{anEntity typeContainer} ].

	^#()
]

{ #category : 'running' }
MiAPIMapModel >> runVisualization [

	mooseModel ifNil: [ ^self ].
	allInvocations := nil.
	mooseModel entities do: [ :fmx | fmx removeCache: #p16APIHNode ].
	self initializeLayers.
	^ browser runVisualization
]

{ #category : 'interactions' }
MiAPIMapModel >> selectRelatedTo: anEntity [
	"Add to currently selected shapes all shapes related to anEntity"

	browser addToSelection:	((self highlightList: anEntity) reject: #isAssociation).

]

{ #category : 'highlighting' }
MiAPIMapModel >> srcClassHighlightList: anEntity [

	^(self classParents: anEntity) asSet ,
	 ((self classDependents: anEntity) flatCollect: [:m | self methodParents: m])
]

{ #category : 'accessing' }
MiAPIMapModel >> srcClassLayer [

	^layers second
]

{ #category : 'highlighting' }
MiAPIMapModel >> srcMethodHighlightList: anEntity [

	^(self methodParents: anEntity) asSet ,
	 ((self calledMethods: anEntity) flatCollect: [:m | self methodParents: m])
]

{ #category : 'accessing' }
MiAPIMapModel >> srcMethodLayer [

	^layers third
]

{ #category : 'highlighting' }
MiAPIMapModel >> srcPackageHighlightList: anEntity [

	^(Set with: anEntity),
	 ((self packageClasses: anEntity) flatCollect: [:c | self srcClassHighlightList: c])
]

{ #category : 'accessing' }
MiAPIMapModel >> srcPackageLayer [

	^layers first
]

{ #category : 'highlighting' }
MiAPIMapModel >> tgtClassHighlightList: anEntity [

	^(self classParents: anEntity) asSet ,
	 ((self classDependents: anEntity) flatCollect: [:m | self methodParents: m])
]

{ #category : 'accessing' }
MiAPIMapModel >> tgtClassLayer [

	^layers fifth
]

{ #category : 'highlighting' }
MiAPIMapModel >> tgtMethodHighlightList: anEntity [

	^(self methodParents: anEntity) asSet ,
	 ((self callingMethods: anEntity) flatCollect: [:m | self methodParents: m])
]

{ #category : 'accessing' }
MiAPIMapModel >> tgtMethodLayer [

	^layers fourth
]

{ #category : 'highlighting' }
MiAPIMapModel >> tgtPackageHighlightList: anEntity [

	^(Set with: anEntity),
	 ((self packageClasses: anEntity) flatCollect: [:c | self srcClassHighlightList: c])
]

{ #category : 'accessing' }
MiAPIMapModel >> tgtPackageLayer [

	^layers sixth
]

{ #category : 'interactions' }
MiAPIMapModel >> unselectRelatedTo: anEntity [
	"unselect entities related to anEntity"

	browser removeFromSelection: ((self highlightList: anEntity) reject: #isAssociation)
]

{ #category : 'settings management' }
MiAPIMapModel >> updateFromConfiguration: aConfiguration [

	self accessedPrefix: aConfiguration accessedPrefix.
	self clientPrefix: aConfiguration clientPrefix.

	self runVisualization
]
