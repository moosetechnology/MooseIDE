Extension { #name : #MiLogsBrowser }

{ #category : #'*MooseIDE-Tests' }
MiLogsBrowser class >> openForTests [

	^ (self newApplication: MiTestApplication current)
		  followBuses: MiTestApplication current buses;
		  openWithSpec;
		  updateToolbars;
		  yourself
]
