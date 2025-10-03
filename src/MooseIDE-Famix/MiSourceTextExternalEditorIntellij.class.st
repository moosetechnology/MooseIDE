"
External source text editor using IntelliJ
"
Class {
	#name : 'MiSourceTextExternalEditorIntellij',
	#superclass : 'MiSourceTextFileExternalEditor',
	#classInstVars : [
		'editorCommand'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'as yet unclassified' }
MiSourceTextExternalEditorIntellij class >> editorCommand [

	^editorCommand ifNil: [ editorCommand := self platformCommand ]
]

{ #category : 'as yet unclassified' }
MiSourceTextExternalEditorIntellij class >> editorName [
	^'IntelliJ'
]

{ #category : 'as yet unclassified' }
MiSourceTextExternalEditorIntellij class >> platformCommand [

	^{ #Unix -> 'intellij-idea-ultimate' .
	  #Windows -> 'idea64' .
	  #MacOS -> 'idea' .
	  #MacOSX -> 'idea' } asDictionary 
		at: OSPlatform current family
]

{ #category : 'as yet unclassified' }
MiSourceTextExternalEditorIntellij class >> resetEditorCommand [

	editorCommand := nil
]

{ #category : 'file support' }
MiSourceTextExternalEditorIntellij >> openFile: aFileReference [

	MiExternalEditorOpenner open: aFileReference fullName using: self class editorCommand
]
