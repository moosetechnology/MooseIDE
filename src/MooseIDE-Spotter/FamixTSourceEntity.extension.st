Extension { #name : #FamixTSourceEntity }

{ #category : #'*MooseIDE-Spotter' }
FamixTSourceEntity >> spotterPreview: aBuilder [

	^ aBuilder newCode
		  beNotEditable;
		  text: self sourceText;
		  yourself
]
