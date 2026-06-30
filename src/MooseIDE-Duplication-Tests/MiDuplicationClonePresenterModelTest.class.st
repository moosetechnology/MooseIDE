Class {
	#name : 'MiDuplicationClonePresenterModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'clonePresenterModel'
	],
	#category : 'MooseIDE-Duplication-Tests',
	#package : 'MooseIDE-Duplication-Tests'
}

{ #category : 'running' }
MiDuplicationClonePresenterModelTest >> makeReplicaFor: entity [
	"Create a minimal FamixReplica referencing entity."
	^ FamixReplica new
		entity: entity;
		yourself
]

{ #category : 'running' }
MiDuplicationClonePresenterModelTest >> modelEntityChildrenMap [
	^clonePresenterModel instVarNamed: #entityChildrenMap
]

{ #category : 'running' }
MiDuplicationClonePresenterModelTest >> modelEntityParentMap [
	^clonePresenterModel instVarNamed: #entityParentMap
]

{ #category : 'running' }
MiDuplicationClonePresenterModelTest >> modelReplicas [
	^clonePresenterModel instVarNamed: #replicas
]

{ #category : 'running' }
MiDuplicationClonePresenterModelTest >> modelVisibleChildren [
	^clonePresenterModel instVarNamed: #visibleChildren
]

{ #category : 'running' }
MiDuplicationClonePresenterModelTest >> setUp [
	super setUp.

	clonePresenterModel := MiDuplicationClonePresenterModel new.
	clonePresenterModel browser: Mock new
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testCompressedIntermediateAncestor [
	"Two leaves are each under a distinct single-child intermediate class.
	Both intermediates must be compressed away; the shared root package
	appears as the sole visible root with both leaves as direct children."
	| pckg classA classB mthA mthB hierarchy |
	pckg := FamixJavaPackage new.
	classA    := FamixJavaClass new parentPackage: pckg ; yourself.
	classB    := FamixJavaClass new parentPackage: pckg ; yourself.
	mthA   := FamixJavaMethod new parentType: classA ; yourself.
	mthB   := FamixJavaMethod new parentType: classB ; yourself.

	hierarchy := clonePresenterModel showReplicas: { self makeReplicaFor: mthA . self makeReplicaFor: mthB }.

	self assertCollection: hierarchy roots hasSameElements: { pckg }.
	self assertCollection: (hierarchy visibleChildrenOf: pckg) hasSameElements: { mthA. mthB }.
	self deny: (hierarchy isVisible: classA).
	self deny: (hierarchy isVisible: classB)
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testComputeVisibleRootsOfLeaf [

	| mth |
	mth := FamixRepTestMethod new.
	self modelReplicas add: (self makeReplicaFor: mth).

	self assertCollection: (clonePresenterModel computeVisibleRootsOf: mth) hasSameElements: { mth }
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testComputeVisibleRootsOfSingleChain [

	| clazz mth |
	clazz := FamixJavaClass new.
	mth := FamixJavaMethod new parentType: clazz ; yourself.

	self modelEntityChildrenMap at: clazz put: { mth }.
	self modelReplicas add: (self makeReplicaFor: mth).

	self assertCollection: (clonePresenterModel computeVisibleRootsOf: clazz) hasSameElements: { mth }
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testContainerWithoutReplicaIsNotLeaf [
	"A container entity that appears in the hierarchy only because it is
	an ancestor of a leaf entity must not be reported as a leaf itself."
	| class mth hierarchy |
	class := FamixRepTestClass new.
	mth := FamixRepTestMethod new parentType: class ; yourself.

	hierarchy := clonePresenterModel showReplicas: { self makeReplicaFor: mth }.

	self deny: (hierarchy isLeaf: class).
	self assert: (hierarchy isLeaf: mth).
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testDeepSingleChain [
	"A chain of single-child packages ending in one leaf: all intermediate
	packages are collapsed and the leaf itself becomes the sole root."
	| pckg clazz leaf hierarchy |
	pckg   := FamixJavaPackage new.
	clazz   := FamixJavaClass new parentPackage: pckg ; yourself.
	leaf := FamixJavaMethod new parentType: clazz ; yourself.

	hierarchy := clonePresenterModel showReplicas: { self makeReplicaFor: leaf }.

	self assertCollection: hierarchy roots hasSameElements: { leaf }.
	self deny: (hierarchy isVisible: pckg).
	self deny: (hierarchy isVisible: clazz)
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testDisplayStringOf [
	"the name of a visible parent is stripped from the mooseName of a child entity"

	| clazz mth displayed |
	clazz := FamixRepTestClass new name: 'AClazz' ; yourself.
	mth := FamixRepTestMethod new name: 'mth()' ; parentType: clazz ; yourself.
	clonePresenterModel registerParent: clazz child: mth.
	clonePresenterModel registerParent: nil child: clazz.

	"this makes the class 'visible'"
	self modelVisibleChildren at: clazz put: { mth }.

	displayed := clonePresenterModel displayStringOf: mth.
	
	self assert: displayed equals: 'mth()'
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testDisplayStringOfSoleLeaf [
	"The displayString of entity without visible parent is its mooseName"

	| clazz mth displayed |
	clazz := FamixRepTestClass new name: 'AClazz' ; yourself.
	mth := FamixRepTestMethod new name: 'mth()' ; parentType: clazz ; yourself.
	clonePresenterModel registerParent: clazz child: mth.
	clonePresenterModel registerParent: nil child: clazz.

	displayed := clonePresenterModel displayStringOf: mth.
	
	self assert: displayed equals: 'AClazz.mth()'
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testEmptyReplicas [
	| hierarchy |
	hierarchy := clonePresenterModel showReplicas: #().
	
	self assertEmpty: hierarchy roots.
	self deny: (hierarchy isVisible: Object new)
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testMultipleBranchPoints [
	"Four leaves under two intermediate packages under one root package.
	Both intermediates have two children so they are kept; the root is also
	kept as a branch node over the two intermediates."
	| root classA classB mthA1 mthA2 mthB1 mthB2 hierarchy |
	root := FamixJavaPackage new.
	classA := FamixJavaClass new parentPackage: root ; yourself.
	classB := FamixJavaClass new parentPackage: root ; yourself.
	mthA1  := FamixJavaMethod new parentType: classA ; yourself.
	mthA2  := FamixJavaMethod new parentType: classA ; yourself.
	mthB1  := FamixJavaMethod new parentType: classB ; yourself.
	mthB2  := FamixJavaMethod new parentType: classB ; yourself.

	hierarchy := clonePresenterModel showReplicas: {
		self makeReplicaFor: mthA1.
		self makeReplicaFor: mthA2.
		self makeReplicaFor: mthB1.
		self makeReplicaFor: mthB2 }.

	self assertCollection: hierarchy roots hasSameElements: {root}.
	self assertCollection: (hierarchy visibleChildrenOf: root) hasSameElements: { classA. classB }.
	self assertCollection: (hierarchy visibleChildrenOf: classA) hasSameElements: { mthA1. mthA2 }.
	self assertCollection: (hierarchy visibleChildrenOf: classB) hasSameElements: { mthB1. mthB2 }
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testNoSharedContainer [
	"Two leaf methods in different root classes: single-child ancestors collapse
	and both leaves become roots."
	| clazz1 clazz2 mth1 mth2 hierarchy |
	clazz1 := FamixRepTestClass new.
	clazz2 := FamixRepTestClass new.
	mth1 := FamixRepTestMethod new parentType: clazz1 ; yourself.
	mth2 := FamixRepTestMethod new parentType: clazz2 ; yourself.

	hierarchy := clonePresenterModel showReplicas: { self makeReplicaFor: mth1 . self makeReplicaFor: mth2 }.

	self assertCollection: hierarchy roots hasSameElements: { mth1. mth2 }.

]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testPartiallySharedContainer [
	"Three replicas: two methods in classA, one method in classB.
	classA has two children so it is kept; classB has one child so it is
	collapsed, and its method becomes a root directly."
	| classA classB mthA1 mthA2 mthB hierarchy |
	classA := FamixRepTestClass new.
	classB := FamixRepTestClass new.
	mthA1 := FamixRepTestMethod new parentType: classA ; yourself.
	mthA2 := FamixRepTestMethod new parentType: classA ; yourself.
	mthB := FamixRepTestMethod new parentType: classB ; yourself.

	hierarchy := clonePresenterModel showReplicas: {
		self makeReplicaFor: mthA1.
		self makeReplicaFor: mthA2.
		self makeReplicaFor: mthB }.

	self assertCollection: hierarchy roots hasSameElements: {classA . mthB}.
	self assertCollection: (hierarchy visibleChildrenOf: classA) hasSameElements: { mthA1 . mthA2 }
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testSingleReplicaOnRootEntity [
	"An entity with no containers becomes the root of the hierarchy."
	| class hierarchy |
	class := FamixRepTestClass new.

	hierarchy := clonePresenterModel showReplicas: { self makeReplicaFor: class }.

	self assertCollection: hierarchy roots hasSameElements: {class}.
	self assert: (hierarchy isLeaf: class).
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testVisibleParent [

	| clazz mth visible |
	clazz := FamixRepTestClass new.
	mth := FamixRepTestMethod new.
	clonePresenterModel registerParent: clazz child: mth.
	clonePresenterModel registerParent: nil child: clazz.

	"this makes the class 'visible'"
	self modelVisibleChildren at: clazz put: { mth }.

	visible := clonePresenterModel visibleParentOf: mth.
	
	self assert: visible equals: clazz
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testVisibleParentOfSoleLeaf [
	"A sole leaf is the root and therefore its parent entity is not visible"
	| clazz mth visible |
	clazz := FamixRepTestClass new.
	mth := FamixRepTestMethod new.
	clonePresenterModel registerParent: clazz child: mth.
	clonePresenterModel registerParent: nil child: clazz.

	visible := clonePresenterModel visibleParentOf: mth.
	
	self assert: visible equals: nil
]

{ #category : 'tests - hierarchy' }
MiDuplicationClonePresenterModelTest >> testVisiblechildrenOfAbsentEntity [
	"Asking for children of an entity that is not in the hierarchy returns
	an empty collection rather than raising an error."
	| clazz mth hierarchy |
	clazz := FamixRepTestClass new.
	mth := FamixRepTestMethod new  parentType: clazz ; yourself.

	hierarchy := clonePresenterModel showReplicas: { self makeReplicaFor: mth }.

	self assertEmpty: (hierarchy visibleChildrenOf: clazz).
	self assertEmpty: (hierarchy visibleChildrenOf: Object new)
]
