"
I am a moose notebook browser.
Accepted entities: any moose entity that knows its moose model.

There are two kind of cells:
 - Microdown cells.
 - Code cells.

You can switch a microdown cell to a code cell by clicking to its label (left). Same for the other way.

In microdown cells, you can write raw microdown.

In code cells you can script and write on a stream.
Code cells share an excution context, you can define variables in a code block and use it in following code cells.
Some globals are avalaible in all code cells:
 - mooseModel. The moose model you can query and acess.
 - stream. The stream you can write on.
 - printer. A printer with utility methods to print on the stream, see MiAbstractReportPrinter class.

When the notebook is executed, all cells are responsible to print there content in the stream. The order of cells is therfore important.
"
Class {
	#name : #MiNotebookBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'previewOpened',
		'showRawCheckbox',
		'closePreviewButton',
		'notebook',
		'notebookPreview',
		'mainLayout',
		'sep'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #'world menu' }
MiNotebookBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #Reporter)
		parent: #Moose;
		label: self title;
		icon: (self iconNamed: #smallExport);
		order: 6;
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'world menu' }
MiNotebookBrowser class >> menuItem [

	^ #reporteBuilder
]

{ #category : #'instance creation' }
MiNotebookBrowser class >> newModel [

	^ MiNotebookModel new
]

{ #category : #'instance creation' }
MiNotebookBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiNotebookBrowser class >> title [

	^ 'Notebook'
]

{ #category : #specs }
MiNotebookBrowser class >> windowSize [

	^ 1083 @ 697
]

{ #category : #initialization }
MiNotebookBrowser >> addCells [

	self updateModelCells.
	^ specModel executeAllCells
]

{ #category : #testing }
MiNotebookBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #actions }
MiNotebookBrowser >> chooseTextFile: messageString extensions: stringCollection path: defaultName [
	^UIManager default
		chooseForSaveFileReference: messageString 
		extensions: stringCollection 
		path: defaultName
]

{ #category : #initialization }
MiNotebookBrowser >> closePreview [

	previewOpened ifFalse: [ ^ self ].
	previewOpened := false.
	mainLayout remove: notebookPreview.
	notebook announceDisplayed
]

{ #category : #initialization }
MiNotebookBrowser >> columnChoiceButton [

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

{ #category : #initialization }
MiNotebookBrowser >> exportDocument [

	| aFile |
	self updateModelCells.
	specModel cellList ifEmpty: [ 
		self inform: 'Nothing to export'.
		^ self ].
	aFile := self
		         chooseTextFile: 'Chose export destination'
		         extensions: #( 'ston' )
		         path: 'mooseNotebook.ston'.
	aFile ifNotNil: [ specModel exportDocumentAt: aFile ]
]

{ #category : #actions }
MiNotebookBrowser >> exportToHTML [

	| aFile |
	self updateModelCells.
	specModel cellList ifEmpty: [ 
		self inform: 'Nothing to export'.
		^ self ].
	aFile := self
		         chooseTextFile: 'Chose export destination'
		         extensions: #( 'html' )
		         path: 'mooseNotebook.html'.
	aFile ifNil: [ ^ self ].
	specModel exportToHTMLAt: aFile.
	self reportExported: aFile
]

{ #category : #initialization }
MiNotebookBrowser >> exportToText [

	| aFile |
	self updateModelCells.
	specModel cellList ifEmpty: [ 
		self inform: 'Nothing to export'.
		^ self ].
	aFile := self
		         chooseTextFile: 'Chose export destination'
		         extensions: #( 'md' )
		         path: 'mooseNotebook.md'.
	aFile ifNotNil: [ specModel exportToTextAt: aFile ]
]

{ #category : #actions }
MiNotebookBrowser >> followEntity: anEntity [

	specModel followEntity: anEntity mooseModel.
	notebook mooseModel: anEntity mooseModel
]

{ #category : #initialization }
MiNotebookBrowser >> importMicrodownFile [

	| file |
	file := UIManager default
		chooseExistingFileReference: 'Select your notebook file.'
		extensions: { 'ston' }
		path: '.'.

	file ifNotNil: [ self updateWithFile: file ]
]

{ #category : #initialization }
MiNotebookBrowser >> initialize [

	super initialize.
	previewOpened := false
]

{ #category : #initialization }
MiNotebookBrowser >> initializeLayout [

	sep := self newRoassal.
	mainLayout := SpBoxLayout newLeftToRight
		              beHomogeneous;
		              spacing: 2;
		              add: notebook;
		              yourself.
	sep canvas color: Color gray translucent.
	self layout: (SpBoxLayout newTopToBottom
			 spacing: 1;
			 add: toolbar expand: false;
			 add: sep height: 1;
			 add: mainLayout;
			 yourself)
]

{ #category : #initialization }
MiNotebookBrowser >> initializePresenters [

	self initializeToolbar.
	self whenDisplayDo: [ 
		self window whenResizingDo: [ notebook updateHeight ] ].
	notebook := self instantiate: MiNoteBookReport.
	notebook browser: self.
	notebookPreview := self instantiate: MiNoteBookPreview.
	notebookPreview browser: self.
	showRawCheckbox := self newCheckBox
		                   label: 'Show source';
		                   state: false;
		                   yourself.
	closePreviewButton := self newButton
		                      label: 'Close preview';
		                      action: [ self closePreview ];
		                      yourself.
	self initializeLayout
]

{ #category : #initialization }
MiNotebookBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: (self newToolbarButton
				            label: 'Load file';
				            icon: (self iconNamed: #smallLoadProject);
				            action: [ self importMicrodownFile ];
				            yourself);
				addItem: (self newToolbarButton
				            label: 'Export document';
				            icon: (self iconNamed: #smallExport);
				            action: [ self exportDocument ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Preview';
				            icon: (self iconNamed: #smallExport);
				            action: [ self preview ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Export to text';
				            icon: (self iconNamed: #smallExport);
				            action: [ self exportToText ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Export to HTML';
				            icon: (self iconNamed: #smallExport);
				            action: [ self exportToHTML ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Add cell';
				            icon: (self iconNamed: #add);
				            action: [ notebook addTextCell ];
				            yourself);
		           yourself
]

{ #category : #actions }
MiNotebookBrowser >> miSelectedItem [

	^ specModel mooseModel
]

{ #category : #accessing }
MiNotebookBrowser >> mooseModel [

	^ specModel mooseModel
]

{ #category : #initialization }
MiNotebookBrowser >> openPreview [

	previewOpened ifTrue: [ ^ self ].
	previewOpened := true.
	mainLayout add: notebookPreview.
	notebook announceDisplayed.
	notebookPreview announceDisplayed.
	self announceDisplayed
]

{ #category : #initialization }
MiNotebookBrowser >> preview [

	self openPreview.
	self updateModelCells.

	notebookPreview
		updateWithStringCollection:
		self model executeAllCellsAsTextCollection
		andCells: notebook cellList
]

{ #category : #accessing }
MiNotebookBrowser >> previewOpened [

	^ previewOpened
]

{ #category : #actions }
MiNotebookBrowser >> reportExported: aFile [

	| msg |
	msg := 'Report exported.
Click to show in folder'.

	UIManager default
		inform: msg
		actionOnClick: [ aFile openInOSFileBrowser ]
]

{ #category : #accessing }
MiNotebookBrowser >> selectedEntities [

	^ specModel mooseModel
]

{ #category : #accessing }
MiNotebookBrowser >> sep [

	^ sep
]

{ #category : #initialization }
MiNotebookBrowser >> updateModelCells [

	specModel cellList: notebook allModelCells.
]

{ #category : #initialization }
MiNotebookBrowser >> updateWithFile: aFileReference [

	specModel importCellsFrom: aFileReference.
	self closePreview.
	notebook updateAll
]
