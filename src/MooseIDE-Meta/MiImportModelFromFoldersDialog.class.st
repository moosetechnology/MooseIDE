"
I am a presenter that will allow the user to select one or multiple folders and that will generate a json file for each one. Then I'll import those files in the model browser.

For now, I only work with Java and the latest version of VerveineJ. In the future we could add other languages.
"
Class {
	#name : #MiImportModelFromFoldersDialog,
	#superclass : #MiImportModelDialog,
	#instVars : [
		'description',
		'foldersList',
		'addFolderButton',
		'addFoldersButton'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #opening }
MiImportModelFromFoldersDialog class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiImportModelFromFoldersDialog class >> title [

	^ 'Parse and import models from folders'
]

{ #category : #accessing }
MiImportModelFromFoldersDialog class >> windowExtent [

	^ 600 @ 500
]

{ #category : #initialization }
MiImportModelFromFoldersDialog >> connectPresenters [

	super connectPresenters.
	self flag: #todo. "In the future UIManager should be removed to use the spec selection tool but it is not possible since we still run on Pharo 11"
	addFolderButton action: [
		(UIManager default chooseDirectory: 'Select a project folder to add.') ifNotNil: [ :folder |
			foldersList items add: folder.
			foldersList refresh ] ].
	addFoldersButton action: [
		(UIManager default chooseDirectory: 'Select a folder contaninig only project folders to add.') ifNotNil: [ :folder |
			foldersList items addAll: folder directories.
			foldersList refresh ] ]
]

{ #category : #layout }
MiImportModelFromFoldersDialog >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 3;
		  add: description;
		  add: foldersList;
		  add: (SpBoxLayout newLeftToRight
				   add: addFolderButton expand: false;
				   add: addFoldersButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #action }
MiImportModelFromFoldersDialog >> importModel [

	^ self privateImportModel
]

{ #category : #initialization }
MiImportModelFromFoldersDialog >> initializePresenters [

	super initializePresenters.
	description := self newText.
	foldersList := self newList.
	addFolderButton := self newButton.
	addFoldersButton := self newButton.

	description
		text: self userDescription;
		beNotEditable.

	foldersList items: OrderedCollection new.

	addFolderButton
		label: 'Add Folder';
		iconName: #add.
	addFoldersButton
		label: 'Add Folders';
		iconName: #add
]

{ #category : #action }
MiImportModelFromFoldersDialog >> privateImportModel [

	^ MiMooseModelsWrapper models: (FamixJavaFoldersImporter importFolders: self selectedFolders)
]

{ #category : #accessing }
MiImportModelFromFoldersDialog >> selectedFolders [

	^ foldersList items
]

{ #category : #accessing }
MiImportModelFromFoldersDialog >> userDescription [

	^ 'I am in interface to easily parse projects and import the resulting models into Moose.
For now I am only working for Java projects. This might change in the future depending on the needs Moose users have.
Bellow, you can select folders containing each a project to parse with the latest version of VerveineJ. If you wish to use your own VerveineJ version, a setting is available.'
]

{ #category : #action }
MiImportModelFromFoldersDialog >> validateImportForm [

	self selectedFolders ifEmpty: [ self error: 'Please select at least one folder.' ].
	self selectedFolders do: [ :folder | folder ifAbsent: [ self error: 'Selected folder does not exist.' ] ]
]
