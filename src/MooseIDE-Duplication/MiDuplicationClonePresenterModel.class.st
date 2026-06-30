Class {
	#name : 'MiDuplicationClonePresenterModel',
	#superclass : 'Object',
	#instVars : [
		'browser',
		'replicas',
		'visibleChildren',
		'visibleRoots',
		'entityChildrenMap',
		'entityParentMap'
	],
	#category : 'MooseIDE-Duplication-Model',
	#package : 'MooseIDE-Duplication',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> browser [

	^ browser
]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> browser: anObject [

	browser := anObject
]

{ #category : 'steps' }
MiDuplicationClonePresenterModel >> buildEntityHierarchy [

	"Breath First Search upward — build a map of entity -> its single direct parent (or nil)"
	| queue |
	queue := self leafEntities.
	entityParentMap := IdentityDictionary new.
	entityChildrenMap := IdentityDictionary new.

	[ queue notEmpty ]
	whileTrue: [
		| entity parent |
		entity := queue removeFirst.
		(entityParentMap includesKey: entity) ifFalse: [
			parent := entity containers
				ifEmpty: [ nil ]
				ifNotEmpty: [ :c |
					queue add: c anyOne.
					c anyOne ].

			self registerParent: parent child: entity.
		]
	]

]

{ #category : 'steps' }
MiDuplicationClonePresenterModel >> compressHierarchy [

	visibleChildren := IdentityDictionary new.
	visibleRoots := OrderedCollection new.

	self topEntities do: [ :top |
		visibleRoots addAll: (self computeVisibleRootsOf: top) ]
]

{ #category : 'steps' }
MiDuplicationClonePresenterModel >> computeVisibleRootsOf: entity [
	"Return an OrderedCollection of the visible roots of the subtree rooted at entity.
	A visible root is either a leaf (has a replica) or a branch node (>= 2 visible children).
	Populates visibleChildren as a side effect for every branch node found."

	| visibleChildRoots |

	(self isLeaf: entity) ifTrue: [ ^ {entity} ].

	"Recurse into each direct child of entity in the full tree"
	visibleChildRoots := OrderedCollection new.
	(entityChildrenMap at: entity) do: [ : child |
		visibleChildRoots addAll: (self computeVisibleRootsOf: child) ].

	^(visibleChildRoots size >= 2)
		ifTrue: [
			visibleChildren at: entity put: visibleChildRoots.
			{entity} ]
		ifFalse: [ visibleChildRoots ]
]

{ #category : 'api' }
MiDuplicationClonePresenterModel >> displayStringOf: anEntity [
	"the name of a visible parent is stripped from the mooseName of a child entity"
	| prefix fullname |

	prefix := (self visibleParentOf: anEntity) ifNil: [ '' ] ifNotNil: [ :parent | parent mooseName , '.'].
	fullname := anEntity mooseName.

	^fullname copyFrom: prefix size + 1 to: fullname size
]

{ #category : 'initialization' }
MiDuplicationClonePresenterModel >> initialize [

	super initialize.

	"initialization are mostly for tests"
	replicas := OrderedCollection new: 0.
	entityParentMap := Dictionary new: 0.
	entityChildrenMap := Dictionary new: 0.	
	visibleChildren := Dictionary new: 0.
	visibleRoots := OrderedCollection new: 0.

]

{ #category : 'testing' }
MiDuplicationClonePresenterModel >> isLeaf: entity [
	^ self leafEntities includes: entity
]

{ #category : 'testing' }
MiDuplicationClonePresenterModel >> isVisible: entity [
	^ visibleChildren includesKey: entity
]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> leafEntities [

	^(replicas collect: #entity) asOrderedCollection 
]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> registerParent: parent child: entity [

	entityParentMap at: entity put: parent.

	parent ifNotNil: [
		(entityChildrenMap at: parent ifAbsentPut: [ OrderedCollection new ])
			add: entity ]
]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> replicaFor: anEntity [

	^replicas
		detect: [ :replica | replica entity = anEntity ] 
		ifNone: [ nil ]
]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> roots [

	^visibleRoots
]

{ #category : 'api' }
MiDuplicationClonePresenterModel >> showContentForEntity: entity [

	| replica |

	entity ifNil: [ browser clearContent. ^self ].
	replica := self replicaFor: entity.
	replica ifNil: [ browser clearContent. ^self ].

	browser formatReplicaText: replica
]

{ #category : 'api' }
MiDuplicationClonePresenterModel >> showReplicas: selectedReplicas [

	replicas := selectedReplicas.
	self buildEntityHierarchy.
	self compressHierarchy

	browser roots: self roots	
]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> topEntities [

	^entityParentMap associations
		select: [ :assoc | assoc value isNil ]
		thenCollect: [ :assoc | assoc key ].

]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> visibleChildrenOf: entity [
	^ visibleChildren at: entity ifAbsent: [ OrderedCollection new ]
]

{ #category : 'accessing' }
MiDuplicationClonePresenterModel >> visibleParentOf: anEntity [

	^(entityParentMap at: anEntity)
		ifNotNil: [ :parentEntity |
			(self isVisible: parentEntity)
				ifTrue: [ parentEntity ]
				ifFalse: [ self visibleParentOf: parentEntity ]
		]

]
