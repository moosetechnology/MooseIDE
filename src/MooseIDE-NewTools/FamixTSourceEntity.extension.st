Extension { #name : #FamixTSourceEntity }

{ #category : #'*MooseIDE-NewTools' }
FamixTSourceEntity >> miSourceInspectorExtension [

	<inspectorPresentationOrder: 3 title: 'SourceText'>
	^ SpCodePresenter new
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self sourceText;
		  beNotEditable
]
