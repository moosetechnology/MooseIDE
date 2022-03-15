Class {
	#name : #MiMetaBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'commentNoteBook',
		'entities',
		'properties',
		'map',
		'propertiesRelationsTable',
		'propertiesPropertiesTable',
		'comment',
		'commentGetterPage',
		'commentSetterPage',
		'commentCommentPage',
		'getterCode',
		'setterCode'
	],
	#category : #'MooseIDE-Meta-MetaBrowser'
}

{ #category : #'world menu' }
MiMetaBrowser class >> helpMessage [
	^ 'Meta description in a metamodel'
]

{ #category : #'world menu' }
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
MiMetaBrowser class >> newModel [

	^ MiMetaBrowserModel new
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

{ #category : #specs }
MiMetaBrowser class >> windowSize [

	^ 750 @ 550
]

{ #category : #testing }
MiMetaBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #initialization }
MiMetaBrowser >> followEntity: anEntity [

	entities roots: (anEntity metamodel classes select: [ :class | 
			 class superclass fullName = 'Moose.Entity' ]).
	self selected: anEntity mooseDescription.
	map
		rootEntities: anEntity metamodel classes;
		run
]

{ #category : #initialization }
MiMetaBrowser >> initializeCommentNoteBook [

	comment := self newText.
	getterCode := self newCode.
	setterCode := self newCode.
	commentGetterPage := SpNotebookPage
		                     title: 'Getter'
		                     provider: [ getterCode ].
	commentSetterPage := SpNotebookPage
		                     title: 'Setter'
		                     provider: [ setterCode ].
	commentCommentPage := SpNotebookPage
		                      title: 'Comment'
		                      provider: [ comment ].
	commentNoteBook := self newNotebook.
	"Add a first page to select one page by default"
	commentNoteBook addPage: commentCommentPage
]

{ #category : #initialization }
MiMetaBrowser >> initializeEntities [

	entities := self newTree.
	entities
		children: [ :aMetaClass | aMetaClass subclasses ];
		display: [ :aMetaClass | aMetaClass name ].
	entities whenSelectedItemChangedDo: [ :element | 
		element ifNotNil: [ self selected: element ] ]
]

{ #category : #initialization }
MiMetaBrowser >> initializeLayout [

	| toolbar left |
	toolbar := self class defaultLayout.
	left := SpPanedLayout newTopToBottom
		        add: (SpPanedLayout newLeftToRight
				         add: entities;
				         add: properties;
				         yourself);
		        add: map;
		        yourself.
	self layout: (SpBoxLayout newTopToBottom
			 add: toolbar expand: false;
			 add: (SpPanedLayout newLeftToRight
					  positionOfSlider: 70 percent;
					  add: left;
					  add: commentNoteBook;
					  yourself);
			 yourself)
]

{ #category : #initialization }
MiMetaBrowser >> initializeMap [

	map := self instantiate: MiUML.
	map miUMLModelDescriptor: RSUMLClassDescriptor new forFame
]

{ #category : #initialization }
MiMetaBrowser >> initializePresenters [
	self initializeCommentNoteBook.
	self initializeEntities.
	self initializeProperties.
	self initializeMap.
	self initializeLayout
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

{ #category : #accessing }
MiMetaBrowser >> miSelectedItem [

	^ model selected
]

{ #category : #enumerating }
MiMetaBrowser >> selected: anEntity [

	model selected: anEntity.
	self updateCommentOf: anEntity.
	self updateProperty.
	self window updateToolbar
]

{ #category : #initialization }
MiMetaBrowser >> updateCommentOf: mooseDescription [

	mooseDescription isFM3Property
		ifTrue: [ 
			comment text: mooseDescription comment.
			getterCode text: mooseDescription compiledMethod sourceCode.
			setterCode text:
				((mooseDescription implementingClass lookupSelector:
					  (mooseDescription implementingSelector , ':') asSymbol)
					 ifNil: [ '' ]
					 ifNotNil: [ :method | method compiledMethod sourceCode ]).
			commentNoteBook pages: { 
					commentCommentPage.
					commentGetterPage }.
			setterCode text ifNotEmpty: [ 
				commentNoteBook addPage: commentSetterPage ] ]
		ifFalse: [ 
			comment text: (mooseDescription implementingClass
					 ifNil: [ 'No Comment' ]
					 ifNotNil: [ :class | class comment ]).
			commentNoteBook pages: { commentCommentPage } ]
]

{ #category : #initialization }
MiMetaBrowser >> updateProperty [

	propertiesRelationsTable items: model selected allComplexProperties.
	propertiesPropertiesTable items:
		model selected allPrimitiveProperties
]
