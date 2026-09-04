"
I am the entry point of the Github importer UI (see MiGithubImporter), inspired by the Software Heritage importer.

The user enters a part of the name of an organization and/or a part of a project name and I list the matching Github repositories in the top table (see MiGithubRepository class>>searchRepositoriesNamed:organization:).
When the user selects a repository I check that the project is written in Java (if not I inform the user that it is not supported yet), fetch its available versions and display them with checkboxes in the bottom table (see MiGithubTargetSelectionPresenter) so that the user selects the versions to download and import.

I can be opened:
- from the ""Import"" toolbar of the models browser through MiImportFromGithubCommand
- from the Moose world menu entry ""Github Importer""
"
Class {
	#name : 'MiGithubImportPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'organizationInput',
		'repositoryNameInput',
		'searchButton',
		'tokenButton',
		'repositoriesTable',
		'versionsLabel',
		'versionsPresenter'
	],
	#category : 'MooseIDE-Github-Importer-UI',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'UI'
}

{ #category : 'opening' }
MiGithubImportPresenter class >> open [

	<script>
	^ self new
		  openDialog;
		  yourself
]

{ #category : 'specs' }
MiGithubImportPresenter class >> title [

	^ 'Github Importer'
]

{ #category : 'action' }
MiGithubImportPresenter >> clearVersions [

	versionsPresenter
		repository: nil;
		versions: #(  )
]

{ #category : 'layout' }
MiGithubImportPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: organizationInput;
				   add: repositoryNameInput;
				   add: searchButton expand: false;
				   add: tokenButton expand: false;
				   yourself)
		  expand: false;
		  add: repositoriesTable;
		  add: versionsLabel expand: false;
		  add: versionsPresenter;
		  yourself
]

{ #category : 'accessing' }
MiGithubImportPresenter >> fetchVersionsButton [
	^ fetchVersionsButton
]

{ #category : 'initialization' }
MiGithubImportPresenter >> initializePresenters [

	super initializePresenters.
	organizationInput := self newTextInput
		                     placeholder: 'organization, e.g. moosetechnology';
		                     whenSubmitDo: [ :inputText | self searchRepositories ];
		                     yourself.
	repositoryNameInput := self newTextInput
		                       placeholder: 'project name, e.g. MooseIDE';
		                       whenSubmitDo: [ :inputText | self searchRepositories ];
		                       yourself.
	searchButton := self newButton
		                label: 'Search';
		                icon: (self iconNamed: #smallFind);
		                action: [ self searchRepositories ];
		                yourself.
	tokenButton := self newButton
		               label: 'Github token...';
		               icon: (self iconNamed: #github);
		               help:
			               'Store a Github personal access token to authenticate the requests and raise the rate limit from 60 to 5000 requests per hour. Note: the Iceberg credential store keeps one credential per host, storing a token replaces the github.com credential.';
		               action: [ self openTokenDialog ];
		               yourself.
	repositoriesTable := self newTable
		                     addColumn: (SpStringTableColumn title: 'Repository' evaluated: [ :item | (item at: 'full_name' ifAbsent: [ '' ]) ifNil: [ '' ] ]);
		                     addColumn: (SpStringTableColumn title: 'Language' evaluated: [ :item | (item at: 'language' ifAbsent: [ '' ]) ifNil: [ '' ] ]);
		                     addColumn: (SpStringTableColumn title: 'Description' evaluated: [ :item | (item at: 'description' ifAbsent: [ '' ]) ifNil: [ '' ] ]);
		                     items: #(  );
		                     whenSelectionChangedDo: [ :selection |
				                     selection isEmpty
					                     ifTrue: [ self clearVersions ]
					                     ifFalse: [ self loadVersionsForSelectedRepository ] ];
		                     yourself.
	versionsLabel := self newLabel label: 'Versions of the selected project'.
	versionsPresenter := self instantiate: MiGithubTargetSelectionPresenter
]

{ #category : 'initialization' }
MiGithubImportPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self class title.
	aWindowPresenter initialExtent: 600 @ 700
]

{ #category : 'action' }
MiGithubImportPresenter >> loadVersionsForSelectedRepository [

	| repository |
	repository := MiGithubRepository fromFullName: (repositoriesTable selection selectedItem at: 'full_name').
	[ self showVersionsFor: repository ]
		on: IceGitHubError
		do: [ :error |
				UIManager default alert: 'Cannot access the Github repository: ' , error messageText.
				self clearVersions ]
]

{ #category : 'world menu' }
MiGithubImportPresenter >> menuCommandOn: aBuilder [

	<worldMenu>
	^ aBuilder
		  item: #MooseGithubImporter;
		  parent: #Moose;
		  label: self title;
		  icon: (Smalltalk ui icons iconNamed: #github);
		  help: 'Import the sources of versions of a Github project and create Famix models from them (Java only for now)';
		  action: [ self open ];
		  yourself
]

{ #category : 'action' }
MiGithubImportPresenter >> openTokenDialog [

	MiGithubTokenPresenter new openDialog centeredRelativeTo: self window
]

{ #category : 'accessing' }
MiGithubImportPresenter >> organizationInput [
	^ organizationInput
]

{ #category : 'accessing' }
MiGithubImportPresenter >> repositoriesTable [
	^ repositoriesTable
]

{ #category : 'accessing' }
MiGithubImportPresenter >> repositoryNameInput [
	^ repositoryNameInput
]

{ #category : 'action' }
MiGithubImportPresenter >> searchRepositories [

	| searchResults |
	(organizationInput text isEmpty and: [ repositoryNameInput text isEmpty ]) ifTrue: [
			UIManager default alert: 'Enter at least a part of the organization or of the project name.'.
			^ self ].
	[
		searchResults := MiGithubRepository searchRepositoriesNamed: repositoryNameInput text organization: organizationInput text.
		searchResults ifEmpty: [
				UIManager default alert: 'No repository found for this search.'.
				^ self ].
		repositoriesTable items: searchResults ]
		on: IceGitHubError
		do: [ :error | UIManager default alert: 'Cannot search on Github: ' , error messageText ]
]

{ #category : 'action' }
MiGithubImportPresenter >> showVersionsFor: aRepository [

	| primaryLanguage |
	primaryLanguage := aRepository primaryLanguage.
	(MiGithubImporter isLanguageSupported: primaryLanguage) ifFalse: [
			UIManager default alert: ('The project "{1}" is written in {2}. Only Java projects are supported for now.' format: {
						 aRepository projectName.
						 (primaryLanguage ifNil: [ 'an unknown language' ]) }).
			^ self clearVersions ].
	versionsPresenter
		repository: aRepository;
		versions: aRepository availableVersions
]

{ #category : 'accessing' }
MiGithubImportPresenter >> versionsPresenter [
	^ versionsPresenter
]
