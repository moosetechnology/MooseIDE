"
I am a presenter that will allow the user to select one or multiple folders and that will generate a json file for each one. Then I'll import those files in the model browser.

For now, I only work with Java and the latest version of VerveineJ. In the future we could add other languages.
"
Class {
	#name : #MiImportModelFromFoldersDialog,
	#superclass : #MiImportModelDialog,
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

	^ 600 @ 250
]

{ #category : #layout }
MiImportModelFromFoldersDialog >> defaultLayout [

	^ SpGridLayout new
]

{ #category : #action }
MiImportModelFromFoldersDialog >> privateImportModel [
1halt
]

{ #category : #action }
MiImportModelFromFoldersDialog >> validateImportForm [
	1halt
]
