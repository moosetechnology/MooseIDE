Class {
	#name : #MiReportBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'editor'
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
MiReportBrowser >> followEntity: aMooseModel [

	model followEntity: aMooseModel
]

{ #category : #accessing }
MiReportBrowser >> getText [
	^editor text
]

{ #category : #initialization }
MiReportBrowser >> initializeLayout [
	self layout: (SpBoxLayout newVertical
		add: #toolbar expand: false ;
		add: #editor ;
		yourself)
]

{ #category : #initialization }
MiReportBrowser >> initializePresenters [

	self initializeToolbar.

	editor := self newText.

	self initializeLayout
]

{ #category : #initialization }
MiReportBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: (self newToolbarButton
				            label: 'Preview';
				            icon: (self iconNamed: #smallExport);
				            action: [ model previewReport ]) ;
		           addItem: (self newToolbarButton
				            label: 'Export to text';
				            icon: (self iconNamed: #smallExport);
				            action: [ model exportToText ])
]

{ #category : #actions }
MiReportBrowser >> previewReport: reportContent [
	SpTextPresenter new
		beNotEditable ;
		text: (PRRichTextComposer microdownAsRichText: reportContent) ;
		openWithSpec.
]

{ #category : #actions }
MiReportBrowser >> reportExported: aFile [
	| msg |
	msg := 'Report exported.
Click to show in folder'.

	UIManager default
		inform: msg actionOnClick: [ aFile openInOSFileBrowser ]
]

{ #category : #initialization }
MiReportBrowser >> setModelBeforeInitialization: aModel [
	super setModelBeforeInitialization: aModel.
	aModel browser: self
]
