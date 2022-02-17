"
Concrete class for a null highlighting that does not change the text
"
Class {
	#name : #MiSourceTextNullHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextNullHighlight >> applyTo: aRenderer [

]

{ #category : #'instance creation' }
MiSourceTextNullHighlight >> from [
	^0
]

{ #category : #formatting }
MiSourceTextNullHighlight >> rawText [
	^''
]

{ #category : #'instance creation' }
MiSourceTextNullHighlight >> to [
	^0
]
