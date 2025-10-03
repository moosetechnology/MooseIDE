"
Abstract class for all highlights that we may apply on a portion of text.

These highlights are ""conceptual"" (e.g. ErrorHighlight)
How these highlights are displayed depends on the MiSourceTextXXXRenderer

An highlight applies:
- on a #referenceSource text
- from a #highlightesEntity
- on an #interval (from/to) of this text
"
Class {
	#name : 'MiSourceTextHighlight',
	#superclass : 'Object',
	#instVars : [
		'highlightedEntity',
		'highlightInterval'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'formatting' }
MiSourceTextHighlight >> adaptSourceAnchorWith: aSourceAnchorAdapter [

	^highlightInterval := aSourceAnchorAdapter intervalForEntity: self highlightedEntity
]

{ #category : 'formatting' }
MiSourceTextHighlight >> applyTo: aRenderer [

	self subclassResponsibility 
]

{ #category : 'accessing' }
MiSourceTextHighlight >> from [

	^highlightInterval first
]

{ #category : 'testing' }
MiSourceTextHighlight >> hasInterval [

	^highlightInterval isNotNil
]

{ #category : 'accessing' }
MiSourceTextHighlight >> highlightInterval: anObject [

	^ highlightInterval := anObject
]

{ #category : 'accessing' }
MiSourceTextHighlight >> highlightedEntity [

	^ highlightedEntity
]

{ #category : 'accessing' }
MiSourceTextHighlight >> highlightedEntity: anObject [

	highlightedEntity := anObject
]

{ #category : 'accessing' }
MiSourceTextHighlight >> to [

	^highlightInterval last
]
