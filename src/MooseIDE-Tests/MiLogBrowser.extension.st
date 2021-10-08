Extension { #name : #MiLogBrowser }

{ #category : #'*MooseIDE-Tests' }
MiLogBrowser >> logsList [
	^ logsLists
]

{ #category : #'*MooseIDE-Tests' }
MiLogBrowser class >> openForTestsOnBus: aBus [

	^ (self newApplication: MiTestApplication current)
		  openWithSpec;
		  followBus: aBus;
		  yourself
]
