Extension { #name : #MiAbstractBrowser2 }

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser2 class >> openForTests [
	self flag: 'CodeSmell: Application is set in the MiAtomicWorkspace and the MiAbstractBrowser'.
	^MiAtomicWorkspace new
		application: MiTestApplication current ;
		containedBrowser: (self
		   newApplication: MiTestApplication current
		   model: self newModel) ;
		openWithSpec ;
		followBus: MiTestApplication current defaultBus ;
		yourself
]
