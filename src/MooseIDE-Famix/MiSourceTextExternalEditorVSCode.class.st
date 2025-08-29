"
External source text editor using VSCode
"
Class {
	#name : 'MiSourceTextExternalEditorVSCode',
	#superclass : 'MiSourceTextFileExternalEditor',
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'as yet unclassified' }
MiSourceTextExternalEditorVSCode class >> editorName [
	^'VS Code'
]

{ #category : 'file support' }
MiSourceTextExternalEditorVSCode >> openFile: aFileReference [

	MiExternalEditorOpenner open: aFileReference fullName using: 'code'
]
