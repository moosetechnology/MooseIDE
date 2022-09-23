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
		'closePreviewButton'
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
	self layout replaceAtIndex: 2 with: editor
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

{ #category : #actions }
MiReportBrowser >> followEntity: anEntity [

	model followEntity: anEntity mooseModel
]

{ #category : #accessing }
MiReportBrowser >> getText [
	^editor text
]

{ #category : #initialization }
MiReportBrowser >> importMicrodownFile [

	| file |
	file := UIManager default
		chooseExistingFileReference: 'Select your a Microdown file.'
		extensions: { 'md' }
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

	self layout: (SpBoxLayout newTopToBottom
			 add: toolbar expand: false;
			 add: editor;
			 yourself)
]

{ #category : #initialization }
MiReportBrowser >> initializePresenters [

	self initializeToolbar.

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
				            action: [ self openPreview ];
				            yourself);
		           addItem: (self newToolbarButton
				            label: 'Export to text';
				            icon: (self iconNamed: #smallExport);
				            action: [ model exportToText ];
				            yourself);
				addItem: (self newToolbarButton
				            label: 'Export to HTML';
				            icon: (self iconNamed: #smallExport);
				            action: [ model exportToHTML ];
				            yourself)
]

{ #category : #actions }
MiReportBrowser >> miSelectedItem [

	^ model mooseModel
]

{ #category : #initialization }
MiReportBrowser >> openPreview [

	previewOpened ifTrue: [ 
	model generateMicrodown.
	^ self ].
	previewOpened := true.
	self layout replaceAtIndex: 2 with: (SpPresenter new
			 layout: (SpPanedLayout newLeftToRight
					  add: editor;
					  add: (SpBoxLayout newTopToBottom
							   add: renderer;
							   add: (SpBoxLayout newLeftToRight
									    add: showRawCheckbox;
									    add: closePreviewButton;
									    yourself)
							   expand: false;
							   yourself);
					  yourself);
			 yourself).
	model generateMicrodown
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

{ #category : #initialization }
MiReportBrowser >> setModelBeforeInitialization: aModel [
	super setModelBeforeInitialization: aModel.
	aModel browser: self
]

{ #category : #actions }
MiReportBrowser >> settings [
	
	
]

{ #category : #initialization }
MiReportBrowser >> updateWithFile: aFileReference [

	editor text: aFileReference contents
]
