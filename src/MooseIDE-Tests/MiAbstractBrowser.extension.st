Extension { #name : #MiAbstractBrowser }

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> actionButtons [

	^ (self window toolbarCommandGroup commandOrGroupNamed: 'Actions')
		  commands collect: #presenter
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> busButton [

	^ (self window toolbarCommandGroup commandOrGroupNamed: 'Buses')
		  presenter
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser class >> openForTests [

	^ (self
		   newApplication: MiTestApplication current
		   model: self newModel)
		  open;
		  followBus: MiTestApplication current defaultBus;
		  yourself
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> privateReceivingMode: aMiBrowserReceivingMode [

	"DO NOT USE ME, I AM FOR TESTS"

	receivingMode := aMiBrowserReceivingMode
]
