Class {
	#name : #MiSourceTextExternalEditorEmacs,
	#superclass : #MiSourceTextFileExternalEditor,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextExternalEditorEmacs class >> editorName [
	^'Emacs'
]

{ #category : #'file support' }
MiSourceTextExternalEditorEmacs >> openFile: aFileReference [
	LibC uniqueInstance runCommand: 'emacs ' , aFileReference fullName 
]
