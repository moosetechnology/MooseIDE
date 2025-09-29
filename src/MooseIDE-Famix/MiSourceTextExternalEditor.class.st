"
Abstract class for all external source text editors

It provides an abstract #open: method to open an external editor on a Famix entity

It also has a class side method #allExternalEditors to discover all available concrete sub-classes in the system.

"
Class {
	#name : #MiSourceTextExternalEditor,
	#superclass : #Object,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextExternalEditor class >> allExternalEditors [
	^self withAllSubclasses reject: [ :class | class isAbstract ]
]

{ #category : #'as yet unclassified' }
MiSourceTextExternalEditor class >> editorName [
	"All concrete subclasses should return a string
	returning nil is used to mark abstract (sub-)classes"
	^nil
]

{ #category : #testing }
MiSourceTextExternalEditor class >> isAbstract [
	^self editorName isNil
]

{ #category : #protocol }
MiSourceTextExternalEditor >> open: aMooseEntity [
	self subclassResponsibility 
]
