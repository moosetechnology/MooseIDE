Class {
	#name : #MiExportBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'entitiesList',
		'toolbar',
		'commentDictionary'
	],
	#category : #'Midas-Export-Browser'
}

{ #category : #actions }
MiExportBrowser class >> commentColumnTitle [

	^ 'Comment'
]

{ #category : #specs }
MiExportBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #toolbar height: self toolbarHeight;
		  add: #entitiesList;
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
		order: 5;
		withSeparatorAfter;
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'instance creation' }
MiExportBrowser class >> runMe [

	<script>
	^ super runMe
]

{ #category : #specs }
MiExportBrowser class >> title [

	^ 'Entities exporter'
]

{ #category : #actions }
MiExportBrowser >> addCommentsColumn [

	entitiesList addColumn: ((SpStringTableColumn
			  title: self class commentColumnTitle
			  evaluated: [ :entity | self commentOf: entity ])
			 beEditable;
			 onAcceptEdition: [ :entity :comment | 
				 commentDictionary at: entity put: comment ];
			 yourself)
]

{ #category : #actions }
MiExportBrowser >> commentOf: anEntity [

	^ commentDictionary at: anEntity ifAbsent: ''
]

{ #category : #actions }
MiExportBrowser >> exportEntitiesToCSV [

	| file |
	file := UIManager default
		        chooseForSaveFileReference: 'Chose export destination'
		        extensions: #( 'csv' )
		        path: 'entities.csv'.
	file ifNotNil: [ 
		file writeStreamDo: [ :stream | entitiesList asCSVOn: stream ].
		UIManager default
			inform: 'Entities exported.
Click to show in folder'
			actionOnClick: [ file openInOSFileBrowser ] ]
]

{ #category : #actions }
MiExportBrowser >> followAction [

	entitiesList items: toSelect asMooseGroup.
	commentDictionary := Dictionary new
]

{ #category : #initialization }
MiExportBrowser >> initializePresenters [

	super initializePresenters.
	self initializeToolbar.
	self initializeTable
]

{ #category : #initialization }
MiExportBrowser >> initializeTable [

	entitiesList := self newTable
		                addColumn:
			                (SpStringTableColumn title: 'Name' evaluated: #name)
				                beSortable;
		                addColumn: (SpStringTableColumn
				                 title: 'Type'
				                 evaluated: [ :entity | 
					                 entity mooseDescription name ]) beSortable;
		                yourself
]

{ #category : #initialization }
MiExportBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: (self newToolbarButton
				            label: 'Export to CSV';
				            icon: (UITheme iconNamed: #smallExport);
				            action: [ self exportEntitiesToCSV ]);
		           addItem: (self newToolbarToggleButton
				            label: 'Toggle comments';
				            icon: (UITheme iconNamed: #edit);
				            action: [ :state :button |  ];
				            whenSelectedDo: [ self addCommentsColumn ];
				            whenUnselectedDo: [ self removeCommentsColumn ])
]

{ #category : #accessing }
MiExportBrowser >> miSelectedItem [

	^ entitiesList items
]

{ #category : #actions }
MiExportBrowser >> removeCommentsColumn [

	entitiesList columns: (entitiesList columns reject: [ :column | 
			 column title = self class commentColumnTitle ])
]
