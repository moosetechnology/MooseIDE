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

{ #category : #'as yet unclassified' }
MiModelReporter >> exportReportToHTML [

	specModel exportReportToHTML: mainPresenter text
]

{ #category : #'as yet unclassified' }
MiModelReporter >> exportReportToPDF [

	specModel exportReportToPDF: mainPresenter text
]

{ #category : #testing }
MiModelReporter >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #'as yet unclassified' }
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
		  help: 'Refresh list';
		  action: [ self updateList ];
		  yourself
]

{ #category : #actions }
MiModelReporter >> updateReport: report [

	mainPresenter text: report
]
