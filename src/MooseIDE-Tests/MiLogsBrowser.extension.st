Extension { #name : #MiLogsBrowser }

{ #category : #'*MooseIDE-Tests' }
MiLogsBrowser class >> openForTests: aTestApplication [

	^ (self newApplication: aTestApplication)
		  followBuses: aTestApplication buses;
		  open;
		  updateToolbars;
		  yourself
]
