"
I am the bottom panel of the Github importer window (see MiGithubImportPresenter): I display the versions (tags, branches, releases and pull requests) of the Github repository selected by the user (see MiGithubRepository) and I let the user select one or more of them with checkboxes to download their sources and import them as models (see MiGithubImporter).

Setting a new list of versions with #versions: resets the checked versions since they belong to the previously selected project.
"
Class {
	#name : 'MiGithubTargetSelectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'repository',
		'versions',
		'versionsTable',
		'importButton',
		'selectedVersions'
	],
	#category : 'MooseIDE-Github-Importer-UI',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'UI'
}

{ #category : 'action' }
MiGithubTargetSelectionPresenter >> clearVersions [

	self
		repository: nil;
		versions: #(  )
]

{ #category : 'layout' }
MiGithubTargetSelectionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: versionsTable;
		  add: importButton expand: false;
		  yourself
]

{ #category : 'action' }
MiGithubTargetSelectionPresenter >> importSelectedVersions [

	selectedVersions ifEmpty: [
			UIManager default alert: 'Select at least one version to import.'.
			^ self ].
	[
		[ MiGithubImporter downloadAndImport: selectedVersions copy from: repository ]
			on: Error
			do: [ :error | UIManager default alert: 'Import failed: ' , error messageText ] ] forkAt: Processor userBackgroundPriority
]

{ #category : 'initialization' }
MiGithubTargetSelectionPresenter >> initializePresenters [

	super initializePresenters.
	versions := OrderedCollection new.
	selectedVersions := OrderedCollection new.
	versionsTable := self newTable
		                 addColumn: ((SpCheckBoxTableColumn evaluated: [ :aVersion | selectedVersions includes: aVersion ])
				                  onActivation: [ :aVersion | selectedVersions add: aVersion ];
				                  onDeactivation: [ :aVersion | selectedVersions remove: aVersion ];
				                  width: 20);
		                 addColumn: (SpImageTableColumn new
				                  evaluated: [ :aVersion | self iconNamed: aVersion iconName ];
				                  beNotExpandable;
				                  width: 20;
				                  yourself);
		                 addColumn: ((SpStringTableColumn title: 'Kind' evaluated: [ :aVersion | aVersion kind asString ])
				                  width: 100;
				                  yourself);
		                 addColumn: (SpStringTableColumn title: 'Name' evaluated: #displayName);
		                 items: versions;
		                 yourself.
	importButton := self newButton
		                label: 'Download and import';
		                icon: (self iconNamed: #smallImport);
		                action: [ self importSelectedVersions ];
		                yourself
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> repository [

	^ repository
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> repository: anObject [

	repository := anObject
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> selectedVersions [
	^ selectedVersions
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> versions [

	^ versions
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> versions: aCollection [

	versions := aCollection.
	"The checked versions belong to the previously selected project, I reset them."
	selectedVersions := OrderedCollection new.
	versionsTable ifNotNil: [ versionsTable items: versions ]
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> versionsTable [
	^ versionsTable
]
