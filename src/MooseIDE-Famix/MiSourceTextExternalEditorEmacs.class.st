"
External source text editor using the Emacs editor
"
Class {
	#name : 'MiSourceTextExternalEditorEmacs',
	#superclass : 'MiSourceTextFileExternalEditor',
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'as yet unclassified' }
MiSourceTextExternalEditorEmacs class >> editorName [
	^'Emacs'
]

{ #category : 'file support' }
MiSourceTextExternalEditorEmacs >> openFile: aFileReference [
	MiExternalEditorOpenner open: aFileReference fullName using: 'emacs'
]
