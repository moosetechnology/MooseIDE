Extension { #name : #FamixTSourceAnchor }

{ #category : #'*MooseIDE-NewTools' }
FamixTSourceAnchor >> miSourceInspectorExtension [

	<inspectorPresentationOrder: 4 title: 'SourceText'>
	^ SpCodePresenter new
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self sourceText;
		  beNotEditable
]
