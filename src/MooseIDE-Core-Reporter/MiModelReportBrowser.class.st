"
Generates a statistical report on key features of a `MooseModel`
The report is generated in markdown and can be edited manually before being exported

Accepted entities: Any `MooseEntity` in a `MooseModel`
"
Class {
	#name : #MiModelReportBrowser,
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
MiModelReportBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiModelReportBrowser class >> menuItem [

	^#ModelReport
]

{ #category : #'world menu' }
MiModelReportBrowser class >> menuPriority [

	^ self menuMetaToolsPriority + 1
]

{ #category : #'world menu' }
MiModelReportBrowser class >> newModel [

	^ MiModelReportModel new
]

{ #category : #'world menu' }
MiModelReportBrowser class >> open [
	<script>
	^ super open
]

{ #category : #'world menu' }
MiModelReportBrowser class >> title [
	^ 'Model Report'
]

{ #category : #initialization }
MiModelReportBrowser >> btnToolbarRefresh [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Regenerate report';
		  action: [ specModel updateReport ];
		  yourself
]

{ #category : #testing }
MiModelReportBrowser >> canFollowEntity: anObject [
	"note: MooseModel-s have a #mooseModel also so the test accepts
	 any MooseModel or entity within a MooseModel"

	^anObject isMooseObject and: [ anObject mooseModel isNotEmpty ]
]

{ #category : #testing }
MiModelReportBrowser >> canPropagate [

	^ false
]

{ #category : #testing }
MiModelReportBrowser >> canTagEntities [

	^ false
]

{ #category : #layout }
MiModelReportBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #toolbar expand: false ;
		  add: #mainPresenter expand: true ;
		  yourself
]

{ #category : #actions }
MiModelReportBrowser >> exportReportToHTML [

	specModel exportReportToHTML: self rawReport
]

{ #category : #actions }
MiModelReportBrowser >> exportReportToPDF [

	specModel exportReportToPDF: self rawReport
]

{ #category : #actions }
MiModelReportBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #actions }
MiModelReportBrowser >> generatedReport: report [

	tabMicrodown text: report.

	(mainPresenter selectedPage activePresenter = tabPreview)
		ifTrue: [ self showingTab: mainPresenter selectedPage ]
]

{ #category : #accessing }
MiModelReportBrowser >> hasSettings [
	^ true
]

{ #category : #initialization }
MiModelReportBrowser >> initializeMainPresenter [

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
MiModelReportBrowser >> initializePresenters [

	self initializeToolbar.
	self initializeMainPresenter
]

{ #category : #initialization }
MiModelReportBrowser >> initializeToolbar [

	toolbar := self newToolbar
		beIcons;

		fillWith: (MiReportExportCommand asCommandGroupWith: self);
		addItem: self btnToolbarRefresh;

		yourself
]

{ #category : #accessing }
MiModelReportBrowser >> miSelectedItem [

	^#()
]

{ #category : #accessing }
MiModelReportBrowser >> rawReport [

	^ tabMicrodown text
]

{ #category : #initialization }
MiModelReportBrowser >> saveRawReport [

	specModel saveRawReport: self rawReport
]

{ #category : #actions }
MiModelReportBrowser >> showingTab: newTab [

	(newTab activePresenter = tabPreview and: [ rebuildPreview ])
		ifFalse: [ ^ self ].

	tabPreview documentFromString: self rawReport.
	rebuildPreview := false
]
