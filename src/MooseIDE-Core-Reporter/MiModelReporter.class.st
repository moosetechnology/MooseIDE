"
Generates a statistical report on key features of a Moose model
The report is generated in markdown and can be edited manually before being exported

Accepted entities: A mooseModel
"
Class {
	#name : #MiModelReporter,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter',
		'toolbar',
		'tabPreview',
		'tabMicrodown',
		'rebuildPreview'
	],
	#category : #'MooseIDE-Core-Reporter'
}

{ #category : #'world menu' }
MiModelReporter class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiModelReporter class >> menuItem [

	^#ModelReporter
]

{ #category : #'world menu' }
MiModelReporter class >> menuPriority [

	^ self menuMetaToolsPriority + 1
]

{ #category : #'world menu' }
MiModelReporter class >> newModel [

	^ MiModelReporterModel new
]

{ #category : #'world menu' }
MiModelReporter class >> open [
	<script>
	^ super open
]

{ #category : #'world menu' }
MiModelReporter class >> title [
	^ 'Model Reporter'
]

{ #category : #testing }
MiModelReporter >> canFollowEntity: anObject [

	^anObject ifNil: [ false ] ifNotNil: [ anObject isMooseModel ]
]

{ #category : #testing }
MiModelReporter >> canPropagate [

	^ false
]

{ #category : #testing }
MiModelReporter >> canTagEntities [

	^ false
]

{ #category : #layout }
MiModelReporter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #toolbar expand: false ;
		  add: #mainPresenter expand: true ;
		  yourself
]

{ #category : #actions }
MiModelReporter >> exportReportToHTML [

	specModel exportReportToHTML: self rawReport
]

{ #category : #actions }
MiModelReporter >> exportReportToPDF [

	specModel exportReportToPDF: self rawReport
]

{ #category : #actions }
MiModelReporter >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #actions }
MiModelReporter >> generatedReport: report [

	tabMicrodown text: report
]

{ #category : #accessing }
MiModelReporter >> hasSettings [
	^ true
]

{ #category : #initialization }
MiModelReporter >> initializeMainPresenter [

	tabMicrodown := SpTextPresenter new
		whenTextChangedDo: [ rebuildPreview := true ].
	tabPreview := MicrodownPresenter new.

	mainPresenter := self newNotebook.
	mainPresenter whenSelectedPageChangedDo: [ :new :old |
		self showingTab: new].

	mainPresenter addPageTitle: 'Raw report' provider: [ tabMicrodown ].
	mainPresenter addPageTitle: 'Preview' provider: [ tabPreview ].
]

{ #category : #initialization }
MiModelReporter >> initializePresenters [

	toolbar := self newToolbar
		fillWith: (MiReportExportCommand asCommandGroupWith: self);
		beIcons;
		addItem: self refreshToolbarButton;
		yourself.

	self initializeMainPresenter
]

{ #category : #initialization }
MiModelReporter >> initializeToolbar [

	toolbar := self newToolbar
		           fillWith:
			           (MiReportExportCommand asCommandGroupWith: self);
		           beIcons;
		           addItem: self refreshToolbarButton;
		           yourself
]

{ #category : #accessing }
MiModelReporter >> miSelectedItem [

	^#()
]

{ #category : #accessing }
MiModelReporter >> rawReport [

	^ tabMicrodown text
]

{ #category : #initialization }
MiModelReporter >> refreshToolbarButton [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Reset report';
		  action: [ specModel updateReport ];
		  yourself
]

{ #category : #actions }
MiModelReporter >> showingTab: newTab [

	(newTab activePresenter = tabPreview and: [ rebuildPreview ])
		ifFalse: [ ^ self ].

	tabPreview documentFromString: self rawReport.
	rebuildPreview := false
]
