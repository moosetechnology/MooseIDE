Class {
	#name : 'MiArchitecturalMapModelDefaultHolder',
	#superclass : 'Object',
	#instVars : [
		'specModel'
	],
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'instance creation' }
MiArchitecturalMapModelDefaultHolder class >> on: aMiArchitecturalMapModel [

	^ self new
		  specModel: aMiArchitecturalMapModel;
		  yourself
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> associationTypes [

	^ self availableAssociationTypes
]

{ #category : 'available' }
MiArchitecturalMapModelDefaultHolder >> availableAssociationTypes [

	specModel entities ifNil: [ ^ OrderedCollection new ].

	^ ((specModel entities select: #isQueryable) asMooseGroup
		   allEntityTypes flatCollectAsSet: [ :class |
		   class allIncomingAssociationTypesIn: specModel entities metamodel ])
		  asOrderedCollection
]

{ #category : 'available' }
MiArchitecturalMapModelDefaultHolder >> availableDoubleClickActions [

	^ {
		  MiExpandCollapseShapeCommand new.
		  MiInspectShapeCommand new.
		  (MiPropagateShapeCommand new
			   browser: specModel browser;
			   yourself) }
]

{ #category : 'available' }
MiArchitecturalMapModelDefaultHolder >> availableLayouts [
	"RSLayout withAllSubclasses reject: [ :c | c isAbstract ]
But some of them require specific configuration that we cannot easily specify here so we choose a subset of the simplest ones"

	^ {
		  RSFlowLayout.
		  RSCircleLayout.
		  RSGridLayout.
		  RSTreeLayout }
]

{ #category : 'available' }
MiArchitecturalMapModelDefaultHolder >> availableQueries [

	^ specModel currentApplication availableQueries
		  addFirst: specModel currentApplication childrenQuery;
		  yourself
]

{ #category : 'available' }
MiArchitecturalMapModelDefaultHolder >> availableTags [

	specModel entities ifNotNil: [ :entities |
			entities ifNotEmpty: [
				^ entities anyOne mooseModel allTags sorted: #name ascending ] ].

	^ OrderedCollection new
]

{ #category : 'accessing' }
MiArchitecturalMapModelDefaultHolder >> childrenQuery [

	^ specModel currentApplication defaultChildrenQuery
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> doubleClickAction [

	^ self availableDoubleClickActions first
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> hideMegamorphicInvocations [

	^ false
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> hideReceivedEntities [

	^ false
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> layout [

	^ RSFlowLayout
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> megamorphicTreshold [

	^ 10
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> showDirectoriesAsRootNodes [

	^ false
]

{ #category : 'accessing' }
MiArchitecturalMapModelDefaultHolder >> specModel: aMiArchitecturalMapModel [

	specModel := aMiArchitecturalMapModel
]

{ #category : 'defaults' }
MiArchitecturalMapModelDefaultHolder >> tags [

	^ OrderedCollection new
]
