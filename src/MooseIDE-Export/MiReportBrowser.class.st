"
I am a report browser. I use microdown in order to generate documents from a moose model.
I accept any moose entity and get a moose model from it.

I am a microdown editor, the specific thing is that pharo code can be executed (in a code block). This microdown code is evaluated to produce an other microdown document.




A code block exemple:
```
 ```eval=true
	printer print: entities allModelMethods
 ```
```
This will print a microdown list of all model methods.

Code blocks share an environement, an instance of MiCodeEvaluatorEnv is the receiver of these blocks. Global variables can be setted using setGlobal of MicodeEvaluatorEnv. Methods of this class are available in code blocks.
"
Class {
	#name : #MiReportBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'editor',
		'renderer',
		'previewOpened',
		'showRawCheckbox',
		'closePreviewButton',
		'notebook',
		'notebookPreview',
		'mainLayout',
		'sep'
	],
	#category : #'MooseIDE-Export-Report'
}

{ #category : #'world menu' }
MiReportBrowser class >> menuCommandOn: aBuilder [

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
MiReportBrowser class >> menuItem [

	^ #reporteBuilder
]

{ #category : #'instance creation' }
MiReportBrowser class >> newModel [

	^ MiReportModel new
]

{ #category : #'instance creation' }
MiReportBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiReportBrowser class >> title [

	^ 'Report builder'
]

{ #category : #initialization }
MiReportBrowser >> addCells [

	self updateModelCells.
	^ model executeAllCells
]

{ #category : #testing }
MiReportBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #actions }
MiReportBrowser >> chooseTextFile: messageString extensions: stringCollection path: defaultName [
	^UIManager default
		chooseForSaveFileReference: messageString 
		extensions: stringCollection 
		path: defaultName
]

{ #category : #initialization }
MiReportBrowser >> closePreview [

	previewOpened ifFalse: [ ^ self ].
	previewOpened := false.
	mainLayout remove: notebookPreview.
	notebook announceDisplayed
]

{ #category : #initialization }
MiReportBrowser >> columnChoiceButton [

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
MiReportBrowser >> exportToText [

	self updateModelCells.
	model exportToText
]

{ #category : #actions }
MiReportBrowser >> followEntity: anEntity [

	model followEntity: anEntity mooseModel.
	notebook mooseModel: anEntity mooseModel
]

{ #category : #accessing }
MiReportBrowser >> getText [
	^editor text
]

{ #category : #initialization }
MiReportBrowser >> importMicrodownFile [

	| file |
	file := UIManager default
		chooseExistingFileReference: 'Select your notebook file.'
		extensions: { 'ston' }
		path: '.'.

	file ifNotNil: [ self updateWithFile: file ]
]

{ #category : #initialization }
MiReportBrowser >> initialize [

	super initialize.
	previewOpened := false
]

{ #category : #initialization }
MiReportBrowser >> initializeLayout [

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
MiReportBrowser >> initializePresenters [

	self initializeToolbar.
	self whenDisplayDo: [ 
		self window whenResizingDo: [ notebook updateHeight ] ].
	notebook := self instantiate: MiNoteBookReport.
	notebook browser: self.
	notebookPreview := self instantiate: MiNoteBookPreview.
	notebookPreview browser: self.
	renderer := self newText
		            beNotEditable;
		            yourself.
	editor := self newCode
		          withoutSyntaxHighlight;
		          yourself.
	editor
		whenSubmitDo: [ :txt | model generateMicrodown ];
		whenTextChangedDo: [ :txt | model sourceText: txt ].
	showRawCheckbox := self newCheckBox
		                   label: 'Show source';
		                   state: false;
		                   whenChangedDo: [ self renderText ];
		                   yourself.
	closePreviewButton := self newButton
		                      label: 'Close preview';
		                      action: [ self closePreview ];
		                      yourself.
	self initializeLayout
]

{ #category : #initialization }
MiReportBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: (self newToolbarButton
				            label: 'Load file';
				            icon: (self iconNamed: #smallLoadProject);
				            action: [ self importMicrodownFile ];
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
				            action: [ model exportToHTML ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Add cell';
				            icon: (self iconNamed: #add);
				            action: [ notebook addTextCell ];
				            yourself);
		           yourself
]

{ #category : #initialization }
MiReportBrowser >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.
	aMiWindowPresenter initialExtent: 1083.0 @ 697.0
]

{ #category : #actions }
MiReportBrowser >> miSelectedItem [

	^ model mooseModel
]

{ #category : #accessing }
MiReportBrowser >> mooseModel [

	^ model mooseModel
]

{ #category : #initialization }
MiReportBrowser >> openPreview [

	previewOpened ifTrue: [ ^ self ].
	previewOpened := true.
	mainLayout add: notebookPreview.
	notebook announceDisplayed.
	notebookPreview announceDisplayed.
	self announceDisplayed
]

{ #category : #initialization }
MiReportBrowser >> preview [

	self openPreview.
	self updateModelCells.

	notebookPreview
		updateWithStringCollection:
		self model executeAllCellsAsTextCollection
		andCells: notebook cellList
]

{ #category : #accessing }
MiReportBrowser >> previewOpened [

	^ previewOpened
]

{ #category : #rendering }
MiReportBrowser >> renderText [

	renderer text: (showRawCheckbox state
			 ifTrue: [ model textEdited ]
			 ifFalse: [ Microdown asRichText: model micDocument ])
]

{ #category : #actions }
MiReportBrowser >> reportExported: aFile [
	| msg |
	msg := 'Report exported.
Click to show in folder'.

	UIManager default
		inform: msg actionOnClick: [ aFile openInOSFileBrowser ]
]

{ #category : #accessing }
MiReportBrowser >> selectedEntities [

	^ model mooseModel
]

{ #category : #accessing }
MiReportBrowser >> sep [

	^ sep
]

{ #category : #initialization }
MiReportBrowser >> setModelBeforeInitialization: aBrowserModel [
	aBrowserModel ifNil: [ ^self ].

	model := aBrowserModel.
]

{ #category : #actions }
MiReportBrowser >> settings [
	
	
]

{ #category : #initialization }
MiReportBrowser >> updateModelCells [

	model cellList: notebook allModelCells.
]

{ #category : #initialization }
MiReportBrowser >> updateWithFile: aFileReference [

	model importCellsFrom: aFileReference.
	notebook updateAll.
]
