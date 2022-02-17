Class {
	#name : #MiSourceTextExternalEditorVSCode,
	#superclass : #MiSourceTextFileExternalEditor,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextExternalEditorVSCode class >> editorName [
	^'VS Code'
]

{ #category : #'file support' }
MiSourceTextExternalEditorVSCode >> openFile: aFileReference [

	MiExternalEditorOpenner open: aFileReference fullName using: 'code'
]
