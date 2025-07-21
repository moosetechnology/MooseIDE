Class {
	#name : #MiArchitecturalMapSettingsDefaultHolder,
	#superclass : #Object,
	#instVars : [
		'specModel'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #'instance creation' }
MiArchitecturalMapSettingsDefaultHolder class >> on: aMiArchitecturalMapModel [

	^ self new
		  specModel: aMiArchitecturalMapModel;
		  yourself
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> associationTypes [

	^ self availableAssociationTypes
]

{ #category : #available }
MiArchitecturalMapSettingsDefaultHolder >> availableAssociationTypes [

	specModel entities ifNil: [ ^ OrderedCollection new ].

	^ ((specModel entities select: #isQueryable) asMooseGroup
		   allEntityTypes flatCollectAsSet: [ :class |
		   class allIncomingAssociationTypesIn: specModel entities metamodel ])
		  asOrderedCollection
]

{ #category : #available }
MiArchitecturalMapSettingsDefaultHolder >> availableDoubleClickActions [

	^ {
		  MiExpandCollapseShapeCommand new.
		  MiInspectShapeCommand new.
		  (MiPropagateShapeCommand new
			   browser: specModel browser;
			   yourself) }
]

{ #category : #available }
MiArchitecturalMapSettingsDefaultHolder >> availableLayouts [
	"RSLayout withAllSubclasses reject: [ :c | c isAbstract ]
But some of them require specific configuration that we cannot easily specify here so we choose a subset of the simplest ones"

	^ {
		  RSFlowLayout.
		  RSCircleLayout.
		  RSGridLayout.
		  RSTreeLayout }
]

{ #category : #available }
MiArchitecturalMapSettingsDefaultHolder >> availableQueries [

	^ specModel currentApplication availableQueries
		  addFirst: specModel currentApplication childrenQuery;
		  yourself
]

{ #category : #available }
MiArchitecturalMapSettingsDefaultHolder >> availableTags [

	specModel entities ifNotNil: [ :entities |
			entities ifNotEmpty: [
				^ entities anyOne mooseModel allTags sorted: #name ascending ] ].

	^ OrderedCollection new
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> doubleClickAction [

	^ self availableDoubleClickActions first
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> hideMegamorphicInvocations [

	^ false
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> hideReceivedEntities [

	^ false
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> layout [

	^ RSFlowLayout
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> megamorphicTreshold [

	^ 10
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> showDirectoriesAsRootNodes [

	^ false
]

{ #category : #accessing }
MiArchitecturalMapSettingsDefaultHolder >> specModel: aMiArchitecturalMapModel [

	specModel := aMiArchitecturalMapModel
]

{ #category : #defaults }
MiArchitecturalMapSettingsDefaultHolder >> tags [

	^ OrderedCollection new
]
