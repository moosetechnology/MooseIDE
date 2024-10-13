"
A subclass of PharoLightTheme with the sole purpose of overriding #overTextCursorFor:

This changes the cursor in the rendere to a hand
(see MiSourceTextBrowser >> open)
"
Class {
	#name : #MiSourceTextRendererTheme,
	#superclass : #PharoLightTheme,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #cursor }
MiSourceTextRendererTheme >> overTextCursorFor: aTextMorph [

	^Cursor normal
]
