Extension { #name : #MiAbstractWorkspace }

{ #category : #'*MooseIDE-Tests' }
MiAbstractWorkspace >> busButton [

	^ (self window toolbarCommandGroup commandOrGroupNamed: 'Buses')
		  presenter
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractWorkspace class >> openForTests [

	^ (self
		   newApplication: MiTestApplication current
		   model: self newModel)
		  openWithSpec;
		  followBus: MiTestApplication current defaultBus;
		  yourself
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractWorkspace >> privateReceivingMode: aMiBrowserReceivingMode [

	"DO NOT USE ME, I AM FOR TESTS"

	receivingMode := aMiBrowserReceivingMode
]
