"
I am the bottom panel of the Github importer window (see MiGithubImportPresenter): I display the versions (tags, branches, releases and pull requests) of the Github repository selected by the user (see MiGithubRepository) and I let the user select one or more of them with checkboxes. The import itself is triggered by MiGithubImportPresenter which reads my #selectedVersions.

Setting a new list of versions with #versions: resets the checked versions since they belong to the previously selected project.
"
Class {
	#name : 'MiGithubTargetSelectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'repository',
		'versionsTable',
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
		  yourself
]

{ #category : 'initialization' }
MiGithubTargetSelectionPresenter >> initialize [

	super initialize.
	selectedVersions := OrderedCollection new
]

{ #category : 'initialization' }
MiGithubTargetSelectionPresenter >> initializePresenters [

	super initializePresenters.
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
		                 items: OrderedCollection new;
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

	^ versionsTable items
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> versions: aCollection [

	versionsTable ifNotNil: [ versionsTable items: aCollection ].
	selectedVersions := OrderedCollection new
]

{ #category : 'accessing' }
MiGithubTargetSelectionPresenter >> versionsTable [
	^ versionsTable
]
