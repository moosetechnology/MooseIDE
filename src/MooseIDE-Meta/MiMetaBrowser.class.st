Class {
	#name : #MiMetaBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'comment',
		'entities',
		'properties',
		'map',
		'propertiesRelationsTable',
		'propertiesPropertiesTable'
	],
	#category : #'MooseIDE-Meta-MetaBrowser'
}

{ #category : #specs }
MiMetaBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: (SpBoxLayout newLeftToRight
				   add: (SpBoxLayout newTopToBottom
						    add: (SpBoxLayout newLeftToRight
								     add: #entities;
								     add: #properties;
								     yourself);
						    add: #map;
						    yourself);
				   add: #comment;
				   yourself);
		  yourself
]

{ #category : #specs }
MiMetaBrowser class >> helpMessage [
	^ 'Meta description in a metamodel'
]

{ #category : #specs }
MiMetaBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #MetaBrowser)
		parent: (self metaBrowsersMenuLabel);
		label: (self title);
		icon: (self iconNamed: #mooseFame);
		order: 4;
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiMetaBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiMetaBrowser class >> title [
	^ 'Meta Browser'
]

{ #category : #testing }
MiMetaBrowser >> canReceiveEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #initialization }
MiMetaBrowser >> followEntity: anEntity [

	", anEntity metamodel traits"

	(self updateCommentOf: anEntity mooseDescription).
	entities roots: (anEntity metamodel classes select: [ :class | 
			 class superclass fullName = 'Moose.Entity' ]).
	self updatePropertyFromMooseDescription: anEntity mooseDescription.
	map
		rootEntities: anEntity metamodel classes;
		run
]

{ #category : #initialization }
MiMetaBrowser >> initializeComment [
	comment := self newText
]

{ #category : #initialization }
MiMetaBrowser >> initializeEntities [

	entities := self newTree.
	entities
		children: [ :aMetaClass | aMetaClass subclasses ];
		display: [ :aMetaClass | aMetaClass name ].
	entities whenSelectedItemChangedDo: [ :element | 
		element ifNotNil: [ 
			self updatePropertyFromMooseDescription: element.
			comment text: (element implementingClass
					 ifNil: [ 'No Comment' ]
					 ifNotNil: [ :class | class comment ]) ] ]
]

{ #category : #initialization }
MiMetaBrowser >> initializeMap [

	map := self instantiate: MiUML.
	map miUMLModelDescriptor: RSUMLClassDescriptor new forFame.
	map whenSelectedItemChangedDo: [ :element | 
		self updatePropertyFromMooseDescription: element.
		self updateCommentOf: element ]
]

{ #category : #initialization }
MiMetaBrowser >> initializePresenters [
	super initializePresenters.
	self initializeComment.
	self initializeEntities.
	self initializeProperties.
	self initializeMap.
]

{ #category : #initialization }
MiMetaBrowser >> initializeProperties [

	properties := self newNotebook.
	propertiesRelationsTable := self newTable
		                            addColumn:
			                            (SpImageTableColumn
				                             title: 'Name'
				                             evaluated: #name);
		                            addColumn: (SpImageTableColumn
				                             title: 'Type'
				                             evaluated: [ :metaProperty | 
					                             metaProperty type name ]);
		                            yourself.
	propertiesPropertiesTable := self newTable
		                             addColumn:
			                             (SpImageTableColumn
				                              title: 'Name'
				                              evaluated: #name);
		                             addColumn: (SpImageTableColumn
				                              title: 'Type'
				                              evaluated: [ :metaProperty | 
					                              metaProperty type name ]);
		                             yourself.
	propertiesRelationsTable whenSelectedDo: [ :property | 
		self updateCommentOf: property ].
	propertiesPropertiesTable whenSelectedDo: [ :property | 
		self updateCommentOf: property ].
	properties
		addPageTitle: 'Relations' provider: [ propertiesRelationsTable ];
		addPageTitle: 'Properties' provider: [ propertiesPropertiesTable ]
]

{ #category : #initialization }
MiMetaBrowser >> updateCommentOf: aMooseDescription [

	comment text: (aMooseDescription isFM3Property
		ifTrue: [ aMooseDescription comment ]
		ifFalse: [ "If false I am a fm3trait or fm3Class"
			aMooseDescription implementingClass
				ifNil: [ 'No Comment' ]
				ifNotNil: [ :class | class comment ] ])
]

{ #category : #initialization }
MiMetaBrowser >> updatePropertyFromMooseDescription: aMooseDescription [

	propertiesRelationsTable items:
		aMooseDescription allComplexProperties.
	propertiesPropertiesTable items:
		aMooseDescription allPrimitiveProperties
]
