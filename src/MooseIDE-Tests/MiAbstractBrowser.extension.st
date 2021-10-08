Extension { #name : #MiAbstractBrowser }

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> actionButtons [

	^ (self toolbarCommandGroup commandOrGroupNamed: 'Actions') commands 
		  collect: #presenter
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> busButton [

	^ (self toolbarCommandGroup commandOrGroupNamed: 'Buses') presenter
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser class >> openForTests [

	^ (self
		   newApplication: MiTestApplication current
		   model: self newModel)
		  openWithSpec;
		  followBus: MiTestApplication current defaultBus;
		  yourself
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> privateReceivingMode: aMiBrowserReceivingMode [

	"DO NOT USE ME, I AM FOR TESTS"

	receivingMode := aMiBrowserReceivingMode
]
