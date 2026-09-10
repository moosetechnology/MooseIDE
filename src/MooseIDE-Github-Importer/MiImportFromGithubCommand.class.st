"
I am the command to open the Github importer UI (see MiGithubImportPresenter). I am displayed in the ""Import"" toolbar of the models browser with the other import commands.
"
Class {
	#name : 'MiImportFromGithubCommand',
	#superclass : 'MiImportCommand',
	#category : 'MooseIDE-Github-Importer-UI',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'UI'
}

{ #category : 'accessing' }
MiImportFromGithubCommand class >> defaultDescription [

	^ 'Download the sources of versions of a Github project and import them as models (Java only for now)'
]

{ #category : 'accessing' }
MiImportFromGithubCommand class >> defaultIcon [

	^ Smalltalk ui icons iconNamed: self defaultIconName
]

{ #category : 'accessing' }
MiImportFromGithubCommand class >> defaultIconName [

	^ #github
]

{ #category : 'accessing' }
MiImportFromGithubCommand class >> defaultName [

	^ 'Import from Github'
]

{ #category : 'accessing' }
MiImportFromGithubCommand class >> importForm [

	^ MiGithubImportPresenter
]
