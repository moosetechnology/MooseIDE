"
I am the entry point of the Github importer UI (see `MiGithubImporter`).

The user enters a part of the name of an organization and/or a part of a project name and I list the matching Github repositories in the top table (see `MiGithubRepository class>>searchRepositoriesNamed:organization:` ).
When the user selects a repository I check that the project is written in Java (if not I inform the user that it is not supported yet), fetch its available versions and display them with checkboxes in the bottom table (see `MiGithubTargetSelectionPresenter`) so that the user selects the versions to download and import.

I can be opened:
- from the ""Import"" toolbar of the models browser through `MiImportFromGithubCommand`
- from the Moose world menu entry ""Github Importer""
"
Class {
	#name : 'MiGithubImportPresenter',
	#superclass : 'MiImportModelDialog',
	#instVars : [
		'organizationInput',
		'repositoryNameInput',
		'searchButton',
		'tokenButton',
		'repositoriesTable',
		'versionsPresenter'
	],
	#category : 'MooseIDE-Github-Importer-UI',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'UI'
}

{ #category : 'world menu' }
MiGithubImportPresenter class >> menuCommandOn: aBuilder [

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

{ #category : 'specs' }
MiGithubImportPresenter class >> title [

	^ 'Github Importer'
]

{ #category : 'specs' }
MiGithubImportPresenter class >> windowExtent [

	^ 600 @ 700
]

{ #category : 'action' }
MiGithubImportPresenter >> clearVersions [

	versionsPresenter clearVersions
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
		  add: 'Versions of the selected project' expand: false;
		  add: versionsPresenter;
		  yourself
]

{ #category : 'action' }
MiGithubImportPresenter >> importModel [
	"Like MiImportModelFromFoldersDialog, I import several models: the check that they are not empty is adapted from MiImportModelDialog>>importModel for a single model."

	| mooseModelsWrapper |
	mooseModelsWrapper := self privateImportModel.
	mooseModelsWrapper models do: [ :each |
		(each size - (each allUsing: FamixTSourceLanguage) size) isZero ifTrue: [ self error: 'Something is wrong, the imported model appears to be empty' ] ].
	^ mooseModelsWrapper
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
		                     whenSelectionChangedDo: [ :selection |
				                     selection isEmpty
					                     ifTrue: [ self clearVersions ]
					                     ifFalse: [ self loadVersionsForSelectedRepository ] ];
		                     yourself.
	versionsPresenter := self instantiate: MiGithubTargetSelectionPresenter
]

{ #category : 'action' }
MiGithubImportPresenter >> loadVersionsForSelectedRepository [

	| repository |
	repository := MiGithubRepository fromFullName: (repositoriesTable selection selectedItem at: 'full_name').
	[ self showVersionsFor: repository ]
		on: IceGitHubError
		do: [ :error |
				self alert: 'Cannot access the Github repository: ' , error messageText.
				self clearVersions ]
]

{ #category : 'action' }
MiGithubImportPresenter >> openTokenDialog [

	MiGithubTokenPresenter new openDialog centeredRelativeTo: self window
]

{ #category : 'accessing' }
MiGithubImportPresenter >> organizationInput [
	^ organizationInput
]

{ #category : 'action' }
MiGithubImportPresenter >> privateImportModel [
	"I download the sources of the selected versions and parse them into models."

	^ MiMooseModelsWrapper models: (MiGithubImporter downloadAndImport: versionsPresenter selectedVersions from: versionsPresenter repository)
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

	(organizationInput text isEmpty and: [ repositoryNameInput text isEmpty ]) ifTrue: [
			self alert: 'Enter at least a part of the organization or of the project name.'.
			^ self ].

	[
		(MiGithubRepository searchRepositoriesNamed: repositoryNameInput text trim organization: organizationInput text trim)
			ifEmpty: [
					self alert: 'No repository found for this search.'.
					^ self ]
			ifNotEmpty: [ :searchResults | repositoriesTable items: searchResults ] ]
		on: IceGitHubError
		do: [ :error | self alert: 'Cannot search on Github: ' , error messageText ]
]

{ #category : 'action' }
MiGithubImportPresenter >> shouldCreateCache [
	"The models browser can be absent (dialog opened from the world menu), in that case I use the default."

	self application currentModelsBrowser ifNil: [ ^ true ].
	^ super shouldCreateCache
]

{ #category : 'action' }
MiGithubImportPresenter >> showVersionsFor: aRepository [

	(MiGithubImporter isLanguageSupported: aRepository primaryLanguage) ifFalse: [
			self alert: ('The project "{1}" is written in {2}. Only Java projects are supported for now.' format: {
						 aRepository projectName.
						 (aRepository primaryLanguage ifNil: [ 'an unknown language' ]) }).
			^ self clearVersions ].

	versionsPresenter
		repository: aRepository;
		versions: aRepository availableVersions
]

{ #category : 'action' }
MiGithubImportPresenter >> validateImportForm [

	versionsPresenter selectedVersions ifEmpty: [ self error: 'Please select at least one version to import.' ]
]

{ #category : 'accessing' }
MiGithubImportPresenter >> versionsPresenter [
	^ versionsPresenter
]
