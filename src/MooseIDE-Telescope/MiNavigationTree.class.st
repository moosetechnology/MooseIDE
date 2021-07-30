Class {
	#name : #MiNavigationTree,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'entities',
		'association'
	],
	#category : #'MooseIDE-Telescope-NavigationTree'
}

{ #category : #accessing }
MiNavigationTree >> association [
	^ association ifNil: [ self setAssociation ]
]

{ #category : #accessing }
MiNavigationTree >> association: anObject [
	^ association := anObject
]

{ #category : #accessing }
MiNavigationTree >> availableAssociations [
	| associations model |
	associations := self entities allEntityTypes
		flatCollectAsSet: [ :class | 
			(class incomingAssociationTypesIn: self entities metamodel)
				, (class outgoingAssociationTypesIn: self entities metamodel) ].
	model := self entities isMooseModel
		ifTrue: [ self entities ]
		ifFalse: [ self entities mooseModel ].
	^ ((model allEntityTypes
		select: [ :class | 
			associations
				anySatisfy: [ :type | class = type or: [ class allTraits includes: type ] ] ])
		flatCollect: #withAllSubclasses)
		select:
			[ :class | (model metamodel classes collect: #implementingClass) includes: class ]
]

{ #category : #accessing }
MiNavigationTree >> entities [
	^ entities
]

{ #category : #accessing }
MiNavigationTree >> entities: anObject [
	entities := anObject
]

{ #category : #running }
MiNavigationTree >> run [
	super run.
	(MiNavigationTreeVisualization new
		builder: self;
		entities: self entities;
		children:
			(self entities
				flatCollectAsSet: [ :entity | 
					(entity queryOutgoing: self association) opposites
						, (entity queryIncoming: self association) opposites ]);
		property: [ :entity | (entity queryOutgoing: self association) opposites ];
		yourself) openInCanvas: self canvas.
	self canvas zoomToFit
]

{ #category : #accessing }
MiNavigationTree >> setAssociation [
	^ association := self availableAssociations
		ifNotEmpty: [ :associations | associations anyOne ]
		ifEmpty: [ MooseGroup new ]
]
