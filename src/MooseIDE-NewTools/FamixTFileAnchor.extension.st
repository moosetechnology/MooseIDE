Extension { #name : #FamixTFileAnchor }

{ #category : #'*MooseIDE-NewTools' }
FamixTFileAnchor >> miFullSourceInspectorExtension [

	<inspectorPresentationOrder: 5 title: 'Full sourceText'>
	^ SpCodePresenter new
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self completeText;
		  addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
				   interval: (self startPos to: self endPos + 1);
				   yourself);
		  beNotEditable
]
