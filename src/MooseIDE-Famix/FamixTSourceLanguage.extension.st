Extension { #name : 'FamixTSourceLanguage' }

{ #category : '*MooseIDE-Famix' }
FamixTSourceLanguage classSide >> languageKeyWords [
	"List of keywords defined in the language

	For now created as an extension of MooseIDE-Famix because it is required by MiSourceTextBrowser
	 But could be a standard feature of Famix"

	^#()
]

{ #category : '*MooseIDE-Famix' }
FamixTSourceLanguage >> languageKeyWords [
	"For now defined as an extension of MooseIDE-Famix because it is required by MiSourceTextBrowser
	 But could be a standard feature of Famix"

	^self class languageKeyWords
]
