Extension { #name : #MiInspector }

{ #category : #'*MooseIDE-NewTools-Tests' }
MiInspector >> firstPagePresenter [

	^ (self firstPage selectedPage activePresenter presenterAt: #view)
		  presenter
]
