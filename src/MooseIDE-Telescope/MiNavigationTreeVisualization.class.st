Class {
	#name : #MiNavigationTreeVisualization,
	#superclass : #TLVisualization,
	#instVars : [
		'entities',
		'children',
		'property',
		'builder'
	],
	#category : #'MooseIDE-Telescope-NavigationTree'
}

{ #category : #building }
MiNavigationTreeVisualization >> buildAssociationButtons [
	(self > #buttons) styleSheet
		width: 200;
		height: 50;
		nodeLabel: [ :association | association mooseDescription name ];
		backgroundColor: [ :association | 
			association = builder association
				ifTrue: [ Color red ]
				ifFalse: [ Color lightGray ] ].
	(self > #buttons)
		layout: TLLinearLayout topToBottom;
		addNodesFromEntities: builder availableAssociations;
		addInteraction:
			(TLCustomAction
				block: [ :aNode | self resetWithAssociation: aNode entity ])
				onClick
]

{ #category : #building }
MiNavigationTreeVisualization >> buildEntities [
	(self > #entities)
		addNodesFromEntities: (self entities , self children) asSet;
		connectFollowingProperty: self property;
		addInteraction: TLPopUpAction onMouseOver;
		layout:
			(TLTreeLayout new
				leavesGap: 100;
				levelGap: 100;
				yourself)
]

{ #category : #building }
MiNavigationTreeVisualization >> buildStyle [
	(self > #entities) styleSheet
		nodeLabel: #name position: #top;
		labelSize: 10;
		width: 30;
		height: 30;
		backgroundColor: [ :entity | 
			(self entities includes: entity)
				ifTrue: [ Color red ]
				ifFalse: [ Smalltalk ui theme selectionColor ] ]
]

{ #category : #building }
MiNavigationTreeVisualization >> buildVisualization [
	self buildAssociationButtons.
	self buildStyle.
	self buildEntities.
	self layout: (TLLinearLayout topToBottom gap: 200)
]

{ #category : #accessing }
MiNavigationTreeVisualization >> builder [
	^ builder
]

{ #category : #accessing }
MiNavigationTreeVisualization >> builder: anObject [
	builder := anObject
]

{ #category : #accessing }
MiNavigationTreeVisualization >> children [
	^ children
]

{ #category : #accessing }
MiNavigationTreeVisualization >> children: anObject [
	children := anObject
]

{ #category : #accessing }
MiNavigationTreeVisualization >> entities [
	^ entities
]

{ #category : #accessing }
MiNavigationTreeVisualization >> entities: anObject [
	entities := anObject
]

{ #category : #accessing }
MiNavigationTreeVisualization >> property [
	^ property
]

{ #category : #accessing }
MiNavigationTreeVisualization >> property: anObject [
	property := anObject
]

{ #category : #building }
MiNavigationTreeVisualization >> resetWithAssociation: anAssociation [
	builder
		association: anAssociation;
		run
]
