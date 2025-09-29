Extension { #name : #BlockClosure }

{ #category : #'*MooseIDE-CoUsageMap' }
BlockClosure >> runAsRoassalJobOn: aCanvas [
	^ MiJob new
		block: self;
		canvas: aCanvas;
		run
]
