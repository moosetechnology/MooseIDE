"
A ""fake"" UITheme with the sole purpose of overriding #overTextCursorFor:

The new implementation changes the cursor in the rendered to a hand instead of a ""text cursor""
(see also MiSourceTextBrowser >> open)

Note: this could be a subclass of UITheme, but creating a theme is an heavy operation that we do not want to wait for.
So instead it is a simple object that forwards every message not understood to the real UITheme (a singleton).

There could be a problem if UITheme overrides a method of Object which will therefore not be NotUnderstood and will execute the default Object implementation instead of the UITheme implementation
This happens for #postCopy and we should think whether it needs to be treated in a special way.
"
Class {
	#name : #MiSourceTextRendererTheme,
	#superclass : #Object,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'reflective operations' }
MiSourceTextRendererTheme >> doesNotUnderstand: aMessage [
	"receiver is supposed to be a UITheme, so it forward any message not understood to the actual theme"

	^Smalltalk ui theme perform: aMessage selector withArguments: aMessage arguments
]

{ #category : #cursor }
MiSourceTextRendererTheme >> overTextCursorFor: aTextMorph [

	^ Cursor normal
]
