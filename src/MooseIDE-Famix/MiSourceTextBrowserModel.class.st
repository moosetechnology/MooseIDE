Class {
	#name : #MiSourceTextBrowserModel,
	#superclass : #Object,
	#instVars : [
		'selected'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextBrowserModel >> formatedSource [
	| entityAnchor entityText|
	entityText := self sourceText ifEmpty: [ ^self noSourceCodeMessageFor: selected ].
	entityAnchor := selected sourceAnchor.
	^entityText

	
]

{ #category : #actions }
MiSourceTextBrowserModel >> noSourceCodeMessageFor: anEntity [
	| text |
	text := ('There is no source code to show for {1}'
		format: { anEntity name })
		asText.
	text addAttribute: (TextColor red) from: 1 to: 35.
	^text
]

{ #category : #accessing }
MiSourceTextBrowserModel >> selected [
	^ selected
]

{ #category : #accessing }
MiSourceTextBrowserModel >> selected: anObject [
	selected := anObject
]

{ #category : #accessing }
MiSourceTextBrowserModel >> sourceText [
	^ selected sourceText
]
