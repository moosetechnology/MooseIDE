"
External source text editor using the VSCodium editor
"
Class {
	#name : #MiSourceTextExternalEditorVSCodium,
	#superclass : #MiSourceTextFileExternalEditor,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextExternalEditorVSCodium class >> editorName [
	^'VS Codium'
]

{ #category : #'file support' }
MiSourceTextExternalEditorVSCodium >> openFile: aFileReference [

	MiExternalEditorOpenner open: aFileReference fullName using: 'codium'
]
