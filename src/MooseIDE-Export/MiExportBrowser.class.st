"
Prepares the export of entities as CSV file.
Allows the addition of a comment for each entity.

- Accepted entities: a MooseObject

- Highlight: TODO

- Propagate: All entities
"
Class {
	#name : #MiExportBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'entitiesTable',
		'commentsButton',
		'commentsAreShown',
		'entitiesCountLabel'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #actions }
MiExportBrowser class >> commentColumnTitle [

	^ 'Comment'
]

{ #category : #'world menu' }
MiExportBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiExportBrowser class >> menuIconName [

	^ #smallExport
]

{ #category : #'world menu' }
MiExportBrowser class >> menuItem [

	^ #Exporter
]

{ #category : #'world menu' }
MiExportBrowser class >> menuPriority [

	^ self menuMetaToolsPriority + 2
]

{ #category : #specs }
MiExportBrowser class >> newModel [

	^ MiExportModel new
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
MiExportBrowser >> addColumn: aColumn [

	(aColumn isKindOf: FM3Property)
		ifTrue: [ self addColumnForProperty: aColumn ]
		ifFalse: [ 
		self model addColumnForQuery: aColumn query withName: aColumn name ]
]

{ #category : #'columns management' }
MiExportBrowser >> addColumnForProperty: aFM3Property [
	self model addColumnForProperty: aFM3Property.
]

{ #category : #'columns management' }
MiExportBrowser >> addCommentsColumn [

	entitiesTable addColumn: ((SpStringTableColumn
			  title: self class commentColumnTitle
			  evaluated: [ :entity | self commentOf: entity ])
			 beEditable;
			 onAcceptEdition: [ :entity :comment | 
				 self model comment: entity with: comment ];
			 yourself).
	entitiesTable refresh
]

{ #category : #testing }
MiExportBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #'columns management' }
MiExportBrowser >> columnAdded: aColumn [

	"Update table recreate fully the table, we should be able to simply add the column"

	self updateTable
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

{ #category : #'columns management' }
MiExportBrowser >> columnRemoved: aColumn [

	"Update table recreate fully the table, we should be able to simply remove the column"

	self updateTable
]

{ #category : #accessing }
MiExportBrowser >> commentOf: anEntity [

	^ self model commentOf: anEntity
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

{ #category : #initialization }
MiExportBrowser >> customQueryButton [

	^ self newToolbarButton
		  label: 'Create custom column';
		  icon: (self iconNamed: #mooseEvaluator);
		  action: [ 
			  MiExportBrowserNewColumnPresenter new
				  exportModel: self model;
				  open ];
		  yourself
]

{ #category : #actions }
MiExportBrowser >> exportEntitiesToCSV [

	| file |
	file := UIManager default
		        chooseForSaveFileReference: 'Chose export destination'
		        extensions: #( 'csv' )
		        path: 'entities.csv'.
	file ifNotNil: [ 
		file writeStreamDo: [ :stream | self model writeCSVOn: stream ].
		UIManager default
			inform: 'Entities exported.
Click to show in folder'
			actionOnClick: [ file openInOSFileBrowser ] ]
]

{ #category : #actions }
MiExportBrowser >> followEntity: anEntity [

	| entities |
	entities := anEntity asMooseGroup.
	self updateEntitiesListWith: entities.
	entitiesCountLabel label:
		entities size asString , ' entit' , (entities size > 1
			 ifTrue: 'ies'
			 ifFalse: 'y').
]

{ #category : #initialization }
MiExportBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  add: toolbar expand: false;
					  add: entitiesCountLabel withConstraints: [ :consts | 
						  consts
							  bePlacedAtEnd;
							  expand: false ];
					  yourself)
			 height: self class toolbarHeight;
			 add: entitiesTable;
			 yourself)
]

{ #category : #initialization }
MiExportBrowser >> initializePresenters [

	entitiesCountLabel := self newLabel label: 'xxx'.
	self initializeToolbar.
	self initializeTable.
	self initializeLayout
]

{ #category : #initialization }
MiExportBrowser >> initializeTable [

	entitiesTable := self newTable beResizable.
]

{ #category : #initialization }
MiExportBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: self columnChoiceButton;
		           addItem: self customQueryButton;
		           addItem: self commentsButton;
		           addItem: (self newToolbarButton
				            label: 'Export to CSV';
				            icon: (self iconNamed: #smallExport);
				            action: [ self exportEntitiesToCSV ])
]

{ #category : #'event handling' }
MiExportBrowser >> listEntityChanged [

	self updateTable
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
		onActivation: [ :property | 
			self addColumn: property.
			self updateTable ];
		onDeactivation: [ :property | 
			self removeColumn: property.
			self updateTable ].

	list items: ((self miSelectedItem flatCollectAsSet: [ :entity | 
			  entity mooseDescription allPrimitiveProperties ])
		 , (self model columns reject: #isPropertyColumn) sorted:
			 [ :property | self showsProperty: property ] descending
			 , #name ascending).

	list selectItems:
		(list items select: [ :property | self showsProperty: property ]).

	^ list
]

{ #category : #'columns management' }
MiExportBrowser >> removeColumn: aColumn [

	(aColumn isKindOf: FM3Property)
		ifTrue: [ self model removeColumnForProperty: aColumn ]
		ifFalse: [ self model removeColumnForQueryNamed: aColumn name ]
]

{ #category : #'columns management' }
MiExportBrowser >> removeColumnForProperty: aFM3Property [
	self model removeColumnForProperty: aFM3Property.
]

{ #category : #'columns management' }
MiExportBrowser >> removeCommentsColumn [

	entitiesTable columns: (entitiesTable columns reject: [ :column | 
			 column title = self class commentColumnTitle ]).
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

	(self commonPropertiesIn: aMooseGroup) do: [ :property | 
		self addColumnForProperty: property ].
	self model entitiesList: aMooseGroup.
	self updateTable
]

{ #category : #'columns management' }
MiExportBrowser >> updateTable [

	entitiesTable columns: {  }.
	self model columns do: [ :columnModel | 
		entitiesTable addColumn: (SpStringTableColumn
				 title: columnModel name
				 evaluated: [ :entity | columnModel printValueFor: entity ])
				yourself ].
	entitiesTable items: self model entitiesList.
	

	self commentsAreShown ifTrue: [ self addCommentsColumn ].

	entitiesTable refresh
]
