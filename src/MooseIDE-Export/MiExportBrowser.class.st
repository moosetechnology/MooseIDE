"
Prepares the export of entities as CSV file.
Allows the addition of a comment for each entity.

- Follow: Accepts MooseObjects

- Highlight: TODO

- Propagate: All entities
"
Class {
	#name : #MiExportBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'commentDictionary',
		'entitiesTable',
		'commentsButton',
		'commentsAreShown'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #actions }
MiExportBrowser class >> commentColumnTitle [

	^ 'Comment'
]

{ #category : #layout }
MiExportBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #toolbar height: self toolbarHeight;
		  add: #entitiesTable;
		  yourself
]

{ #category : #'world menu' }
MiExportBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #Exporter)
		parent: #Moose;
		label: self title;
		icon: (self iconNamed: #smallExport);
		order: 6;
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiExportBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiExportBrowser class >> title [

	^ 'Entities exporter'
]

{ #category : #'columns management' }
MiExportBrowser >> addColumnForProperty: aFM3Property [

	entitiesTable addColumn: (SpStringTableColumn
			 title: aFM3Property name
			 evaluated: [ :entity | 
			 entity propertyNamed: aFM3Property name ifAbsent: [ '-' ] ])
			yourself
]

{ #category : #'columns management' }
MiExportBrowser >> addCommentsColumn [

	entitiesTable addColumn: ((SpStringTableColumn
			  title: self class commentColumnTitle
			  evaluated: [ :entity | self commentOf: entity ])
			 beEditable;
			 onAcceptEdition: [ :entity :comment | 
				 commentDictionary at: entity put: comment ];
			 yourself).
	entitiesTable refresh
]

{ #category : #testing }
MiExportBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #initialization }
MiExportBrowser >> columnChoiceButton [

	| choiceButton |
	choiceButton := self newToolbarButton
		                label: 'Chose columns';
		                icon: (self iconNamed: #mooseProperties).
	choiceButton action: [ 
		| popup |
		(popup := self newPopover)
			relativeTo: choiceButton;
			bePositionRight;
			presenter: self propertiesListForPopover;
			popup ].
	^ choiceButton
]

{ #category : #accessing }
MiExportBrowser >> commentOf: anEntity [

	^ commentDictionary at: anEntity ifAbsent: ''
]

{ #category : #accessing }
MiExportBrowser >> commentsAreShown [

	^ commentsAreShown ifNil: [ commentsAreShown := false ]
]

{ #category : #accessing }
MiExportBrowser >> commentsAreShown: anObject [

	commentsAreShown := anObject
]

{ #category : #initialization }
MiExportBrowser >> commentsButton [

	^ commentsButton := self newToolbarButton
		                    label: 'Toggle comments';
		                    icon: (self iconNamed: #edit);
		                    action: [ :button | self toggleCommentsColumn ]
]

{ #category : #accessing }
MiExportBrowser >> commonPropertiesIn: aMooseGroup [

	| properties |
	aMooseGroup ifEmpty: [ ^ aMooseGroup ].

	properties := ((aMooseGroup collect: [ :entity | 
		                entity mooseDescription allPrimitiveProperties ]) 
		               fold: [ :availableProperties :entityProperty | 
			               availableProperties & entityProperty ]) sorted:
		              #name ascending.

	"Show only 5 properties, so it is still readable wothout having to expand the browser."
	^ properties size <= 5
		  ifTrue: [ properties ]
		  ifFalse: [ properties first: 5 ]
]

{ #category : #'columns management' }
MiExportBrowser >> defaultTableColumns [

	^ { 
		  ((SpStringTableColumn title: 'Name' evaluated: #name)
			   beSortable;
			   yourself).
		  ((SpStringTableColumn
			    title: 'Type'
			    evaluated: [ :entity | entity mooseDescription name ])
			   beSortable;
			   yourself) }
]

{ #category : #actions }
MiExportBrowser >> exportEntitiesToCSV [

	| file |
	file := UIManager default
		        chooseForSaveFileReference: 'Chose export destination'
		        extensions: #( 'csv' )
		        path: 'entities.csv'.
	file ifNotNil: [ 
		file writeStreamDo: [ :stream | entitiesTable asCSVOn: stream ].
		UIManager default
			inform: 'Entities exported.
Click to show in folder'
			actionOnClick: [ file openInOSFileBrowser ] ]
]

{ #category : #actions }
MiExportBrowser >> followEntity: anEntity [

	self updateEntitiesListWith: anEntity asMooseGroup.

	commentDictionary := Dictionary new
]

{ #category : #initialization }
MiExportBrowser >> initializePresenters [

	self initializeToolbar.
	self initializeTable
]

{ #category : #initialization }
MiExportBrowser >> initializeTable [

	entitiesTable := self newTable beResizable.
	entitiesTable columns: self defaultTableColumns
]

{ #category : #initialization }
MiExportBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: self columnChoiceButton;
		           addItem: self commentsButton;
		           addItem: (self newToolbarButton
				            label: 'Export to CSV';
				            icon: (self iconNamed: #smallExport);
				            action: [ self exportEntitiesToCSV ])
]

{ #category : #accessing }
MiExportBrowser >> miSelectedItem [

	^ entitiesTable items
]

{ #category : #'columns management' }
MiExportBrowser >> propertiesListForPopover [

	| list |
	list := self newSelectableListForPopoverExtent: 250 @ 250.

	list
		display: [ :property | property name ];
		onActivation: [ :property | self showProperties: list selectedItems ];
		onDeactivation: [ :property | 
			self showProperties: list selectedItems ].

	list items: ((self miSelectedItem flatCollectAsSet: [ :entity | 
			  entity mooseDescription allPrimitiveProperties ]) sorted:
			 #name ascending).

	list selectItems:
		(list items select: [ :property | self showsProperty: property ]).

	^ list
]

{ #category : #'columns management' }
MiExportBrowser >> removeCommentsColumn [

	entitiesTable columns: (entitiesTable columns reject: [ :column | 
			 column title = self class commentColumnTitle ]).
	entitiesTable refresh
]

{ #category : #'columns management' }
MiExportBrowser >> showProperties: aCollectionOfFM3Properties [

	entitiesTable columns: self defaultTableColumns.
	
	aCollectionOfFM3Properties do: [ :property | 
		self addColumnForProperty: property ].
	
	commentsButton isSelected ifTrue: [ self addCommentsColumn ].
	
	entitiesTable refresh
]

{ #category : #testing }
MiExportBrowser >> showsProperty: aFM3Property [

	^ entitiesTable columns anySatisfy: [ :column | 
		  column title = aFM3Property name ]
]

{ #category : #'columns management' }
MiExportBrowser >> toggleCommentsColumn [

	self commentsAreShown
		ifTrue: [ 
			self removeCommentsColumn.
			self commentsAreShown: false ]
		ifFalse: [ 
			self addCommentsColumn.
			self commentsAreShown: true ]
]

{ #category : #'columns management' }
MiExportBrowser >> updateEntitiesListWith: aMooseGroup [

	entitiesTable columns: self defaultTableColumns.
	(self commonPropertiesIn: aMooseGroup) do: [ :property | 
		entitiesTable addColumn: (SpStringTableColumn
				 title: property name
				 evaluated: [ :entity | 
				 entity propertyNamed: property name ifAbsent: [ '-' ] ]) ].
	entitiesTable items: aMooseGroup
]
