Extension { #name : #MiAtomicWorkspace }

{ #category : #'*MooseIDE-Tests' }
MiAtomicWorkspace >> actionButtons [

	^ (self window toolbarCommandGroup commandOrGroupNamed: 'Actions')
		  commands collect: #presenter
]

{ #category : #'*MooseIDE-Tests' }
MiAtomicWorkspace >> busButton [

	^ (self window toolbarCommandGroup commandOrGroupNamed: 'Buses')
		  presenter
]

{ #category : #'*MooseIDE-Tests' }
MiAtomicWorkspace class >> openForTests [

	^ (self
		   newApplication: MiTestApplication current
		   model: self newModel)
		  openWithSpec;
		  followBus: MiTestApplication current defaultBus;
		  yourself
]

{ #category : #'*MooseIDE-Tests' }
MiAtomicWorkspace >> privateReceivingMode: aMiBrowserReceivingMode [

	"DO NOT USE ME, I AM FOR TESTS"

	receivingMode := aMiBrowserReceivingMode
]
