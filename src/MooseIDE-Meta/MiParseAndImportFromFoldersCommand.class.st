"
I am a command to open a presenter that will allow the user to parse and import some projects all at once.
"
Class {
	#name : #MiParseAndImportFromFoldersCommand,
	#superclass : #MiImportCommand,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #default }
MiParseAndImportFromFoldersCommand class >> defaultDescription [

	^ 'This action allows one to select one or multiple folders and to parse all of them then import the generated json files in Moose.'
]

{ #category : #accessing }
MiParseAndImportFromFoldersCommand class >> defaultIcon [

	^ MooseIcons mooseTree
]

{ #category : #accessing }
MiParseAndImportFromFoldersCommand class >> defaultIconName [

	^ #mooseTree
]

{ #category : #default }
MiParseAndImportFromFoldersCommand class >> defaultName [

	^ 'Parse and import folders'
]

{ #category : #accessing }
MiParseAndImportFromFoldersCommand class >> importForm [

	^ MiImportModelFromFoldersDialog
]
