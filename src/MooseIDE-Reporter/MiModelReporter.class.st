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
		'toolbar'
	],
	#category : #'MooseIDE-Reporter'
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

{ #category : #exporting }
MiModelReporter >> exportReportToHTML [

	specModel exportReportToHTML: mainPresenter text
]

{ #category : #exporting }
MiModelReporter >> exportReportToPDF [

	specModel exportReportToPDF: mainPresenter text
]

{ #category : #actions }
MiModelReporter >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #exporting }
MiModelReporter >> formattedReport: formattedReport [
]

{ #category : #testing }
MiModelReporter >> hasSettings [
	^ true
]

{ #category : #testing }
MiModelReporter >> initializePresenters [

	toolbar := self newToolbar
		fillWith: (MiReportExportCommand asCommandGroupWith: self);
		beIcons;
		addItem: self refreshToolbarButton;
		yourself.

	mainPresenter := self newText
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

{ #category : #testing }
MiModelReporter >> miSelectedItem [

	^#()
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
MiModelReporter >> updateReport: report [

	mainPresenter text: report
]
